-- ══════════════════════════════════════════════════════════════════════════════════════════════════════
-- Consultas de Negocio - RetailPro
-- Autor: Lucia Ramos
-- Fecha: 02-10-2026
-- ══════════════════════════════════════════════════════════════════════════════════════════════════════

USE ventas_tech_db

-- ═════ CONSULTA 1 - Resumen ejecutivo mensual ═════
-- Total facturado, cantidad de pedidos y ticket promedio, agrupados por mes. 
-- Calcular el total como cantidad * precio_unitario. 
-- Usar alias descriptivos en español y agrupar por mes con EXTRACT(MONTH FROM fecha_venta).

	SELECT
				MONTH(fecha_venta)				AS mes_venta,
				SUM(cantidad * precio_unitario) AS total_facturado,
				COUNT(id_venta)					AS cantidad_pedidos,
				AVG(cantidad * precio_unitario) AS ticket_promedio
	FROM		ventas
	GROUP BY	MONTH(fecha_venta);

-- ═════ CONSULTA 2 - Ranking de productos ═════
-- Top 5 de id_producto por total facturado, mostrando las unidades vendidas (SUM(cantidad)) y el total generado. 
-- Usar GROUP BY id_producto, ORDER BY y limitá el resultado a 5.

	SELECT TOP 5
				id_producto,
				SUM(cantidad) AS unidades_vendidas,
				SUM(cantidad * precio_unitario) AS total_facturado
	FROM		ventas
	GROUP BY	id_producto
	ORDER BY	SUM(cantidad * precio_unitario) DESC;

-- ═════ CONSULTA 3 - Clientes recurrentes ═════
-- id_cliente que hayan realizado más de un pedido, mostrando la cantidad de pedidos y el total gastado. 
-- Usar GROUP BY id_cliente y HAVING COUNT(*) > 1.
	SELECT 
				id_cliente, 
				COUNT(*)						AS cantidad_pedidos, 
				SUM(cantidad * precio_unitario) AS total_gastado
	FROM		ventas
	GROUP BY	id_cliente
	HAVING		COUNT(*) > 1;

-- ═════ CONSULTA 4 - Meses por encima/por debajo del promedio ═════
-- Total facturado por mes, con una columna adicional que etiquete con CASE WHEN si ese mes quedó 'Por encima' o 'Por debajo' del promedio mensual general.
	SELECT
					MONTH(fecha_venta)              AS mes_venta,
					SUM(cantidad * precio_unitario) AS total_facturado,
		CASE
			WHEN	SUM(cantidad * precio_unitario) > 6444   -- el número del paso 1
			THEN		'Por encima'
			ELSE		'Por debajo'
		END AS		comparacion_promedio
	FROM			ventas
	GROUP BY		MONTH(fecha_venta);

-- ════════════════════ Hallazgos concretos ════════════════════
-- - Producto 1: factura $3600 de $6444, o sea un 55,9%, con solo 3 unidades. El producto 2 vende 13 unidades pero factura solo $364.
-- - Clientes: los 5 compraron exactamente 2 veces (100% recurrentes). El cliente 1 gastó más: $2640, cerca del 41% del total.
-- - Marzo: todas las ventas son de un solo mes, así que la comparación contra el promedio no es significativa.