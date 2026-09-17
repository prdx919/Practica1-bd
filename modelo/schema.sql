-- ============================================================================
-- INSTITUTO POLITÉCNICO NACIONAL
-- Escuela Superior de Cómputo / UPIITA
-- Ingeniería en Inteligencia Artificial - Bases de Datos (Plan 2020)
-- Práctica 1: Modelo Entidad Relación
-- Alumno: Cesar Javier Martinez Ruiz (Boleta: 2024630871, Grupo: 3BV1)
-- ============================================================================

-- Esquema DDL para PostgreSQL 16
-- Base de Datos: practica1
-- Dominio: Sistema de Registro y Control de Préstamos (SRCP)

-- 1. Tipos ENUM para dominios controlados
CREATE TYPE tipo_usuario_enum AS ENUM ('ALUMNO', 'DOCENTE', 'ADMINISTRATIVO');
CREATE TYPE estado_cuenta_enum AS ENUM ('ACTIVO', 'SANCIONADO', 'INACTIVO');
CREATE TYPE tipo_recurso_enum AS ENUM ('BIBLIOGRAFICO', 'TECNOLOGICO');
CREATE TYPE estado_ejemplar_enum AS ENUM ('DISPONIBLE', 'PRESTADO', 'REPARACION', 'BAJA');
CREATE TYPE estado_prestamo_enum AS ENUM ('ACTIVO', 'FINALIZADO', 'CON_MORA');
CREATE TYPE estado_pago_enum AS ENUM ('PENDIENTE', 'PAGADO', 'CONDONADO');

-- 2. Entidad: USUARIO
CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    identificador_institucional VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(60) NOT NULL,
    apellido_paterno VARCHAR(60) NOT NULL,
    apellido_materno VARCHAR(60),
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(15),
    tipo_usuario tipo_usuario_enum NOT NULL DEFAULT 'ALUMNO',
    estado_cuenta estado_cuenta_enum NOT NULL DEFAULT 'ACTIVO',
    fecha_registro TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. Entidad Superclase: ITEM_CATALOGO
CREATE TABLE item_catalogo (
    id_item SERIAL PRIMARY KEY,
    codigo_catalogo VARCHAR(30) NOT NULL UNIQUE,
    titulo VARCHAR(150) NOT NULL,
    clasificacion VARCHAR(50) NOT NULL,
    tipo_recurso tipo_recurso_enum NOT NULL,
    descripcion TEXT
);

-- 4. Subclase: LIBRO (Material Bibliográfico)
CREATE TABLE libro (
    id_item INTEGER PRIMARY KEY REFERENCES item_catalogo(id_item) ON DELETE CASCADE,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    editorial VARCHAR(80) NOT NULL,
    edicion SMALLINT DEFAULT 1,
    autores TEXT NOT NULL
);

-- 5. Subclase: EQUIPO_TECNOLOGICO (Hardware y Cómputo)
CREATE TABLE equipo_tecnologico (
    id_item INTEGER PRIMARY KEY REFERENCES item_catalogo(id_item) ON DELETE CASCADE,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    numero_serie VARCHAR(60) NOT NULL UNIQUE,
    especificaciones TEXT NOT NULL
);

-- 6. Entidad: EJEMPLAR (Copia física individual)
CREATE TABLE ejemplar (
    id_ejemplar SERIAL PRIMARY KEY,
    id_item INTEGER NOT NULL REFERENCES item_catalogo(id_item) ON DELETE RESTRICT,
    codigo_barras VARCHAR(30) NOT NULL UNIQUE,
    estado_fisico VARCHAR(50) NOT NULL DEFAULT 'BUENO',
    estado_disponibilidad estado_ejemplar_enum NOT NULL DEFAULT 'DISPONIBLE',
    ubicacion_estante VARCHAR(30) NOT NULL,
    fecha_adquisicion DATE NOT NULL DEFAULT CURRENT_DATE
);

-- 7. Entidad: PRESTAMO (Encabezado de la transacción)
CREATE TABLE prestamo (
    id_prestamo SERIAL PRIMARY KEY,
    folio VARCHAR(25) NOT NULL UNIQUE,
    id_usuario INTEGER NOT NULL REFERENCES usuario(id_usuario) ON DELETE RESTRICT,
    fecha_prestamo TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    estado_prestamo estado_prestamo_enum NOT NULL DEFAULT 'ACTIVO',
    observaciones TEXT
);

-- 8. Entidad Débil / Intermedia: DETALLE_PRESTAMO
CREATE TABLE detalle_prestamo (
    id_detalle SERIAL PRIMARY KEY,
    id_prestamo INTEGER NOT NULL REFERENCES prestamo(id_prestamo) ON DELETE CASCADE,
    id_ejemplar INTEGER NOT NULL REFERENCES ejemplar(id_ejemplar) ON DELETE RESTRICT,
    fecha_devolucion_esperada DATE NOT NULL,
    fecha_devolucion_real TIMESTAMP WITH TIME ZONE,
    condicion_entrega TEXT DEFAULT 'Óptimas condiciones operativas',
    condicion_devolucion TEXT
);

-- 9. Entidad: MULTA (Generada ante entregas tardías)
CREATE TABLE multa (
    id_multa SERIAL PRIMARY KEY,
    id_detalle INTEGER NOT NULL UNIQUE REFERENCES detalle_prestamo(id_detalle) ON DELETE RESTRICT,
    dias_atraso INTEGER NOT NULL CHECK (dias_atraso >= 0),
    monto_total NUMERIC(10,2) NOT NULL CHECK (monto_total >= 0),
    estado_pago estado_pago_enum NOT NULL DEFAULT 'PENDIENTE',
    fecha_generacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    fecha_pago TIMESTAMP WITH TIME ZONE
);

-- Índices B-Tree para optimización de consultas operativas
CREATE INDEX idx_usuario_identificador ON usuario(identificador_institucional);
CREATE INDEX idx_ejemplar_codigo_barras ON ejemplar(codigo_barras);
CREATE INDEX idx_ejemplar_disponibilidad ON ejemplar(estado_disponibilidad);
CREATE INDEX idx_prestamo_usuario ON prestamo(id_usuario);
CREATE INDEX idx_detalle_fechas ON detalle_prestamo(fecha_devolucion_esperada, fecha_devolucion_real);
