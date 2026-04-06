-- Crear base de datos
CREATE DATABASE AgroPacayales;
GO

-- Usar la base de datos
USE AgroPacayales;
GO

-- =========================
-- Tabla Customer
-- =========================

CREATE TABLE customer (
    id_customer INT IDENTITY(1,1) PRIMARY KEY,

    name_customer VARCHAR(50),
    lastname_customer VARCHAR(60),
    type_customer VARCHAR(20),

    phone CHAR(9),
    address VARCHAR(200),
    email VARCHAR(150),

    id_ubigeo INT,

    document_type CHAR(1),
    document_number VARCHAR(12),

    status VARCHAR(20)
);
GO

INSERT INTO customer (
    name_customer, lastname_customer, type_customer,
    phone, address, email, id_ubigeo,
    document_type, document_number, status
)
VALUES
('Lucia', 'Sanchez', 'REGULAR', '987654321', 'Lima', 'lucia@gmail.com', 101, 'D', '12345678', 'ACTIVO'),

('Carlos', 'Perez', 'VIP', '912345678', 'Arequipa', 'carlos@gmail.com', 102, 'D', '87654321', 'ACTIVO'),

('Maria', 'Lopez', 'REGULAR', '923456789', 'Cusco', 'maria@gmail.com', 103, 'D', '11223344', 'INACTIVO'),

('Jose', 'Ramirez', 'EMPRESA', '934567891', 'Trujillo', 'jose@gmail.com', 104, 'R', '20123456789', 'ACTIVO');
GO

CREATE TABLE PRODUCTO (
    id_producto      INT IDENTITY(1,1) PRIMARY KEY,
    Nombre_Producto  VARCHAR(30)   NOT NULL,
    id_Categoria     INT           NOT NULL,
    Precio           DECIMAL(10,2) NOT NULL,
    Unidad_medida    VARCHAR(10)   NOT NULL,
    id_proveedor     INT           NOT NULL,
    stock_disponible DECIMAL(10,2) NOT NULL,
    Estado           VARCHAR(20)   NOT NULL
);
GO

-- 2. Insertar productos
INSERT INTO PRODUCTO (Nombre_Producto, id_Categoria, Precio, Unidad_medida, id_proveedor, stock_disponible, Estado)
VALUES
('Cacao Orgánico',      1,  12.50, 'Kg',     1, 1500.00, 'Activo'),
('Café Especial',       1,  18.00, 'Kg',     1,  800.00, 'Activo'),
('Plátano de Seda',     2,   2.50, 'Racimo', 2, 3000.00, 'Activo'),
('Yuca Fresca',         2,   1.80, 'Kg',     2, 2000.00, 'Activo'),
('Maíz Amarillo',       3,   1.20, 'Kg',     3, 5000.00, 'Activo'),
('Arroz Pilado',        3,   2.80, 'Kg',     1, 4000.00, 'Activo'),
('Frijol Castilla',     4,   4.50, 'Kg',     3,  900.00, 'Activo'),
('Cúrcuma Molida',      4,   8.00, 'Kg',     2,  600.00, 'Inactivo');
GO

CREATE TABLE Supplier (
    id_supplier INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100),
    ruc CHAR(11),
    phone CHAR(9),
    address VARCHAR(200),
    tipo VARCHAR(30),
    status VARCHAR(20),
    company_name VARCHAR(150),
    contact_name VARCHAR(100),
    email VARCHAR(100)
);
GO

INSERT INTO Supplier (name, ruc, phone, address, tipo, status, company_name, contact_name, email)
VALUES 
('Proveedor Andino', '10123456789', '900111222', 'Av Andes 101 - Cusco', 'Productor', 'Activo', 'Andes Food SAC', 'Luis Quispe', 'luis@andesfood.com'),
('Proveedor Costero', '10234567890', '901222333', 'Av Costanera 202 - Lima', 'Mayorista', 'Activo', 'CostaMar SAC', 'Ana Torres', 'ana@costamar.com'),
('Proveedor Amazonico', '10345678901', '902333444', 'Jr Selva 303 - Iquitos', 'Distribuidor', 'Activo', 'SelvaFresh SAC', 'Carlos Rios', 'carlos@selvafresh.com'),
('Proveedor Industrial', '10456789012', '903444555', 'Zona Industrial 404 - Arequipa', 'Mayorista', 'Inactivo', 'Industrias Sur SAC', 'Maria Flores', 'maria@industriassur.com'),
('Proveedor Organico', '10567890123', '904555666', 'Av Natural 505 - Huancayo', 'Productor', 'Activo', 'BioPeru SAC', 'Pedro Huaman', 'pedro@bioperu.com'),
('Proveedor Exportador', '10678901234', '905666777', 'Av Comercio 606 - Callao', 'Exportador', 'Activo', 'Exportaciones Peru SAC', 'Rosa Vargas', 'rosa@exportperu.com');
GO

SELECT * FROM PRODUCTO;
SELECT * FROM customer;
SELECT * FROM Supplier;