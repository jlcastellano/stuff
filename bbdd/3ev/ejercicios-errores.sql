-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS ejercicios_transacciones;
USE ejercicios_transacciones;

-- Eliminar tablas si existen para evitar conflictos
DROP TABLE IF EXISTS movimientos;
DROP TABLE IF EXISTS detalle_factura;
DROP TABLE IF EXISTS facturas;
DROP TABLE IF EXISTS matriculas;
DROP TABLE IF EXISTS reservas;
DROP TABLE IF EXISTS contactos;
DROP TABLE IF EXISTS empleados;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS cuentas;
DROP TABLE IF EXISTS habitaciones;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS cursos;

-- Tabla cuentas (Ejercicio 1 - Sistema de Transferencias)
CREATE TABLE cuentas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titular VARCHAR(100) NOT NULL,
    saldo DECIMAL(10,2) DEFAULT 0.00,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla empleados y contactos (Ejercicio 2 - Registro de Empleados)
CREATE TABLE empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    dni VARCHAR(20) UNIQUE NOT NULL,
    fecha_ingreso DATE NOT NULL
);

CREATE TABLE contactos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    empleado_id INT NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    FOREIGN KEY (empleado_id) REFERENCES empleados(id)
);

-- Tabla productos y movimientos (Ejercicio 3 - Sistema de Inventario)
CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    stock INT DEFAULT 0,
    precio DECIMAL(10,2) NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE movimientos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    tipo ENUM('entrada', 'salida') NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- Tablas cursos y matriculas (Ejercicio 4 - Proceso de Matrícula)
CREATE TABLE cursos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cupo_maximo INT NOT NULL,
    cupo_actual INT DEFAULT 0,
    fecha_inicio DATE
);

CREATE TABLE matriculas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    estudiante_id INT NOT NULL,
    curso_id INT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (curso_id) REFERENCES cursos(id)
);

-- Tablas para facturación (Ejercicio 5 - Proceso de Facturación)
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    telefono VARCHAR(20)
);

CREATE TABLE facturas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    total DECIMAL(10,2) DEFAULT 0,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('pendiente', 'pagada', 'anulada') DEFAULT 'pendiente',
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE detalle_factura (
    id INT AUTO_INCREMENT PRIMARY KEY,
    factura_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (factura_id) REFERENCES facturas(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- Tablas para reservas (Ejercicio 6 - Sistema de Reservas)
CREATE TABLE habitaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    estado ENUM('disponible', 'reservada', 'ocupada', 'mantenimiento') DEFAULT 'disponible',
    precio_noche DECIMAL(10,2) NOT NULL
);

CREATE TABLE reservas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    habitacion_id INT NOT NULL,
    cliente_id INT NOT NULL,
    fecha_entrada DATE NOT NULL,
    fecha_salida DATE NOT NULL,
    estado ENUM('pendiente', 'confirmada', 'cancelada') DEFAULT 'pendiente',
    FOREIGN KEY (habitacion_id) REFERENCES habitaciones(id),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- Insertar datos de ejemplo en cuentas
INSERT INTO cuentas (titular, saldo) VALUES 
    ('Juan Pérez', 5000.00),
    ('María García', 3500.00),
    ('Carlos López', 2800.00),
    ('Ana Martínez', 6200.00),
    ('Pedro Rodríguez', 4100.00);

-- Insertar datos de ejemplo en productos
INSERT INTO productos (nombre, stock, precio) VALUES 
    ('Laptop HP', 10, 899.99),
    ('Monitor Dell', 15, 249.99),
    ('Teclado Mecánico', 20, 79.99),
    ('Mouse Gaming', 30, 49.99),
    ('Impresora Canon', 8, 299.99);

-- Insertar datos de ejemplo en cursos
INSERT INTO cursos (nombre, cupo_maximo, cupo_actual, fecha_inicio) VALUES 
    ('Programación Java', 20, 15, '2024-02-01'),
    ('Diseño Web', 15, 10, '2024-02-15'),
    ('Base de Datos', 25, 18, '2024-03-01'),
    ('Python Básico', 30, 22, '2024-03-15'),
    ('Marketing Digital', 20, 12, '2024-04-01');

-- Insertar datos de ejemplo en clientes
INSERT INTO clientes (nombre, email, telefono) VALUES 
    ('Laura Torres', 'laura@email.com', '555-0101'),
    ('Roberto Sánchez', 'roberto@email.com', '555-0102'),
    ('Carmen Ruiz', 'carmen@email.com', '555-0103'),
    ('Miguel Ángel', 'miguel@email.com', '555-0104'),
    ('Isabel Moreno', 'isabel@email.com', '555-0105');

-- Insertar datos de ejemplo en habitaciones
INSERT INTO habitaciones (tipo, estado, precio_noche) VALUES 
    ('Individual', 'disponible', 80.00),
    ('Doble', 'disponible', 120.00),
    ('Suite', 'disponible', 200.00),
    ('Individual', 'reservada', 80.00),
    ('Doble', 'ocupada', 120.00);

-- Insertar datos de ejemplo en empleados y contactos
INSERT INTO empleados (nombre, dni, fecha_ingreso) VALUES 
    ('María José López', '12345678A', '2023-01-15'),
    ('Antonio García', '87654321B', '2023-02-20'),
    ('Sara Martínez', '11223344C', '2023-03-10'),
    ('Carlos Ruiz', '44332211D', '2023-04-05'),
    ('Elena Torres', '55667788E', '2023-05-01');

INSERT INTO contactos (empleado_id, email, telefono) VALUES 
    (1, 'maria@empresa.com', '555-1001'),
    (2, 'antonio@empresa.com', '555-1002'),
    (3, 'sara@empresa.com', '555-1003'),
    (4, 'carlos@empresa.com', '555-1004'),
    (5, 'elena@empresa.com', '555-1005');

-- Crear algunos movimientos de inventario
INSERT INTO movimientos (producto_id, cantidad, tipo) VALUES 
    (1, 5, 'entrada'),
    (2, 3, 'salida'),
    (3, 10, 'entrada'),
    (4, 5, 'salida'),
    (5, 2, 'entrada');

-- Crear algunas facturas y detalles
INSERT INTO facturas (cliente_id, total) VALUES 
    (1, 1299.98),
    (2, 449.97),
    (3, 899.99);

INSERT INTO detalle_factura (factura_id, producto_id, cantidad, precio) VALUES 
    (1, 1, 1, 899.99),
    (1, 2, 1, 249.99),
    (2, 3, 3, 79.99),
    (2, 4, 2, 49.99),
    (3, 1, 1, 899.99);

-- Crear algunas reservas
INSERT INTO reservas (habitacion_id, cliente_id, fecha_entrada, fecha_salida, estado) VALUES 
    (1, 1, '2024-02-01', '2024-02-03', 'confirmada'),
    (2, 2, '2024-02-05', '2024-02-07', 'pendiente'),
    (3, 3, '2024-02-10', '2024-02-12', 'confirmada'),
    (4, 4, '2024-02-15', '2024-02-17', 'pendiente'),
    (5, 5, '2024-02-20', '2024-02-22', 'confirmada');

-- Crear algunas matrículas
INSERT INTO matriculas (estudiante_id, curso_id) VALUES 
    (1, 1),
    (2, 1),
    (3, 2),
    (4, 3),
    (5, 4);

-- Crear índices para optimizar las consultas
CREATE INDEX idx_facturas_cliente ON facturas(cliente_id);
CREATE INDEX idx_reservas_habitacion ON reservas(habitacion_id);
CREATE INDEX idx_movimientos_producto ON movimientos(producto_id);
CREATE INDEX idx_matriculas_curso ON matriculas(curso_id);