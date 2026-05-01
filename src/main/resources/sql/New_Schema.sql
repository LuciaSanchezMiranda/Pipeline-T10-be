-- Crear base de datos
CREATE DATABASE BerryControl;
GO

USE BerryControl;
GO

-- =========================
-- Tabla SUPPLIER
-- =========================
IF OBJECT_ID('SUPPLIER', 'U') IS NOT NULL DROP TABLE SUPPLIER;
CREATE TABLE SUPPLIER (
    supplier_id INT IDENTITY(1,1) PRIMARY KEY,
    ubigeo_code CHAR(6),
    company_name VARCHAR(150) NOT NULL,
    ruc CHAR(11) NOT NULL,
    phone CHAR(9),
    email VARCHAR(100),
    address VARCHAR(255),
    status VARCHAR(20) NOT NULL DEFAULT 'activo',
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME,
    deleted_at DATETIME
);
GO

-- =========================
-- Tabla CUSTOMER
-- =========================
IF OBJECT_ID('CUSTOMER', 'U') IS NOT NULL DROP TABLE CUSTOMER;
CREATE TABLE CUSTOMER (
    id_customer INT IDENTITY(1,1) PRIMARY KEY,
    ubigeo_code CHAR(6),
    customer_type VARCHAR(20) NOT NULL,
    document_number VARCHAR(15) NOT NULL,
    customer_name VARCHAR(50) NOT NULL,
    customer_lastname VARCHAR(60),
    phone CHAR(9),
    email VARCHAR(150),
    address VARCHAR(255),
    status VARCHAR(10) NOT NULL DEFAULT 'activo',
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME,
    deleted_at DATETIME
);
GO

-- =========================
-- Tabla PRODUCTS_SALE
-- =========================
IF OBJECT_ID('PRODUCTS_SALE', 'U') IS NOT NULL DROP TABLE PRODUCTS_SALE;
CREATE TABLE PRODUCTS_SALE (
    products_sale_id INT IDENTITY(1,1) PRIMARY KEY,
    category_id INT NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    available_stock INT NOT NULL DEFAULT 0,
    unit_measurement VARCHAR(30) NOT NULL,
    description TEXT,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME,
    deleted_at DATETIME
);
GO

-- =========================
-- Inserciones de Prueba
-- =========================

-- Inserciones para SUPPLIER
INSERT INTO SUPPLIER (ubigeo_code, company_name, ruc, phone, email, address, status)
VALUES 
('150101', 'Agro Export SAC', '20123456789', '987654321', 'contacto@agroexport.com', 'Av. Industrial 123, Lima', 'activo'),
('150102', 'Fertilizantes del Norte', '20987654321', '912345678', 'ventas@fertinorte.pe', 'Calle Los Jazmines 456, Trujillo', 'activo'),
('040101', 'Logística Rural EIRL', '10112233445', '933445566', 'gerencia@logrural.com', 'Jr. Puno 789, Arequipa', 'inactivo');

-- Inserciones para CUSTOMER
INSERT INTO CUSTOMER (ubigeo_code, customer_type, document_number, customer_name, customer_lastname, phone, email, address, status)
VALUES 
('150101', 'MINORISTA', '12345678', 'Juan', 'Pérez', '999888777', 'juan.perez@gmail.com', 'Jr. Moquegua 111, Lima', 'activo'),
('150105', 'MAYORISTA', '20445566778', 'Distribuidora Huamán', NULL, '955443322', 'ventas@disthuman.com', 'Av. Aviación 222, San Borja', 'activo'),
('150101', 'REGULAR', '44332211', 'María', 'López', '911223344', 'maria.lopez@yahoo.com', 'Calle Las Begonias 333, Lince', 'activo');

-- Inserciones para PRODUCTS_SALE
INSERT INTO PRODUCTS_SALE (category_id, product_name, price, available_stock, unit_measurement, description)
VALUES 
(1, 'Arándano Orgánico', 12.50, 500, 'Kg', 'Arándanos frescos de exportación'),
(1, 'Frambuesa Roja', 18.00, 200, 'Kg', 'Frambuesas seleccionadas'),
(2, 'Fertilizante NPK', 45.00, 100, 'Saco 50kg', 'Fertilizante para crecimiento'),
(3, 'Caja de Embalaje', 2.50, 1000, 'Unidad', 'Cajas de cartón reforzado');

GO

-- Consultas de verificación
SELECT * FROM SUPPLIER;
SELECT * FROM CUSTOMER;
SELECT * FROM PRODUCTS_SALE;
