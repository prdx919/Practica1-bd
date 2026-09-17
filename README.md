# Práctica 1: Modelo Entidad Relación
### Unidad de Aprendizaje: Bases de Datos (Unidad Temática I)
**Programa Académico:** Ingeniería en Inteligencia Artificial (Plan de Estudios 2020)  
**Institución:** Instituto Politécnico Nacional (IPN)  
**Escuela:** Escuela Superior de Cómputo (ESCOM) / UPIITA  

---

## 👨‍💻 Datos del Alumno
* **Nombre completo:** Cesar Javier Martinez Ruiz
* **Número de Boleta:** 2024630871
* **Grupo:** 3BV1
* **Carrera:** Ingeniería en Inteligencia Artificial
* **Semestre:** 2024-2 / 2025-1

---

## 🎯 Objetivo de la Práctica
Analizar las arquitecturas de los sistemas gestores de bases de datos (SGBD) a partir de su clasificación y de los diversos tipos de bases de datos existentes, construir el entorno de trabajo para el semestre —control de versiones con Git/GitHub y un sistema gestor PostgreSQL ejecutado en un contenedor Docker con persistencia—, sustentar la investigación con literatura científica arbitrada con DOI, y aplicar dichos fundamentos al modelado conceptual de un problema real mediante diagramas Entidad-Relación.

---

## 🗂️ Índice de Contenidos y Enlaces a la Documentación

Toda la evidencia y entregables de la práctica se encuentran estructurados y versionados dentro de este repositorio:

| Ejercicio | Descripción del Entregable | Formato / Enlace Directo |
| :--- | :--- | :--- |
| **Ejercicio 1 y 2 (Parte A)** | Control de Versiones con Git/GitHub y Arquitectura de Contenedores Docker | 📄 [investigacion-git-docker.pdf](docs/investigacion-git-docker.pdf) ([Ver Markdown](docs/investigacion-git-docker.md)) |
| **Ejercicio 2 (Parte B)** | Declaración de la Infraestructura del SGBD en Contenedor (PostgreSQL 16) | 🐳 [compose.yaml](entorno/compose.yaml) |
| **Ejercicio 3** | Monografía de Investigación: *Fundamentos Teóricos y Arquitectura de los SGBD* (4 a 6 cuartillas, APA 7) | 📚 [investigacion-bases-de-datos.pdf](docs/investigacion-bases-de-datos.pdf) ([Ver Markdown](docs/investigacion-bases-de-datos.md)) |
| **Ejercicio 4** | Estado del Arte: Análisis de 3 Artículos Científicos Arbitrados con DOI y Síntesis Comparativa | 🔬 [estado-del-arte.pdf](docs/estado-del-arte.pdf) ([Ver Markdown](docs/estado-del-arte.md)) |
| **Ejercicio 5** | Caso de Estudio: *Sistema de Registro y Control de Préstamos (SRCP)* (Problemática, Entrevista, Requerimientos) | 📋 [caso-de-estudio.pdf](docs/caso-de-estudio.pdf) ([Ver Markdown](docs/caso-de-estudio.md)) |
| **Ejercicio 5 (Modelo)** | Diagrama Entidad-Relación Visual de Alta Resolución y Especificación DDL | 🖼️ [diagrama-er.png](modelo/diagrama-er.png)<br>📊 [diagrama-er.mmd (Mermaid)](modelo/diagrama-er.mmd)<br>💾 [schema.sql (PostgreSQL)](modelo/schema.sql) |
| **Evidencias de Git** | Captura del historial `git log --oneline --graph --all` y Pull Request fusionado | 📂 [evidencias/git/](evidencias/git/) |
| **Evidencias de Docker** | Captura de la conexión al SGBD y comprobación de la persistencia de datos | 📂 [evidencias/docker/](evidencias/docker/) |

---

## 🏗️ Estructura del Repositorio

```text
practica1-bd/
├── README.md                           # Portada, datos del alumno, índice y guía
├── .gitignore                          # Exclusión de binarios, logs y temporales
├── docs/                               # Documentación formal en PDF y Markdown
│   ├── investigacion-git-docker.pdf    # Ejercicios 1 y 2 (Parte A)
│   ├── investigacion-bases-de-datos.pdf# Ejercicio 3: Monografía formal (APA 7)
│   ├── estado-del-arte.pdf             # Ejercicio 4: 3 artículos con DOI + síntesis
│   └── caso-de-estudio.pdf             # Ejercicio 5: Entrevista, requerimientos y justificación
├── entorno/                            # Infraestructura de ejecución
│   └── compose.yaml                    # Servicio PostgreSQL 16 con volumen y puerto 5432
├── modelo/                             # Modelado Conceptual y Físico
│   ├── diagrama-er.png                 # Diagrama Entidad-Relación visual (300 DPI)
│   ├── diagrama-er.mmd                 # Definición en notación Mermaid
│   ├── diagrama-er.dot                 # Código fuente Graphviz
│   └── schema.sql                      # DDL de PostgreSQL con restricciones e índices
└── evidencias/                         # Capturas de pantalla de validación
    ├── git/                            # Capturas de git log y PR fusionado
    └── docker/                         # Capturas de conexión a BD y persistencia
```

---

## 🚀 Guía de Despliegue y Pruebas del Entorno Docker

### 1. Requisitos Previos
* Docker Engine 24+ / Docker Desktop o Podman.
* Cliente de bases de datos: `psql`, DBeaver o pgAdmin.

### 2. Levantar el Contenedor del SGBD
Desde el directorio raíz del repositorio o dentro de `entorno/`, ejecute:
```bash
docker compose -f entorno/compose.yaml up -d
```

### 3. Verificar el Estado del Servicio
```bash
docker compose -f entorno/compose.yaml ps
```

### 4. Conectarse al Gestor y Crear la Base de Datos
Puede conectarse directamente utilizando el cliente interactivo dentro del contenedor:
```bash
docker exec -it pg-practica1 psql -U postgres
```
O conectarse desde su cliente local (DBeaver / psql) con los siguientes parámetros:
* **Host:** `localhost` o `127.0.0.1`
* **Puerto:** `5432`
* **Usuario:** `postgres`
* **Contraseña:** `practica1`
* **Base de datos inicial:** `practica1`

Para cargar el esquema completo del modelo E-R:
```bash
docker exec -i pg-practica1 psql -U postgres -d practica1 < modelo/schema.sql
```

### 5. Demostración de Persistencia
Para comprobar que los datos no se pierden al recrear el contenedor:
```bash
# Detener y eliminar el contenedor activo
docker compose -f entorno/compose.yaml down

# Volver a levantar el contenedor utilizando el mismo volumen
docker compose -f entorno/compose.yaml up -d

# Verificar que la base de datos y sus tablas continúan intactas
docker exec -it pg-practica1 psql -U postgres -d practica1 -c "\dt"
```
