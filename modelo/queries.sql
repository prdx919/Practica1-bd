-- ============================================================================
-- Consultas SQL de Reportes Operativos (Ejercicio 5)
-- Sistema de Registro y Control de Préstamos (SRCP)
-- ============================================================================

-- 1. Reporte de Morosidad Activa (Usuarios con préstamos vencidos)
SELECT 
    u.identificador_institucional AS boleta_empleado,
    CONCAT(u.nombre, ' ', u.apellido_paterno, ' ', COALESCE(u.apellido_materno, '')) AS nombre_completo,
    u.email,
    u.telefono,
    p.folio AS folio_prestamo,
    ic.titulo AS recurso_prestado,
    e.codigo_barras,
    dp.fecha_devolucion_esperada,
    CURRENT_DATE - dp.fecha_devolucion_esperada AS dias_mora
FROM detalle_prestamo dp
JOIN prestamo p ON dp.id_prestamo = p.id_prestamo
JOIN usuario u ON p.id_usuario = u.id_usuario
JOIN ejemplar e ON dp.id_ejemplar = e.id_ejemplar
JOIN item_catalogo ic ON e.id_item = ic.id_item
WHERE dp.fecha_devolucion_real IS NULL
  AND dp.fecha_devolucion_esperada < CURRENT_DATE
ORDER BY dias_mora DESC;

-- 2. Reporte de Recursos Más Solicitados (Top Demanda de Hardware y Libros)
SELECT 
    ic.codigo_catalogo,
    ic.titulo,
    ic.tipo_recurso,
    COUNT(dp.id_detalle) AS total_prestamos
FROM item_catalogo ic
JOIN ejemplar e ON ic.id_item = e.id_item
JOIN detalle_prestamo dp ON e.id_ejemplar = dp.id_ejemplar
GROUP BY ic.id_item, ic.codigo_catalogo, ic.titulo, ic.tipo_recurso
ORDER BY total_prestamos DESC
LIMIT 10;
