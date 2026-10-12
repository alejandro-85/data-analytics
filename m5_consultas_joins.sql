use Ventas_Tech_DB

--consigna 1 -----------
	
SELECT
    v.fecha_venta AS fecha,
    c.id_cliente AS id_cliente,
    c.nombre AS nombre_cliente,
    p.nombre_producto AS descripcion_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    c.ciudad,
    v.precio_unitario,
    CAST(v.cantidad * v.precio_unitario AS DECIMAL(12,2))
        AS total_venta
FROM Ventas AS v
INNER JOIN Clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN Productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN Categorias AS cat
    ON p.id_categoria = cat.id_categoria
ORDER BY
    v.fecha_venta DESC;
   
   -----------consulta 2-----------

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM Clientes AS c
LEFT JOIN Ventas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.nombre;

--------consulta 3------------
SELECT
    p.nombre_producto AS nombre_producto,
    c.nombre_categoria AS categoria,
    p.precio
FROM Productos AS p
INNER JOIN Categorias AS c
    ON p.id_categoria = c.id_categoria
LEFT JOIN Ventas AS v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL
ORDER BY p.nombre_producto;

-------consulta 4-----------------
WITH VentasPorCanal AS (
    SELECT
        'Periodo anterior' AS canal,
        cantidad * precio_unitario AS total_venta
    FROM Ventas
    WHERE fecha_venta < '20261001'

    UNION ALL

    SELECT
        'Periodo actual' AS canal,
        cantidad * precio_unitario AS total_venta
    FROM Ventas
    WHERE fecha_venta >= '20261001'
)
SELECT
    canal,
    COUNT(*) AS cantidad_ventas,
    SUM(total_venta) AS total_facturado
FROM VentasPorCanal
GROUP BY canal
ORDER BY canal;

---Primer SELECT: obtiene las ventas anteriores al 1 de octubre de 2026 
--y asigna el literal 'Periodo anterior' a la columna canal.--
---Segundo SELECT: obtiene las ventas desde el 1 de octubre de 2026 
--y asigna 'Periodo actual'.