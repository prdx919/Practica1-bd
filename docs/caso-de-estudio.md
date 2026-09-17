# Instituto Politécnico Nacional
## Escuela Superior de Cómputo / UPIITA
### Ingeniería en Inteligencia Artificial (Plan 2020)
**Unidad de Aprendizaje:** Bases de Datos  
**Práctica 1:** Modelo Entidad Relación  
**Alumno:** Cesar Javier Martinez Ruiz  
**Boleta:** 2024630871 | **Grupo:** 3BV1  

---

# Ejercicio 5. Caso de Estudio: Sistema de Registro y Control de Préstamos Bibliográficos y Tecnológicos (SRCP)

---

## 1. Identificación y Descripción de la Problemática Real

En las instituciones universitarias de ingeniería e inteligencia artificial, la biblioteca académica no solo gestiona material bibliográfico tradicional (libros de texto, artículos de investigación, tesis impresas), sino también **recursos tecnológicos y de hardware especializado** (computadoras portátiles para desarrollo, tarjetas de procesamiento embebido con GPU/NPU como NVIDIA Jetson, kits de robótica y sensores).

Actualmente, el departamento de servicios bibliotecarios enfrenta severas dificultades operativas debido al uso de hojas de cálculo de Excel compartidas y libretas de registro manual:
1. **Pérdida de trazabilidad de ejemplares individuales:** No se distingue con precisión entre el título abstracto de una obra y la copia física concreta entregada. Si un alumno extravía un libro o daña una laptop, es imposible saber qué número de serie o código de barras específico tenía asignado.
2. **Morosidad no controlada e inconsistencia de sanciones:** No existe un mecanismo automatizado para computar días de atraso, suspender temporalmente a usuarios con préstamos vencidos o registrar multas económicas de forma unívoca.
3. **Imposibilidad de gestionar reservas concurrentes:** Múltiples alumnos solicitan el mismo recurso de hardware para proyectos finales simultáneos sin que exista una cola de espera ordenada por prioridad o fecha de solicitud.
4. **Falta de métricas institucionales:** La dirección no cuenta con reportes oportunos sobre los títulos más leídos, la tasa de rotación de hardware ni el índice de morosidad por carrera.

---

## 2. Simulación de Entrevista con el Cliente

**Interlocutores:**
* **Consultor de Bases de Datos:** Cesar Javier Martinez Ruiz (Ingeniería en IA)
* **Cliente:** Mtra. Elena Velázquez (Jefa del Departamento de Servicios Bibliotecarios y Recursos de Aprendizaje)

---

**Consultor:** Buenas tardes, Mtra. Velázquez. El objetivo de esta sesión es levantar los requerimientos de información para el nuevo sistema automatizado de préstamos. Para comenzar, ¿qué tipos de usuarios utilizan el servicio y qué datos necesitan registrar de ellos?  
**Cliente:** Buenas tardes. Atendemos a tres tipos de usuarios: alumnos de licenciatura, docentes-investigadores y personal administrativo. De los alumnos requerimos forzosamente su número de boleta, nombre completo, correo institucional, teléfono móvil y la carrera que cursan. De los profesores registramos su número de empleado, academia y cubículo. Además, necesitamos saber el estado de cada usuario en el sistema: si está "Activo", "Suspendido por mora" o "Egresado".

**Consultor:** Respecto a los artículos que presta la biblioteca, ¿cómo están clasificados y qué datos describen a cada uno?  
**Cliente:** Tenemos dos grandes categorías: **Material Bibliográfico** (libros, manuales, tesis) y **Recursos Tecnológicos** (laptops para laboratorio, tarjetas NVIDIA Jetson, microscopios digitales). De los libros registramos ISBN, título, autor principal, editorial, año de edición y clasificación temática Dewey. De los equipos tecnológicos registramos marca, modelo, número de serie único del fabricante y características técnicas (ej. memoria RAM, tipo de GPU).

**Consultor:** Un punto crítico en bibliotecas es la diferencia entre el "concepto" de un libro y las copias físicas que tienen en estantería. ¿Cómo manejan esto?  
**Cliente:** Es justo nuestro dolor de cabeza actual. De un mismo libro, por ejemplo *"Pattern Recognition and Machine Learning"*, tenemos 5 copias físicas. Cada copia tiene su propio código de barras interno institucional, fecha de adquisición y un estado físico: "Disponible", "Prestado", "En reparación" o "Baja definitiva". Necesitamos saber con precisión quirúrgica qué copia exacta se llevó cada persona.

**Consultor:** ¿Cuáles son las reglas de negocio para los préstamos y con qué frecuencia se registran?  
**Cliente:** Registramos entre 80 y 250 préstamos diarios. Un préstamo puede incluir desde un solo libro hasta un kit de 3 artículos a la vez. Cuando un usuario solicita préstamo, se genera un ticket con fecha y hora de salida. La fecha de devolución esperada depende del rol: los alumnos tienen derecho a 5 días hábiles para libros y 1 día (préstamo en sala/laboratorio) para equipo tecnológico; los profesores disponen de hasta 15 días. Un usuario con material vencido no puede pedir nada nuevo.

**Consultor:** ¿Qué ocurre en el momento de la entrega o devolución?  
**Cliente:** El bibliotecario escanea el código del ejemplar, se registra la fecha y hora real de entrega y se evalúa el estado del material. Si el usuario entregó a tiempo y en buen estado, el préstamo se marca como "Completado". Si hay días de atraso, el sistema debe calcular una penalización económica fija por día de retraso y suspender automáticamente la cuenta del usuario hasta que liquide la multa.

**Consultor:** ¿Qué reportes estadísticos o consultas operativas requiere usted obtener de la base de datos?  
**Cliente:** Requerimos tres reportes fundamentales:
1. **Reporte de Morosidad Activa:** Lista diaria de usuarios con préstamos vencidos, días de mora acumulados y teléfono/correo de contacto.
2. **Inventario y Rotación:** Listado de ejemplares disponibles en tiempo real y porcentaje de utilización de equipos tecnológicos.
3. **Top de Demanda:** Ranking mensual de los 10 libros y los 5 equipos tecnológicos más solicitados para justificar adquisiciones de presupuesto.

---

## 3. Especificación Formal de Requerimientos

### 3.1. Requerimientos de Datos (Estructura de Información)
* **RD-01 (Usuarios):** Almacenar identificador único, código institucional (boleta/número empleado), nombre, apellido paterno, apellido materno, correo electrónico institucional (único), número telefónico, tipo de usuario (Alumno, Docente, Administrativo) y estado de cuenta (Activo, Sancionado, Inactivo).
* **RD-02 (Ítems / Catálogo General):** Registrar código de catálogo interno, título/nombre del recurso, categoría (Bibliográfico o Tecnológico), año de publicación/fabricación y descripción temática.
* **RD-03 (Especialización Bibliográfica):** Para libros y tesis, registrar ISBN, editorial, edición y autores.
* **RD-04 (Especialización Tecnológica):** Para equipos, registrar marca, modelo, número de serie único y especificaciones de hardware.
* **RD-05 (Ejemplares Físicos):** Registrar código de barras de inventario único por copia física, fecha de alta en inventario, costo de reposición y estado operativo (Disponible, En Préstamo, Mantenimiento, Extraviado).
* **RD-06 (Préstamos):** Registrar folio del préstamo, fecha y hora de emisión, usuario solicitante, empleado/bibliotecario que autorizó y estado global (En Curso, Devuelto, Vencido).
* **RD-07 (Detalle del Préstamo):** Registrar para cada ejemplar prestado: fecha de devolución programada, fecha de devolución real, condición física de salida y condición de recepción.
* **RD-08 (Sanciones y Multas):** Registrar folio de multa, préstamo asociado, monto calculado por días de retraso, fecha de generación, estatus de pago (Pendiente, Pagado, Condonado) y fecha de liquidación.

### 3.2. Requerimientos Funcionales y Reportes
* **RF-01 (Validación de Elegibilidad):** Comprobar que un usuario no tenga sanciones activas ni préstamos vencidos antes de autorizar una nueva salida de material.
* **RF-02 (Transaccionalidad en Préstamos):** Al registrar un préstamo de varios ítems, cambiar atómicamente el estado de los ejemplares a "En Préstamo".
* **RF-03 (Recepción y Verificación):** Registrar la devolución liberando el ejemplar a "Disponible" y calculando multas automáticas si `fecha_devolucion_real > fecha_devolucion_programada`.
* **RF-04 (Reporte de Morosidad):** Generar consulta agregada de préstamos con fecha programada vencida y estatus no devuelto.
* **RF-05 (Reporte de Demanda y Estadísticas):** Cuantificar número de préstamos por ítem agrupado por mes y carrera del usuario solicitante.

---

## 4. Diagrama Entidad-Relación y Modelo Conceptual

### 4.1. Diccionario de Entidades y Atributos
1. **USUARIO:**
   * `id_usuario` (PK, entero autoincremental)
   * `identificador_institucional` (UK, VARCHAR(20) - Boleta o No. Empleado)
   * `nombre` (VARCHAR(60))
   * `apellido_paterno` (VARCHAR(60))
   * `apellido_materno` (VARCHAR(60))
   * `email` (UK, VARCHAR(100))
   * `telefono` (VARCHAR(15))
   * `tipo_usuario` (ENUM: 'ALUMNO', 'DOCENTE', 'ADMINISTRATIVO')
   * `estado_cuenta` (ENUM: 'ACTIVO', 'SANCIONADO', 'INACTIVO')
2. **ITEM_CATALOGO:**
   * `id_item` (PK, entero autoincremental)
   * `codigo_catalogo` (UK, VARCHAR(30))
   * `titulo` (VARCHAR(150))
   * `clasificacion` (VARCHAR(50))
   * `tipo_recurso` (ENUM: 'BIBLIOGRAFICO', 'TECNOLOGICO')
3. **LIBRO (Subtipo de ITEM_CATALOGO):**
   * `id_item` (PK, FK hacia ITEM_CATALOGO)
   * `isbn` (VARCHAR(20))
   * `editorial` (VARCHAR(80))
   * `edicion` (SMALLINT)
   * `autores` (TEXT)
4. **EQUIPO_TECNOLOGICO (Subtipo de ITEM_CATALOGO):**
   * `id_item` (PK, FK hacia ITEM_CATALOGO)
   * `marca` (VARCHAR(50))
   * `modelo` (VARCHAR(50))
   * `numero_serie` (UK, VARCHAR(60))
   * `especificaciones` (TEXT)
5. **EJEMPLAR:**
   * `id_ejemplar` (PK, entero autoincremental)
   * `id_item` (FK hacia ITEM_CATALOGO)
   * `codigo_barras` (UK, VARCHAR(30))
   * `estado_fisico` (VARCHAR(50))
   * `estado_disponibilidad` (ENUM: 'DISPONIBLE', 'PRESTADO', 'REPARACION', 'BAJA')
   * `ubicacion_estante` (VARCHAR(30))
6. **PRESTAMO:**
   * `id_prestamo` (PK, entero autoincremental)
   * `folio` (UK, VARCHAR(25))
   * `id_usuario` (FK hacia USUARIO)
   * `fecha_prestamo` (TIMESTAMP)
   * `estado_prestamo` (ENUM: 'ACTIVO', 'FINALIZADO', 'CON_MORA')
7. **DETALLE_PRESTAMO:**
   * `id_detalle` (PK, entero autoincremental)
   * `id_prestamo` (FK hacia PRESTAMO)
   * `id_ejemplar` (FK hacia EJEMPLAR)
   * `fecha_devolucion_esperada` (DATE)
   * `fecha_devolucion_real` (TIMESTAMP, NULLable)
   * `condicion_entrega` (TEXT)
   * `condicion_devolucion` (TEXT, NULLable)
8. **MULTA:**
   * `id_multa` (PK, entero autoincremental)
   * `id_detalle` (FK hacia DETALLE_PRESTAMO)
   * `dias_atraso` (INTEGER)
   * `monto_total` (DECIMAL(10,2))
   * `estado_pago` (ENUM: 'PENDIENTE', 'PAGADO', 'CONDONADO')
   * `fecha_pago` (TIMESTAMP, NULLable)

### 4.2. Definición de Relaciones y Cardinalidades
* **USUARIO realiza PRESTAMO:** Cardinalidad `(1:N)`. Un usuario puede solicitar de 0 a muchos préstamos a lo largo de su trayectoria; un préstamo pertenece a exactamente un usuario.
* **ITEM_CATALOGO posee EJEMPLAR:** Cardinalidad `(1:N)`. Un título o modelo de catálogo puede tener de 1 a muchos ejemplares físicos físicos en inventario; un ejemplar corresponde unívocamente a un solo ítem de catálogo.
* **PRESTAMO contiene DETALLE_PRESTAMO:** Cardinalidad `(1:N)`. Un folio de préstamo engloba de 1 a varios detalles de ejemplares entregados en el mismo acto; cada detalle forma parte de un solo préstamo.
* **EJEMPLAR es incluido en DETALLE_PRESTAMO:** Cardinalidad `(1:N)`. A través del tiempo, un ejemplar físico puede prestarse muchas veces (historial de salidas); un detalle de préstamo refiere a un ejemplar específico.
* **DETALLE_PRESTAMO genera MULTA:** Cardinalidad `(1:1 opcional)`. Una línea de préstamo devuelta con retraso puede generar a lo sumo una multa; cada multa se deriva obligatoriamente de un préstamo específico.

---

## 5. Justificación Técnica del Modelo

1. **Desacoplamiento entre Obra/Diseño y Copia Física (Normalización):**
   Si se combinaran los datos del libro (título, editorial) con el ejemplar físico (código de barras, estado de deterioro) en una sola tabla, ocurriría una severa redundancia de datos: el título, ISBN y editorial se repetirían tantas veces como copias físicas existiesen. Al separar `ITEM_CATALOGO` y `EJEMPLAR`, se cumple estrictamente la **Tercera Forma Normal (3FN)**, garantizando que los atributos no clave dependan de forma elemental y directa de la clave primaria.
2. **Jerarquía de Generalización / Especialización:**
   Dado que tanto libros como laptops comparten la naturaleza de ser "ítems prestables" (poseen código de catálogo, título y clasificación temática), pero difieren radicalmente en sus atributos secundarios (un libro no tiene memoria RAM ni número de serie de tarjeta madre; una laptop no tiene ISBN ni editorial), se modeló una superclase `ITEM_CATALOGO` con dos subclases `LIBRO` y `EQUIPO_TECNOLOGICO`. Esto simplifica las relaciones con `EJEMPLAR` sin necesidad de duplicar tablas de inventario ni tolerar columnas con valores nulos masivos (*sparse tables*).
3. **Trazabilidad Granular con Entidad Débil/Asociativa `DETALLE_PRESTAMO`:**
   Permitir que un préstamo posea múltiples ejemplares con fechas de devolución independientes es indispensable: un alumno puede devolver la laptop al día siguiente, pero conservar un libro de texto de apoyo por cinco días más. Modelar una entidad de detalle desacopla el ciclo de vida de cada ejemplar dentro de una misma transacción, permitiendo además multar de manera proporcional e individual únicamente el ítem que sufrió retraso.
4. **Garantía de Integridad y Prevención de Pérdidas Financieras:**
   El modelo incorpora llaves foráneas con restricciones de integridad referencial que impiden eliminar del inventario ejemplares que cuenten con préstamos activos o multas no saldadas. Esto asegura una auditoría completa requerida por los comités de acreditación institucional.
