# RetailPro – Análisis de ventas con SQL Server y Power BI

Proyecto de análisis de datos para **RetailPro**, una distribuidora de tecnología. Reúne el diseño de la base de datos, las consultas SQL de negocio, el pipeline de limpieza en Power Query y el modelo analítico con medidas DAX en Power BI.

## Problema de negocio

> ¿Por qué las ventas de la categoría Notebooks cayeron un 18 % en la región Centro durante el último semestre, y qué combinación de canal de venta y tipo de cliente explica esa caída?

El brief completo (KPIs, preguntas de análisis y boceto del dashboard) está en el PDF de la pre-entrega 1.

## Herramientas utilizadas

| Herramienta | Uso |
|---|---|
| SQL Server (17.0) | Base de datos `ventas_tech_db`, consultas de negocio y JOINs |
| Power BI Desktop | Modelo de datos, relaciones y reportes |
| Power Query / lenguaje M | Limpieza y transformación (ETL) |
| DAX | Medidas del modelo (Total Ventas, YTD, año anterior, crecimiento) |
| Canva | Boceto del dashboard |

## Modelo de datos (esquema en estrella)

La tabla de hechos `ventas` se conecta con seis dimensiones mediante relaciones 1:N:

- `calendario` (id_fecha, fecha, año, trimestre, mes, nombre_mes, dia_semana)
- `clientes` (id_cliente, nombre, email, telefono, segmento, fecha_registro)
- `productos` (id_producto, nombre_producto, categoria, subcategoria, precio, costo)
- `vendedor` (id_vendedor, nombre)
- `canal` (id_canal, canal)
- `territorio` (id_territorio, region, pais, zona)
- **`ventas`** (id_venta, id_fecha, id_cliente, id_producto, id_vendedor, id_territorio, id_canal, cantidad, precio_unidad, total_venta)

El diagrama ER y la justificación de normalización están en el PDF de la pre-entrega 2.

## Estructura del repositorio

```
RetailPro/
├── README.md
├── sql/
│   ├── [script de creación del esquema en estrella]
│   ├── m4_consultas_negocio.sql
│   └── m5_consultas_joins.sql
├── powerbi/
│   ├── Pipeline_ETL_Ramos_Lucia.pbix
│   └── Ramos_Lucia_Checkpoint2.pbix
└── docs/
    └── PDFs de las pre-entregas
```

## Cómo ejecutar los scripts SQL

**Requisitos:** SQL Server y un cliente para ejecutar scripts (por ejemplo, SQL Server Management Studio).

1. Crear la base de datos `ventas_tech_db` y las siete tablas del esquema en estrella (script de creación del esquema).
2. Cargar los datos de ejemplo en las tablas.
3. Ejecutar `m4_consultas_negocio.sql`: resumen mensual, ranking de productos, clientes recurrentes y comparación contra el promedio.
4. Ejecutar `m5_consultas_joins.sql`: vista base (INNER JOIN), clientes y productos sin ventas (LEFT JOIN) y consolidado por canal (UNION ALL).

Cada archivo comienza con `USE ventas_tech_db`, por lo que basta con abrirlo y ejecutarlo. Las consultas pueden correrse una por una, seleccionándolas.

## Resultados de ejemplo (m4)

Con los datos cargados actualmente, todas las ventas corresponden a marzo:

| Mes | Total facturado | Pedidos | Ticket promedio |
|---|---|---|---|
| Marzo | 6.444,00 | 10 | 644,40 |

Top 5 de productos por facturación:

| id_producto | Unidades vendidas | Total facturado |
|---|---|---|
| 1 | 3 | 3.600,00 |
| 3 | 3 | 1.350,00 |
| 5 | 3 | 390,00 |
| 6 | 4 | 380,00 |
| 2 | 13 | 364,00 |

## Modelo analítico en Power BI

El archivo `Ramos_Lucia_Checkpoint2.pbix` contiene:

- Relaciones 1:N con filtro en dirección única (dimensión → hechos).
- Tabla calendario `Dim_Fechas`, marcada como tabla de fechas.
- Tabla `_Medidas` con cinco medidas: `Total Ventas`, `Ventas Online`, `Ventas YTD`, `Ventas LY` y `% Crecimiento Anual`.
- Página de validación con una matriz mes × año.

## Notas importantes

- **Power BI y SQL usan conjuntos de datos distintos.** El modelo de Power BI parte de un archivo Excel (`Fact_Ventas`, `Dim_Productos`, etc.) y el de SQL sigue el esquema en estrella del diseño del proyecto.
- **Los totales no coinciden entre ambos.** Las consultas SQL calculan `cantidad * precio_unidad` (sin descuento), mientras que `total_venta` en Power BI ya incluye el descuento.
- Los datos de ejemplo son de práctica y cubren un período corto, por lo que los resultados no deben interpretarse como tendencias.

## Autora

Lucía Ramos – proyecto del curso de Data Science.
