-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS ejercicios_cursores;
USE ejercicios_cursores;

-- Eliminar tablas si existen
DROP TABLE IF EXISTS calificaciones;
DROP TABLE IF EXISTS inscripciones;
DROP TABLE IF EXISTS estudiantes_nuevo;
DROP TABLE IF EXISTS estudiantes_antiguo;
DROP TABLE IF EXISTS estudiantes;
DROP TABLE IF EXISTS cursos;

-- Crear tabla estudiantes
CREATE TABLE estudiantes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    promedio DECIMAL(4,2)
);

-- Crear tabla cursos
CREATE TABLE cursos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);

-- Crear tabla calificaciones
CREATE TABLE calificaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    estudiante_id INT,
    curso_id INT,
    nota DECIMAL(4,2),
    fecha_calificacion DATE,
    FOREIGN KEY (estudiante_id) REFERENCES estudiantes(id),
    FOREIGN KEY (curso_id) REFERENCES cursos(id)
);

-- Crear tabla inscripciones
CREATE TABLE inscripciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    estudiante_id INT,
    curso_id INT,
    fecha_inscripcion DATE,
    estado ENUM('activo', 'finalizado', 'abandonado') DEFAULT 'activo',
    FOREIGN KEY (estudiante_id) REFERENCES estudiantes(id),
    FOREIGN KEY (curso_id) REFERENCES cursos(id)
);

-- Crear tabla estudiantes_antiguo (para ejercicio de migración)
CREATE TABLE estudiantes_antiguo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(100),
    fecha DATE
);

-- Crear tabla estudiantes_nuevo (para ejercicio de migración)
CREATE TABLE estudiantes_nuevo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    fecha_nacimiento DATE
);

-- Insertar datos de ejemplo en estudiantes
INSERT INTO estudiantes (nombre, apellido, promedio) VALUES 
    ('Juan', 'Pérez', 8.5),
    ('María', 'González', 9.2),
    ('Carlos', 'Rodríguez', 7.8),
    ('Ana', 'Martínez', 8.9),
    ('Pedro', 'Sánchez', 7.5),
    ('Laura', 'López', 9.0),
    ('Miguel', 'Torres', 8.2),
    ('Sofía', 'Ramírez', 9.5),
    ('Diego', 'García', 7.9),
    ('Valentina', 'Díaz', 8.7);

-- Insertar datos de ejemplo en cursos
INSERT INTO cursos (nombre, descripcion) VALUES
    ('Matemáticas I', 'Curso básico de matemáticas'),
    ('Física Básica', 'Introducción a la física'),
    ('Química General', 'Fundamentos de química'),
    ('Programación', 'Introducción a la programación'),
    ('Base de Datos', 'Diseño y gestión de bases de datos');

-- Insertar datos de ejemplo en calificaciones
INSERT INTO calificaciones (estudiante_id, curso_id, nota, fecha_calificacion) VALUES
    (1, 1, 8.5, '2023-01-15'),
    (1, 2, 7.8, '2023-02-20'),
    (2, 1, 9.2, '2023-01-15'),
    (2, 3, 8.9, '2023-03-10'),
    (3, 2, 7.5, '2023-02-20'),
    (3, 4, 8.2, '2023-04-05'),
    (4, 1, 9.0, '2023-01-15'),
    (4, 3, 8.7, '2023-03-10'),
    (5, 2, 7.9, '2023-02-20'),
    (5, 4, 8.5, '2023-04-05'),
    (6, 1, 9.3, '2023-01-15'),
    (6, 5, 8.8, '2023-05-01'),
    (7, 3, 8.1, '2023-03-10'),
    (7, 5, 8.4, '2023-05-01'),
    (8, 2, 9.4, '2023-02-20'),
    (8, 4, 9.2, '2023-04-05'),
    (9, 1, 7.7, '2023-01-15'),
    (9, 5, 8.0, '2023-05-01'),
    (10, 3, 8.6, '2023-03-10'),
    (10, 4, 8.9, '2023-04-05');

-- Insertar datos de ejemplo en inscripciones
INSERT INTO inscripciones (estudiante_id, curso_id, fecha_inscripcion, estado) VALUES
    (1, 1, '2023-01-01', 'activo'),
    (1, 2, '2023-02-01', 'activo'),
    (2, 1, '2023-01-01', 'finalizado'),
    (2, 3, '2023-03-01', 'activo'),
    (3, 2, '2023-02-01', 'activo'),
    (3, 4, '2023-04-01', 'activo'),
    (4, 1, '2023-01-01', 'finalizado'),
    (4, 3, '2023-03-01', 'activo'),
    (5, 2, '2023-02-01', 'abandonado'),
    (5, 4, '2023-04-01', 'activo');

-- Insertar datos de ejemplo en estudiantes_antiguo
INSERT INTO estudiantes_antiguo (nombre_completo, fecha) VALUES
    ('Juan Pérez González', '1995-03-15'),
    ('María López Sánchez', '1997-07-22'),
    ('Carlos Rodríguez Martínez', '1996-11-30'),
    ('Ana García Torres', '1998-01-05'),
    ('Pedro Martínez Ruiz', '1995-09-12');

-- Crear índices para optimizar las consultas
CREATE INDEX idx_estudiante_curso ON calificaciones(estudiante_id, curso_id);
CREATE INDEX idx_inscripciones_estudiante ON inscripciones(estudiante_id);
CREATE INDEX idx_calificaciones_fecha ON calificaciones(fecha_calificacion);

-- Comentarios explicativos
/*
Este script crea:
1. Base de datos específica para los ejercicios de cursores
2. Todas las tablas necesarias para los ejercicios propuestos
3. Datos de ejemplo suficientes para probar los cursores
4. Relaciones entre tablas mediante claves foráneas
5. Índices para optimizar las consultas

Tablas principales:
- estudiantes: Información básica de los estudiantes
- cursos: Catálogo de cursos disponibles
- calificaciones: Notas de los estudiantes en cada curso
- inscripciones: Registro de inscripciones a cursos

Tablas para ejercicio de migración:
- estudiantes_antiguo: Formato antiguo de datos
- estudiantes_nuevo: Nuevo formato de datos

Los datos de ejemplo incluyen:
- 10 estudiantes
- 5 cursos
- 20 calificaciones
- 10 inscripciones
- 5 registros en formato antiguo
*/