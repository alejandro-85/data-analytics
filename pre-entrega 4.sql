use Ventas_Tech_DB

--consulta numero 1-- --Resumen ejecutivo mensual--
	
select 
MONTH ( fecha_venta) as mes,
sum(cantidad*precio_unitario) as total_facturado,
count(*) as catidad_pedidos,
avg(cantidad*precio_unitario) as ticket_promerdio
from Ventas
group by MONTH ( fecha_venta) 
order by mes ;

--consulta 2 -- --Ranking de productos 

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM Ventas
GROUP BY id_producto
ORDER BY total_facturado desc;

--consulta 3--  -- clientes recurrentes --

select  id_cliente,
count(*) as cantidad_pedidos,
sum(cantidad*precio_unitario) as total_facturado

from Ventas
group by id_cliente
HAVING COUNT(*) > 1
ORDER BY total_facturado DESC;


----consulta 4-- mese por encima / por debajo del promedio ------------------------------------------

WITH FacturacionMensual AS (
    SELECT
        YEAR(fecha_venta) AS Anio,
        MONTH(fecha_venta) AS Mes,
        SUM(cantidad*precio_unitario) AS TotalFacturado
    FROM Ventas
    GROUP BY
        YEAR(fecha_venta),
        MONTH(fecha_venta)
),
PromedioMensual AS (
    SELECT
        Anio,
        Mes,
        TotalFacturado,
        AVG(CAST(TotalFacturado AS DECIMAL(18, 2)))
            OVER () AS PromedioGeneral
    FROM FacturacionMensual
)
SELECT
    Anio,
    Mes,
    TotalFacturado,
    PromedioGeneral,
    CASE
        WHEN TotalFacturado > PromedioGeneral
            THEN 'Por encima'
        WHEN TotalFacturado < PromedioGeneral
            THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS Comparacion
FROM PromedioMensual
ORDER BY Anio, Mes;

----------conclusion----------------
--el prducto id_producto (1) concentra el 56% de la facturacion mensual --

--el prducto id_producto (2) fue el mas vendios reprecesnto 50% del total de productos vendidos el mes 

-- el  mes 3 se mantuvo igual al premdio de ventas mensuales ---