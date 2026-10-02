-- ==================================
-- Tech Store - Script SQL
-- Autor: Lucia Ramos
-- Fecha: 25-09-2026
-- ==================================

-- ===== SECCIÓN 0: CREATE DB =====
-- Crear la base de datos y seleccionarla
	IF DB_ID('ventas_tech_db') IS NULL
		CREATE DATABASE ventas_tech_db;
	GO
	USE ventas_tech_db;
	GO

-- ===== SECCIÓN 1: DROP TABLES =====
-- Eliminar las tablas si ya existen, en orden inverso a las dependencias.
	DROP TABLE IF EXISTS ventas;
	DROP TABLE IF EXISTS calendario;
	DROP TABLE IF EXISTS clientes;
	DROP TABLE IF EXISTS vendedor;
	DROP TABLE IF EXISTS productos;
	DROP TABLE IF EXISTS canal;
	DROP TABLE IF EXISTS territorio;
	DROP TABLE IF EXISTS categorias;
	GO

-- ===== SECCIÓN 2: CREATE TABLES =====
-- Crear las tablas, según su dependencia (primero las que no dependen de nadie).
	CREATE TABLE calendario(
		id_fecha			INT PRIMARY KEY,
		fecha				DATE NOT NULL,
		año					SMALLINT NOT NULL,
		trimestre			TINYINT NOT NULL,
		mes					TINYINT NOT NULL,
		nombre_mes			NVARCHAR(15) NOT NULL,
		dia_semana			NVARCHAR(15) NOT NULL
		);

	CREATE TABLE clientes(
		id_cliente		INT PRIMARY KEY,
		nombre			NVARCHAR(100) NOT NULL,
		email			NVARCHAR(100) UNIQUE,
		telefono		NVARCHAR(50),
		segmento		NVARCHAR(30),
		fecha_registro	DATE NOT NULL
		);
	
	CREATE TABLE vendedor(
		id_vendedor		INT PRIMARY KEY,
		nombre			NVARCHAR(100) NOT NULL
		);

	CREATE TABLE productos(
		id_producto		INT PRIMARY KEY,
		nombre_producto	NVARCHAR(100) NOT NULL,
		categoria		NVARCHAR(30),
		subcategoria	NVARCHAR(30),
		precio			DECIMAL(10,2) NOT NULL,
		costo			DECIMAL(10,2)
		);

	CREATE TABLE canal(
		id_canal		INT PRIMARY KEY,
		canal			NVARCHAR(30) NOT NULL
		);

	CREATE TABLE territorio(
		id_territorio	INT PRIMARY KEY,
		region			NVARCHAR(100),
		país			NVARCHAR(100),
		zona			NVARCHAR(100)
		);

	CREATE TABLE ventas(
		id_venta		INT PRIMARY KEY,
		id_fecha		INT NOT NULL FOREIGN KEY REFERENCES calendario(id_fecha),
		id_cliente		INT NOT NULL FOREIGN KEY REFERENCES clientes(id_cliente),
		id_producto		INT NOT NULL FOREIGN KEY REFERENCES productos(id_producto),
		id_vendedor		INT NOT NULL FOREIGN KEY REFERENCES vendedor(id_vendedor),
		id_canal		INT NOT NULL FOREIGN KEY REFERENCES canal(id_canal),
		id_territorio	INT NOT NULL FOREIGN KEY REFERENCES territorio(id_territorio),
		cantidad		INT NOT NULL,
		precio_unidad	DECIMAL(10,2) NOT NULL,
		total_venta		AS CAST(cantidad * precio_unidad AS DECIMAL(10,2)) PERSISTED
		);
	GO

-- ===== SECCIÓN 3: INSERT DATA =====
-- Cargar registros, en orden (primero las tablas sin dependencias).
	INSERT INTO calendario (id_fecha, fecha, año, trimestre, mes, nombre_mes, dia_semana) VALUES
	(20240301, '2024-03-01', 2024, 1, 3, N'Marzo', N'Viernes'),
	(20240302, '2024-03-02', 2024, 1, 3, N'Marzo', N'Sábado'),
	(20240303, '2024-03-03', 2024, 1, 3, N'Marzo', N'Domingo'),
	(20240304, '2024-03-04', 2024, 1, 3, N'Marzo', N'Lunes'),
	(20240305, '2024-03-05', 2024, 1, 3, N'Marzo', N'Martes'),
	(20240306, '2024-03-06', 2024, 1, 3, N'Marzo', N'Miércoles'),
	(20240307, '2024-03-07', 2024, 1, 3, N'Marzo', N'Jueves'),
	(20240308, '2024-03-08', 2024, 1, 3, N'Marzo', N'Viernes'),
	(20240309, '2024-03-09', 2024, 1, 3, N'Marzo', N'Sábado'),
	(20240310, '2024-03-10', 2024, 1, 3, N'Marzo', N'Domingo'),
	(20240311, '2024-03-11', 2024, 1, 3, N'Marzo', N'Lunes'),
	(20240312, '2024-03-12', 2024, 1, 3, N'Marzo', N'Martes'),
	(20240313, '2024-03-13', 2024, 1, 3, N'Marzo', N'Miércoles'),
	(20240314, '2024-03-14', 2024, 1, 3, N'Marzo', N'Jueves'),
	(20240315, '2024-03-15', 2024, 1, 3, N'Marzo', N'Viernes');
 
	INSERT INTO clientes (id_cliente, nombre, email, telefono, segmento, fecha_registro) VALUES
	(1, N'María López',  'maria@mail.com',  '+54 11 5555-0101', N'Corporativo', '2024-01-05'),
	(2, N'Carlos Ruiz',  'carlos@mail.com', '+54 351 555-0102', N'Consumidor',  '2024-01-10'),
	(3, N'Ana Gómez',    'ana@mail.com',    '+54 341 555-0103', N'Pyme',        '2024-02-01'),
	(4, N'Pedro Sanz',   'pedro@mail.com',  '+54 261 555-0104', N'Consumidor',  '2024-02-15'),
	(5, N'Laura Torres', 'laura@mail.com',  '+54 381 555-0105', N'Corporativo', '2024-03-01');
 
	INSERT INTO vendedor (id_vendedor, nombre) VALUES
	(1, N'Sofía Herrera'),
	(2, N'Diego Fernández'),
	(3, N'Valentina Castro');
 
	INSERT INTO productos (id_producto, nombre_producto, categoria, subcategoria, precio, costo) VALUES
	(1, N'Laptop Pro 15',      N'Computación',    N'Laptops',     1200.00, 900.00),
	(2, N'Mouse Inalámbrico',  N'Accesorios',     N'Mouse',         28.00,  15.00),
	(3, N'Monitor 4K 27',      N'Computación',    N'Monitores',    450.00, 320.00),
	(4, N'Auriculares BT Pro', N'Audio',          N'Auriculares',  120.00,  70.00),
	(5, N'SSD Externo 1TB',    N'Almacenamiento', N'Discos',       130.00,  85.00),
	(6, N'Teclado Mecánico',   N'Accesorios',     N'Teclados',      95.00,  55.00);
 
	INSERT INTO canal (id_canal, canal) VALUES
	(1, N'Online'),
	(2, N'Tienda física'),
	(3, N'Corporativo');
 
	INSERT INTO territorio (id_territorio, region, país, zona) VALUES
	(1, N'Centro',   N'Argentina', N'Buenos Aires'),
	(2, N'Centro',   N'Argentina', N'Córdoba'),
	(3, N'Litoral',  N'Argentina', N'Rosario'),
	(4, N'Cuyo',     N'Argentina', N'Mendoza'),
	(5, N'Noroeste', N'Argentina', N'Tucumán');
 
	INSERT INTO ventas (id_venta, id_fecha, id_cliente, id_producto, id_vendedor, id_canal, id_territorio, cantidad, precio_unidad) VALUES
	( 1, 20240305, 1, 1, 1, 1, 1, 2, 1200.00),
	( 2, 20240306, 2, 2, 2, 1, 2, 5,   28.00),
	( 3, 20240307, 3, 3, 3, 2, 3, 1,  450.00),
	( 4, 20240308, 1, 4, 1, 1, 1, 2,  120.00),
	( 5, 20240310, 4, 5, 2, 3, 4, 3,  130.00),
	( 6, 20240311, 2, 6, 3, 2, 2, 4,   95.00),
	( 7, 20240312, 5, 1, 1, 3, 5, 1, 1200.00),
	( 8, 20240313, 3, 2, 2, 1, 3, 8,   28.00),
	( 9, 20240314, 4, 4, 3, 2, 4, 1,  120.00),
	(10, 20240315, 5, 3, 1, 1, 5, 2,  450.00);

-- ===== SECCIÓN 4: VALIDACIÓN =====
-- Cerrar el script con las siguientes consultas.
	SELECT * FROM calendario;   -- esperado: 15 filas
	SELECT * FROM clientes;     -- esperado: 5 filas
	SELECT * FROM vendedor;     -- esperado: 3 filas
	SELECT * FROM productos;    -- esperado: 6 filas
	SELECT * FROM canal;        -- esperado: 3 filas
	SELECT * FROM territorio;   -- esperado: 5 filas
	SELECT * FROM ventas;       -- esperado: 10 filas
