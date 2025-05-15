-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS ejercicios_triggers;
USE ejercicios_triggers;

-- Eliminar tablas si existen para evitar conflictos
DROP TABLE IF EXISTS productos_historico;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS auditoria_salarios;
DROP TABLE IF EXISTS empleados;
DROP TABLE IF EXISTS historial_calificaciones;
DROP TABLE IF EXISTS calificaciones;
DROP TABLE IF EXISTS estudiantes;
DROP TABLE IF EXISTS materias;
DROP TABLE IF EXISTS log_pedidos;
DROP TABLE IF EXISTS detalle_pedido;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS limites_diarios;
DROP TABLE IF EXISTS transacciones;
DROP TABLE IF EXISTS cuentas;
DROP TABLE IF EXISTS multas;
DROP TABLE IF EXISTS prestamos;
DROP TABLE IF EXISTS usuarios;
DROP TABLE IF EXISTS libros;

-- Ejercicio 1: Sistema de Inventario con Histórico
CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL,
    stock_maximo INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE productos_historico (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    usuario VARCHAR(50) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    operacion VARCHAR(20) NOT NULL,
    stock_anterior INT NOT NULL,
    stock_nuevo INT NOT NULL,
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- Ejercicio 2: Validación de Empleados
CREATE TABLE empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    fecha_contratacion DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE auditoria_salarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    empleado_id INT NOT NULL,
    salario_anterior DECIMAL(10,2) NOT NULL,
    salario_nuevo DECIMAL(10,2) NOT NULL,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (empleado_id) REFERENCES empleados(id)
);

-- Ejercicio 3: Sistema de Calificaciones
CREATE TABLE estudiantes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    promedio DECIMAL(4,2) DEFAULT 0.00,
    estado ENUM('aprobado', 'reprobado') DEFAULT 'reprobado'
);

CREATE TABLE materias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    profesor VARCHAR(100) NOT NULL
);

CREATE TABLE calificaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    estudiante_id INT NOT NULL,
    materia_id INT NOT NULL,
    nota DECIMAL(4,2) NOT NULL,
    fecha_calificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (estudiante_id) REFERENCES estudiantes(id),
    FOREIGN KEY (materia_id) REFERENCES materias(id)
);

CREATE TABLE historial_calificaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    estudiante_id INT NOT NULL,
    materia_id INT NOT NULL,
    nota_anterior DECIMAL(4,2) NOT NULL,
    nota_nueva DECIMAL(4,2) NOT NULL,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (estudiante_id) REFERENCES estudiantes(id),
    FOREIGN KEY (materia_id) REFERENCES materias(id)
);

-- Ejercicio 4: Control de Pedidos
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20)
);

CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    total DECIMAL(10,2) DEFAULT 0,
    estado ENUM('pendiente', 'procesando', 'completado', 'cancelado') DEFAULT 'pendiente',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE detalle_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

CREATE TABLE log_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    estado_anterior VARCHAR(20) NOT NULL,
    estado_nuevo VARCHAR(20) NOT NULL,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id)
);

-- Ejercicio 5: Sistema Bancario
CREATE TABLE cuentas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    saldo DECIMAL(10,2) DEFAULT 0.00,
    tipo_cuenta ENUM('ahorro', 'corriente') DEFAULT 'ahorro',
    estado ENUM('activa', 'inactiva', 'bloqueada') DEFAULT 'activa',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE transacciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cuenta_id INT NOT NULL,
    tipo ENUM('deposito', 'retiro', 'transferencia') NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cuenta_id) REFERENCES cuentas(id)
);

CREATE TABLE limites_diarios (
    cuenta_id INT NOT NULL,
    fecha DATE NOT NULL,
    monto_total DECIMAL(10,2) DEFAULT 0,
    PRIMARY KEY (cuenta_id, fecha),
    FOREIGN KEY (cuenta_id) REFERENCES cuentas(id)
);

-- Ejercicio 6: Sistema de Biblioteca
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    prestamos_activos INT DEFAULT 0,
    estado ENUM('activo', 'suspendido') DEFAULT 'activo',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE libros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    autor VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    copias_totales INT NOT NULL,
    copias_disponibles INT NOT NULL,
    categoria VARCHAR(50) NOT NULL
);

CREATE TABLE prestamos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    libro_id INT NOT NULL,
    usuario_id INT NOT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_devolucion DATE,
    estado ENUM('prestado', 'devuelto', 'retrasado') DEFAULT 'prestado',
    FOREIGN KEY (libro_id) REFERENCES libros(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE multas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    pagada BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Insertar datos de ejemplo

-- Productos
INSERT INTO productos (nombre, stock, stock_minimo, stock_maximo, precio) VALUES 
    ('Laptop HP', 20, 5, 30, 899.99),
    ('Monitor Dell', 15, 3, 25, 299.99),
    ('Teclado Mecánico', 30, 10, 50, 79.99),
    ('Mouse Gaming', 25, 8, 40, 49.99),
    ('Impresora Canon', 10, 2, 15, 199.99);

-- Empleados
INSERT INTO empleados (nombre, email, fecha_nacimiento, salario) VALUES 
    ('Juan Pérez', 'juan@empresa.com', '1990-05-15', 45000.00),
    ('María López', 'maria@empresa.com', '1988-08-22', 52000.00),
    ('Carlos García', 'carlos@empresa.com', '1995-03-10', 38000.00),
    ('Ana Martínez', 'ana@empresa.com', '1992-11-28', 41000.00),
    ('Pedro Rodríguez', 'pedro@empresa.com', '1987-07-03', 48000.00);

-- Materias
INSERT INTO materias (nombre, profesor) VALUES 
    ('Matemáticas', 'Dr. Ramírez'),
    ('Física', 'Dra. Sánchez'),
    ('Química', 'Dr. Torres'),
    ('Programación', 'Ing. Morales'),
    ('Base de Datos', 'Ing. Castro');

-- Estudiantes y Calificaciones
INSERT INTO estudiantes (nombre) VALUES 
    ('Laura González'),
    ('Miguel Hernández'),
    ('Sofía Torres'),
    ('Diego Ruiz'),
    ('Valentina Castro');

INSERT INTO calificaciones (estudiante_id, materia_id, nota) VALUES 
    (1, 1, 8.5), (1, 2, 7.8), (1, 3, 9.0),
    (2, 1, 7.2), (2, 2, 8.1), (2, 3, 7.5),
    (3, 1, 9.2), (3, 2, 8.8), (3, 3, 9.5),
    (4, 1, 6.8), (4, 2, 7.4), (4, 3, 8.2),
    (5, 1, 8.9), (5, 2, 8.5), (5, 3, 8.7);

-- Clientes
INSERT INTO clientes (nombre, email, telefono) VALUES 
    ('Roberto Méndez', 'roberto@email.com', '555-0101'),
    ('Carmen Silva', 'carmen@email.com', '555-0102'),
    ('Fernando Díaz', 'fernando@email.com', '555-0103'),
    ('Patricia Ortiz', 'patricia@email.com', '555-0104'),
    ('José Vargas', 'jose@email.com', '555-0105');

-- Cuentas bancarias
INSERT INTO cuentas (cliente_id, saldo, tipo_cuenta) VALUES 
    (1, 5000.00, 'ahorro'),
    (2, 12000.00, 'corriente'),
    (3, 3500.00, 'ahorro'),
    (4, 8000.00, 'corriente'),
    (5, 15000.00, 'ahorro');

-- Libros
INSERT INTO libros (titulo, autor, isbn, copias_totales, copias_disponibles, categoria) VALUES 
    ('Cien años de soledad', 'Gabriel García Márquez', '978-0307474728', 5, 3, 'Literatura'),
    ('El principito', 'Antoine de Saint-Exupéry', '978-0156012195', 4, 2, 'Ficción'),
    ('Don Quijote', 'Miguel de Cervantes', '978-0142437230', 3, 1, 'Clásico'),
    ('1984', 'George Orwell', '978-0451524935', 6, 4, 'Ficción'),
    ('Rayuela', 'Julio Cortázar', '978-0292724419', 4, 3, 'Literatura');

-- Usuarios biblioteca
INSERT INTO usuarios (nombre, email) VALUES 
    ('Isabel Moreno', 'isabel@email.com'),
    ('Ricardo Luna', 'ricardo@email.com'),
    ('Diana Flores', 'diana@email.com'),
    ('Andrés Reyes', 'andres@email.com'),
    ('Lucía Campos', 'lucia@email.com');

-- Crear índices para optimizar consultas
CREATE INDEX idx_productos_stock ON productos(stock);
CREATE INDEX idx_calificaciones_estudiante ON calificaciones(estudiante_id);
CREATE INDEX idx_pedidos_cliente ON pedidos(cliente_id);
CREATE INDEX idx_transacciones_cuenta ON transacciones(cuenta_id);
CREATE INDEX idx_prestamos_usuario ON prestamos(usuario_id);