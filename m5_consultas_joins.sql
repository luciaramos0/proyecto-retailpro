-- ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
-- Consultas con JOINs para el proyecto - RetailPro
-- Autor: Lucia Ramos
-- Fecha: 03-10-2026
-- ════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

-- ──────────────────────────────────── Cambios respecto al esquema del Checkpoint 3 ────────────────────────────────────
-- El esquema original (categorias, clientes, productos, ventas) se rediseñó como un modelo en estrella,
-- siguiendo el diagrama de RetailPro de la pre entrega 2. 
-- ventas pasó a ser la tabla de hechos y se agregaron 4 dimensiones.

-- Tablas:
--   - Nuevas: calendario, vendedor, canal y territorio (región, país y zona).
--   - Eliminada: categorias. Ahora categoria y subcategoria son columnas de productos.

-- Columnas:
--   - clientes: se quitó ciudad (ahora vive en territorio) y se agregaron telefono y segmento.
--   - productos: se quitaron id_categoria, stock y activo; se agregaron categoria, subcategoria y costo.
--   - ventas: fecha_venta se reemplazó por id_fecha (FK a calendario); precio_unitario pasó a llamarse
--     precio_unidad; se agregaron id_vendedor, id_canal e id_territorio, y total_venta (columna calculada).
--   - calendario.año es SMALLINT (y no TINYINT) porque TINYINT no admite valores como 2024.
--
-- Datos agregados para esta entrega:
--   - Cliente 6 (Mariano Ramos) y producto 7 (Adaptador), sin ventas, para poder comprobar las consultas 2 y 3.
	
	USE ventas_tech_db

-- ──────────────────────────────────── CONSULTA 1 - Vista base del proyecto (INNER JOIN) ────────────────────────────────────
-- Trabajar sobre el esquema creado en el Checkpoint del Módulo 3. 
-- Combinar con INNER JOIN la tabla de ventas con las tablas descriptivas que se hayan modelado para obtener en una sola fila, como mínimo.
-- Sumar además las columnas descriptivas que existan en esquema creado. 
	SELECT
				v.id_venta,
				cal.fecha,
				cl.id_cliente,
				cl.nombre			AS nombre_cliente,
				cl.segmento,
				p.nombre_producto,
				p.categoria,
				p.subcategoria,
				ven.nombre			AS nombre_vendedor,
				c.canal,
				t.region,
				t.pais,
				t.zona,
				v.cantidad,
				v.precio_unidad,
				v.total_venta
	FROM		ventas		AS v
	INNER JOIN	calendario	AS cal	ON v.id_fecha     = cal.id_fecha
	INNER JOIN	clientes	AS cl	ON v.id_cliente   = cl.id_cliente
	INNER JOIN	productos	AS p	ON v.id_producto  = p.id_producto
	INNER JOIN	vendedor	AS ven	ON v.id_vendedor  = ven.id_vendedor
	INNER JOIN	canal		AS c	ON v.id_canal     = c.id_canal
	INNER JOIN	territorio	AS t	ON v.id_territorio = t.id_territorio;

-- ──────────────────────────────────── CONSULTA 2 - Clientes sin ventas (LEFT JOIN) ────────────────────────────────────
-- Identificar clientes registrados que aún no han realizado ninguna compra. 
-- Mostrar su nombre, email y fecha de registro. 
-- Usar WHERE ... IS NULL para aislar los casos.
	SELECT 
					cl.id_cliente,
					cl.nombre,
					cl.email,
					cl.fecha_registro
	FROM			clientes	AS cl
	LEFT JOIN		ventas		AS v	ON cl.id_cliente = v.id_cliente
	WHERE			v.id_venta IS NULL

-- ──────────────────────────────────── CONSULTA 3 - Productos sin ventas (LEFT JOIN) ────────────────────────────────────
-- Identificar productos del catálogo que no tienen ninguna venta registrada. 
-- Mostrar nombre del producto, categoría y precio. 
-- Usá WHERE ... IS NULL.
	SELECT
				p.nombre_producto,
				p.categoria,
				p.precio
	FROM 		productos	AS p
	LEFT JOIN	ventas		AS v	ON p.id_producto = v.id_producto
	WHERE		v.id_venta IS NULL;

-- ──────────────────────────────────── CONSULTA 4 - Consolidado por canal (UNION ALL) ────────────────────────────────────
-- Escribir dos SELECT sobre las ventas, separados por el criterio que corresponda a tu caso (por ejemplo, ventas de dos períodos, dos sucursales o dos orígenes distintos)
-- Agregar en cada uno una columna de texto fija que identifique el origen. Unirlos con UNION ALL y cerrar con un GROUP BY para obtener el total por cada origen.
-- La estructura es esta:
--		SELECT fecha, total, 'Online' AS canal FROM ventas WHERE ... UNION ALL SELECT fecha, total, 'Presencial' AS canal FROM ventas WHERE ...
-- Las dos consultas tienen que devolver la misma cantidad de columnas, en el mismo orden y con tipos compatibles. 
-- Usamos UNION ALL y no UNION porque no queremos que se eliminen filas repetidas: cada venta debe contarse una sola vez, aunque coincida con otra en todos sus valores.
SELECT		'Online'		AS canal,
			COUNT(*)		AS cantidad_ventas,
			SUM(total_venta)	AS total_facturado
FROM		ventas
WHERE		id_canal = 1

UNION ALL

SELECT		'Presencial'	AS canal,
			COUNT(*)		AS cantidad_ventas,
			SUM(total_venta)	AS total_facturado
FROM		ventas
WHERE		id_canal IN (2,3);