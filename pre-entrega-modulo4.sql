
-- CONSULTA 1: RENTABILIDAD POR CATEGORIA

SELECT
    p.categoria AS nombre_categoria,
    SUM(v.cantidad) AS unidades_vendidas,
    SUM(v.cantidad * v.precio_unitario) AS ingreso_total
FROM ventas v
INNER JOIN productos p
    ON v.id_producto = p.id_producto
GROUP BY p.categoria
HAVING SUM(v.cantidad * v.precio_unitario) > 1000
ORDER BY ingreso_total DESC;

-- ============================================================

-- CONSULTA 2: CLIENTES SIN COMPRAS

SELECT
    c.id_cliente,
    c.nombre AS nombre_cliente,
    COALESCE(COUNT(v.id_venta), 0) AS cantidad_compras
FROM clientes c
LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nombre
HAVING COUNT(v.id_venta) = 0
ORDER BY c.nombre;


-- ============================================================

-- CONSULTA 3: TOP DE COMPRAS POR CLIENTE

SELECT
    c.id_cliente,
    c.nombre AS nombre_cliente,
    (
        SELECT p2.nombre
        FROM ventas v2
        INNER JOIN productos p2
            ON v2.id_producto = p2.id_producto
        WHERE v2.id_cliente = c.id_cliente
        GROUP BY p2.id_producto, p2.nombre
        ORDER BY COUNT(*) DESC, p2.nombre ASC
        LIMIT 1
    ) AS producto_mas_comprado,
    MAX(v.fecha_venta) AS ultima_transaccion
FROM clientes c
INNER JOIN ventas v
    ON c.id_cliente = v.id_cliente
INNER JOIN productos p
    ON v.id_producto = p.id_producto
GROUP BY c.id_cliente, c.nombre
ORDER BY c.nombre;


