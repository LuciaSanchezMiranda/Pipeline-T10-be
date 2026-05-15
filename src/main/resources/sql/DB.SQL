IF DB_ID('DF_BerryControl') IS NULL CREATE DATABASE DF_BerryControl;
GO
USE DF_BerryControl;
GO

DROP TABLE IF EXISTS STOCK_MOVEMENT,PRODUCTION_STAGE,PRODUCTION_BATCH,ORDER_DETAILS,ORDERS,
SALE_DETAILS,SALE,PURCHASES_DETAILS,PURCHASES,PRODUCTS_SUPPLY,PRODUCTS_SALE,
EMPLOYEE,CUSTOMER,SUPPLIER,ROLES,UBIGEO,CATEGORY;
GO


CREATE TABLE CATEGORY(
category_id INT IDENTITY(1,1) PRIMARY KEY,
category_name VARCHAR(100) NOT NULL,
category_type VARCHAR(20) NOT NULL,
status VARCHAR(20) NOT NULL
);

CREATE TABLE UBIGEO(
    ubigeo_code INT PRIMARY KEY,
    department VARCHAR(100) NOT NULL,
    province VARCHAR(100) NOT NULL,
    district VARCHAR(100) NOT NULL
);

CREATE TABLE ROLES(
role_id INT IDENTITY(1,1) PRIMARY KEY,
role_name VARCHAR(20) NOT NULL,
status VARCHAR(20) NOT NULL,
description VARCHAR(200) NOT NULL
);

CREATE TABLE CUSTOMER(
    id_customer INT IDENTITY(1,1) PRIMARY KEY,

    customer_name NVARCHAR(50) NOT NULL,
    customer_lastname NVARCHAR(60) NOT NULL,

    customer_type VARCHAR(20) NOT NULL,
    document_type CHAR(3) NOT NULL,

    document_number VARCHAR(15) UNIQUE NOT NULL,

    email VARCHAR(150) UNIQUE NOT NULL,

    phone CHAR(9) NOT NULL,

    address NVARCHAR(200) NOT NULL,

    status BIT NOT NULL DEFAULT 1,

    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    deleted_at DATETIME2 NULL,
    restored_at DATETIME2 NULL,

    ubigeo_code INT NOT NULL,

    CONSTRAINT FK_CUSTOMER_UBIGEO 
    FOREIGN KEY(ubigeo_code) 
    REFERENCES UBIGEO(ubigeo_code)
);

CREATE TABLE EMPLOYEE(
employee_id INT IDENTITY(1,1) PRIMARY KEY,
ubigeo_code INT NOT NULL,
role_id INT NOT NULL,
document_type VARCHAR(12) NOT NULL,
document_number VARCHAR(50) UNIQUE NOT NULL,
name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
phone CHAR(9) NOT NULL,
email VARCHAR(150) UNIQUE NOT NULL,
address VARCHAR(200) NOT NULL,
entry_date DATE NOT NULL,
status VARCHAR(10) NOT NULL,
password VARCHAR(255) NOT NULL,
created_at DATETIME DEFAULT GETDATE(),
updated_at DATETIME DEFAULT GETDATE(),
deleted_at DATETIME NULL,
restored_at DATETIME NULL,
CONSTRAINT FK_EMPLOYEE_UBIGEO FOREIGN KEY(ubigeo_code) REFERENCES UBIGEO(ubigeo_code),
CONSTRAINT FK_EMPLOYEE_ROLE FOREIGN KEY(role_id) REFERENCES ROLES(role_id)
);

CREATE TABLE PRODUCTS_SALE(
products_sale_id INT IDENTITY(1,1) PRIMARY KEY,
product_name VARCHAR(100) NOT NULL,
price DECIMAL(10,2) NOT NULL,
available_stock INT NOT NULL,
unit_measurement VARCHAR(30) NOT NULL,
description CHAR(255) NOT NULL,
created_at DATETIME DEFAULT GETDATE(),
updated_at DATETIME DEFAULT GETDATE(),
deleted_at DATETIME NULL,
restored_at DATETIME NULL,
category_id INT NOT NULL,
CONSTRAINT FK_PRODUCTS_SALE_CATEGORY FOREIGN KEY(category_id) REFERENCES CATEGORY(category_id)
);

CREATE TABLE PRODUCTS_SUPPLY(
product_id INT IDENTITY(1,1) PRIMARY KEY,
product_name VARCHAR(100) NOT NULL,
description VARCHAR(MAX) NOT NULL,
price DECIMAL(10,2) NOT NULL,
available_stock DECIMAL(10,2) NOT NULL,
expiry_date DATETIME NOT NULL,
unit_measurement VARCHAR(30) NOT NULL,
product_image VARBINARY(MAX) NOT NULL,
created_at DATETIME DEFAULT GETDATE(),
updated_at DATETIME DEFAULT GETDATE(),
deleted_at DATETIME NULL,
restored_at DATETIME NULL,
category_id INT NOT NULL,
CONSTRAINT FK_PRODUCTS_SUPPLY_CATEGORY FOREIGN KEY(category_id) REFERENCES CATEGORY(category_id)
);

CREATE TABLE SUPPLIER (
supplier_id   INT IDENTITY(1,1) PRIMARY KEY,
company_name  VARCHAR(150)  NOT NULL,
ruc           CHAR(11)      UNIQUE NOT NULL,
phone         BIGINT        NOT NULL,
email         VARCHAR(100)  UNIQUE NOT NULL,
address       VARCHAR(200)  NOT NULL,
status        BIT           NOT NULL DEFAULT 1, 
ubigeo_code   INT           NOT NULL,
category_id   INT           NOT NULL,
created_at    DATETIME      DEFAULT GETDATE(),
updated_at    DATETIME      NULL,
deleted_at    DATETIME      NULL,
restored_at   DATETIME      NULL,
CONSTRAINT FK_SUPPLIER_UBIGEO FOREIGN KEY (ubigeo_code)
    REFERENCES UBIGEO(ubigeo_code),
CONSTRAINT FK_SUPPLIER_CATEGORY FOREIGN KEY (category_id)
    REFERENCES CATEGORY(category_id)
);

CREATE TABLE PURCHASES(
id_purchase INT IDENTITY(1,1) PRIMARY KEY,
supplier_id INT NOT NULL,
employee_id INT NOT NULL,
date_purchases DATETIME NOT NULL,
total_amount DECIMAL(10,2) NOT NULL,
status VARCHAR(20) NOT NULL,
CONSTRAINT FK_PURCHASES_SUPPLIER FOREIGN KEY(supplier_id) REFERENCES SUPPLIER(supplier_id),
CONSTRAINT FK_PURCHASES_EMPLOYEE FOREIGN KEY(employee_id) REFERENCES EMPLOYEE(employee_id)
);

CREATE TABLE PURCHASES_DETAILS(
id_purchases_detail INT IDENTITY(1,1) PRIMARY KEY,
unit_price DECIMAL(10,2) NOT NULL,
amount_product INT NOT NULL,
total_cost DECIMAL(10,2) NOT NULL,
product_id INT NOT NULL,
id_purchase INT NOT NULL,
CONSTRAINT FK_PURCHASES_DETAILS_PRODUCT FOREIGN KEY(product_id) REFERENCES PRODUCTS_SUPPLY(product_id),
CONSTRAINT FK_PURCHASES_DETAILS_PURCHASE FOREIGN KEY(id_purchase) REFERENCES PURCHASES(id_purchase)
);

CREATE TABLE SALE(
sale_id INT IDENTITY(1,1) PRIMARY KEY,
sale_date DATETIME NOT NULL,
receipt_type VARCHAR(20) NOT NULL,
payment_method VARCHAR(20) NOT NULL,
status VARCHAR(20) NOT NULL,
total_cost DECIMAL(10,2) NOT NULL,
employee_id INT NOT NULL,
id_customer INT NOT NULL,
CONSTRAINT FK_SALE_EMPLOYEE FOREIGN KEY(employee_id) REFERENCES EMPLOYEE(employee_id),
CONSTRAINT FK_SALE_CUSTOMER FOREIGN KEY(id_customer) REFERENCES CUSTOMER(id_customer)
);

CREATE TABLE SALE_DETAILS(
id_sale_detail INT IDENTITY(1,1) PRIMARY KEY,
unit_price DECIMAL(10,2) NOT NULL,
product_amount INT NOT NULL,
subtotal_cost DECIMAL(10,2) NOT NULL,
products_sale_id INT NOT NULL,
sale_id INT NOT NULL,
CONSTRAINT FK_SALE_DETAILS_PRODUCT FOREIGN KEY(products_sale_id) REFERENCES PRODUCTS_SALE(products_sale_id),
CONSTRAINT FK_SALE_DETAILS_SALE FOREIGN KEY(sale_id) REFERENCES SALE(sale_id)
);

CREATE TABLE ORDERS(
order_id INT IDENTITY(1,1) PRIMARY KEY,
order_date DATETIME NOT NULL,
estimated_delivery DATE NOT NULL,
status VARCHAR(20) NOT NULL,
notes VARCHAR(MAX) NOT NULL,
total_estimated DECIMAL(10,2) NOT NULL,
created_at DATETIME DEFAULT GETDATE(),
updated_at DATETIME DEFAULT GETDATE(),
deleted_at DATETIME NULL,
restored_at DATETIME NULL,
employee_id INT NOT NULL,
id_customer INT NOT NULL,
CONSTRAINT FK_ORDERS_EMPLOYEE FOREIGN KEY(employee_id) REFERENCES EMPLOYEE(employee_id),
CONSTRAINT FK_ORDERS_CUSTOMER FOREIGN KEY(id_customer) REFERENCES CUSTOMER(id_customer)
);

CREATE TABLE ORDER_DETAILS(
id_order_detail INT IDENTITY(1,1) PRIMARY KEY,
quantity INT NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
subtotal DECIMAL(10,2) NOT NULL,
order_id INT NOT NULL,
products_sale_id INT NOT NULL,
CONSTRAINT FK_ORDER_DETAILS_ORDER FOREIGN KEY(order_id) REFERENCES ORDERS(order_id),
CONSTRAINT FK_ORDER_DETAILS_PRODUCT FOREIGN KEY(products_sale_id) REFERENCES PRODUCTS_SALE(products_sale_id)
);

CREATE TABLE PRODUCTION_BATCH(
batch_id INT IDENTITY(1,1) PRIMARY KEY,
id_order_detail INT NOT NULL,
products_sale_id INT NOT NULL,
employee_id INT NOT NULL,
quantity_initial INT NOT NULL,
start_date DATE NOT NULL,
estimated_ready_date DATE NOT NULL,
status VARCHAR(20) NOT NULL,
observations VARCHAR(500) NOT NULL,
created_at DATETIME DEFAULT GETDATE(),
updated_at DATETIME DEFAULT GETDATE(),
CONSTRAINT FK_BATCH_ORDER_DETAIL FOREIGN KEY(id_order_detail) REFERENCES ORDER_DETAILS(id_order_detail),
CONSTRAINT FK_BATCH_PRODUCT FOREIGN KEY(products_sale_id) REFERENCES PRODUCTS_SALE(products_sale_id),
CONSTRAINT FK_BATCH_EMPLOYEE FOREIGN KEY(employee_id) REFERENCES EMPLOYEE(employee_id)
);

CREATE TABLE PRODUCTION_STAGE(
stage_id INT IDENTITY(1,1) PRIMARY KEY,
stage_name VARCHAR(30) NOT NULL,
quantity_in INT NOT NULL,
quantity_lost INT NOT NULL,
start_date DATE NOT NULL,
end_date DATE NOT NULL,
observations VARCHAR(500) NOT NULL,
employee_id INT NOT NULL,
batch_id INT NOT NULL,
CONSTRAINT FK_STAGE_EMPLOYEE FOREIGN KEY(employee_id) REFERENCES EMPLOYEE(employee_id),
CONSTRAINT FK_STAGE_BATCH FOREIGN KEY(batch_id) REFERENCES PRODUCTION_BATCH(batch_id)
);

CREATE TABLE STOCK_MOVEMENT(
movement INT IDENTITY(1,1) PRIMARY KEY,
movement_type VARCHAR(20) NOT NULL,
movement_reason VARCHAR(100) NOT NULL,
quantity DECIMAL(10,2) NOT NULL,
stock_before DECIMAL(10,2) NOT NULL,
stock_after DECIMAL(10,2) NOT NULL,
comments VARCHAR(500) NOT NULL,
movement_date DATETIME NOT NULL,
created_at DATETIME DEFAULT GETDATE(),
employee_id INT NOT NULL,
sale_id INT NOT NULL,
batch_id INT NOT NULL,
products_sale_id INT NOT NULL,
product_id INT NOT NULL,
id_purchase INT NOT NULL,
CONSTRAINT FK_STOCK_EMPLOYEE FOREIGN KEY(employee_id) REFERENCES EMPLOYEE(employee_id),
CONSTRAINT FK_STOCK_SALE FOREIGN KEY(sale_id) REFERENCES SALE(sale_id),
CONSTRAINT FK_STOCK_BATCH FOREIGN KEY(batch_id) REFERENCES PRODUCTION_BATCH(batch_id),
CONSTRAINT FK_STOCK_PRODUCT_SALE FOREIGN KEY(products_sale_id) REFERENCES PRODUCTS_SALE(products_sale_id),
CONSTRAINT FK_STOCK_PRODUCT_SUPPLY FOREIGN KEY(product_id) REFERENCES PRODUCTS_SUPPLY(product_id),
CONSTRAINT FK_STOCK_PURCHASE FOREIGN KEY(id_purchase) REFERENCES PURCHASES(id_purchase)
);

-- =====================================================
-- UBIGEO ( registros - tabla apoyo)
-- =====================================================
INSERT INTO UBIGEO(ubigeo_code, department, province, district) VALUES
(150122, 'Lima',         'Lima',      'Miraflores'),
(070101, 'Callao',       'Callao',    'Bellavista'),
(080101, 'Cusco',        'Cusco',     'Wanchaq'),
(040101, 'Arequipa',     'Arequipa',  'Cayma'),
(130101, 'La Libertad',  'Trujillo',  'Víctor Larco'),
(150101, 'Lima',         'Lima',      'Lima Cercado'),
(150102, 'Lima',         'Lima',      'Breña'),
(150103, 'Lima',         'Lima',      'La Victoria'),
(150104, 'Lima',         'Lima',      'San Isidro'),
(150105, 'Lima',         'Lima',      'Surco'),
(150106, 'Lima',         'Lima',      'Barranco'),
(150107, 'Lima',         'Lima',      'Chorrillos'),
(150108, 'Lima',         'Lima',      'San Borja'),
(150109, 'Lima',         'Lima',      'Surquillo'),
(150110, 'Lima',         'Lima',      'Magdalena'),
(150111, 'Lima',         'Lima',      'Pueblo Libre'),
(150112, 'Lima',         'Lima',      'Jesús María'),
(150113, 'Lima',         'Lima',      'Lince'),
(150114, 'Lima',         'Lima',      'San Miguel'),
(150115, 'Lima',         'Lima',      'Ate'),
(150116, 'Lima',         'Lima',      'San Juan de Lurigancho'),
(150117, 'Lima',         'Lima',      'Comas'),
(150118, 'Lima',         'Lima',      'Los Olivos'),
(150119, 'Lima',         'Lima',      'Independencia'),
(150120, 'Lima',         'Lima',      'Rímac'),
(150301, 'Lima',         'Lima',      'Santa Anita'),
(150401, 'Lima',         'Lima',      'El Agustino'),
(070201, 'Callao',       'Callao',    'La Punta'),
(070301, 'Callao',       'Callao',    'La Perla'),
(070401, 'Callao',       'Callao',    'Carmen de la Legua'),
(080201, 'Cusco',        'Cusco',     'San Sebastián'),
(080301, 'Cusco',        'Cusco',     'San Jerónimo'),
(080401, 'Cusco',        'Cusco',     'Saylla'),
(040201, 'Arequipa',     'Arequipa',  'Cerro Colorado'),
(040301, 'Arequipa',     'Arequipa',  'Sachaca'),
(040401, 'Arequipa',     'Arequipa',  'Yanahuara'),
(130201, 'La Libertad',  'Trujillo',  'El Porvenir'),
(130301, 'La Libertad',  'Trujillo',  'Florencia de Mora'),
(130401, 'La Libertad',  'Trujillo',  'La Esperanza');
-- =====================================================
-- CATEGORY (5 registros - tabla apoyo)
-- =====================================================
INSERT INTO CATEGORY(category_name,category_type,status) VALUES
('Flores Naturales','VENTA','ACTIVO'),
('Arreglos Premium','VENTA','ACTIVO'),
('Insumos Florales','INSUMO','ACTIVO'),
('Macetas','INSUMO','ACTIVO'),
('Decoraciones','VENTA','ACTIVO');

-- =====================================================
-- ROLES (5 registros - tabla apoyo)
-- =====================================================
INSERT INTO ROLES(role_name,status,description) VALUES
('Administrador','ACTIVO','Control total'),
('Vendedor','ACTIVO','Gestiona ventas'),
('Supervisor','ACTIVO','Supervisa producción'),
('Almacenero','ACTIVO','Gestiona inventario'),
('Operario','ACTIVO','Trabaja producción');

-- =====================================================
-- CUSTOMER (20 registros)
-- =====================================================
INSERT INTO CUSTOMER (customer_name,customer_lastname,customer_type,document_type,document_number,email,phone,address,status,ubigeo_code)VALUES
('Lucia','Sanchez','Natural','DNI','78451236','lucia.sanchez@gmail.com','987654321','Av. Los Olivos 123',1,150101),
('Carlos','Ramirez','Natural','DNI','74125896','carlos.ramirez@gmail.com','912345678','Jr. Lima 456',1,150102),
('Andrea','Torres','Natural','DNI','75315984','andrea.torres@gmail.com','923456781','Av. Primavera 789',1,150103),
('Miguel','Castro','Empresa','RUC','20547896321','miguel.castro@gmail.com','934567812','Calle Comercio 321',1,150104),
('Fernanda','Lopez','Natural','DNI','79632514','fernanda.lopez@gmail.com','945678123','Av. Central 654',1,150105),
('Jorge','Perez','Natural','DNI','74123698','jorge.perez@gmail.com','956781234','Jr. Las Flores 741',0,150106),
('Valeria','Mendoza','Natural','DNI','78541236','valeria.mendoza@gmail.com','967812345','Av. Grau 852',1,150107),
('Kevin','Rojas','Empresa','RUC','20698541237','kevin.rojas@gmail.com','978123456','Calle Norte 963',1,150108),
('Daniela','Gutierrez','Natural','DNI','79874563','daniela.gutierrez@gmail.com','989234567','Av. Sur 159',1,150109),
('Luis','Vargas','Natural','DNI','73698521','luis.vargas@gmail.com','991345678','Jr. Unión 753',1,150110),
('Camila','Navarro','Natural','DNI','74589632','camila.navarro@gmail.com','902456789','Av. Libertad 951',1,150111),
('Sebastian','Flores','Empresa','RUC','20478596325','sebastian.flores@gmail.com','913567890','Calle Sol 357',0,150112),
('Mariana','Diaz','Natural','DNI','78965412','mariana.diaz@gmail.com','924678901','Av. San Martín 258',1,150113),
('Ricardo','Herrera','Natural','DNI','75412369','ricardo.herrera@gmail.com','935789012','Jr. Palmeras 456',1,150114),
('Paula','Silva','Natural','DNI','76521498','paula.silva@gmail.com','946890123','Av. Arequipa 654',1,150115),
('Diego','Morales','Empresa','RUC','20987456321','diego.morales@gmail.com','957901234','Calle Este 852',1,150116),
('Nicole','Reyes','Natural','DNI','74123657','nicole.reyes@gmail.com','968012345','Av. Canadá 951',1,150117),
('Fabian','Cruz','Natural','DNI','75236984','fabian.cruz@gmail.com','979123456','Jr. Los Pinos 753',0,150118),
('Tatiana','Ortega','Natural','DNI','76325874','tatiana.ortega@gmail.com','980234567','Av. Javier Prado 357',1,150119),
('Alonso','Medina','Empresa','RUC','20147896325','alonso.medina@gmail.com','991345679','Calle Industrial 159',1,150120);

-- =====================================================
-- EMPLOYEE (20 registros)
-- =====================================================
INSERT INTO EMPLOYEE(ubigeo_code,role_id,document_type,document_number,name,last_name,phone,email,address,entry_date,status,password) VALUES
(150122,1,'DNI','78945612','Luis','Paredes','987111222','luis@empresa.com','Av Principal 111','2025-01-10','ACTIVO','123456'),
(070101,2,'DNI','78945613','Ana','Rojas','987111223','ana@empresa.com','Av Principal 112','2025-02-15','ACTIVO','123456'),
(080101,3,'DNI','78945614','Pedro','Castro','987111224','pedro@empresa.com','Av Principal 113','2025-03-12','ACTIVO','123456'),
(040101,4,'DNI','78945615','Elena','Quispe','987111225','elena@empresa.com','Av Principal 114','2025-04-18','ACTIVO','123456'),
(130101,5,'DNI','78945616','Mario','Vega','987111226','mario@empresa.com','Av Principal 115','2025-05-05','ACTIVO','123456'),
(150122,1,'DNI','78945001','Julio','Fernandez','911000001','julio@empresa.com','Av Empresa 101','2025-06-01','ACTIVO','123456'),
(070101,2,'DNI','78945002','Sandra','Martinez','911000002','sandra@empresa.com','Av Empresa 102','2025-06-02','ACTIVO','123456'),
(080101,3,'DNI','78945003','Raul','Pacheco','911000003','raul@empresa.com','Av Empresa 103','2025-06-03','ACTIVO','123456'),
(040101,4,'DNI','78945004','Carmen','Soto','911000004','carmen@empresa.com','Av Empresa 104','2025-06-04','ACTIVO','123456'),
(130101,5,'DNI','78945005','Bruno','Aguilar','911000005','bruno@empresa.com','Av Empresa 105','2025-06-05','ACTIVO','123456'),
(150122,1,'DNI','78945006','Noelia','Campos','911000006','noelia@empresa.com','Av Empresa 106','2025-06-06','ACTIVO','123456'),
(070101,2,'DNI','78945007','Victor','Luna','911000007','victor@empresa.com','Av Empresa 107','2025-06-07','ACTIVO','123456'),
(080101,3,'DNI','78945008','Melissa','Garcia','911000008','melissa@empresa.com','Av Empresa 108','2025-06-08','ACTIVO','123456'),
(040101,4,'DNI','78945009','Cristian','Perez','911000009','cristian@empresa.com','Av Empresa 109','2025-06-09','ACTIVO','123456'),
(130101,5,'DNI','78945010','Tatiana','Mendez','911000010','tatiana@empresa.com','Av Empresa 110','2025-06-10','ACTIVO','123456'),
(150122,1,'DNI','78945011','Oscar','Rivera','911000011','oscar@empresa.com','Av Empresa 111','2025-06-11','ACTIVO','123456'),
(070101,2,'DNI','78945012','Fiorella','Alva','911000012','fiorella@empresa.com','Av Empresa 112','2025-06-12','ACTIVO','123456'),
(080101,3,'DNI','78945013','Martin','Cordero','911000013','martin@empresa.com','Av Empresa 113','2025-06-13','ACTIVO','123456'),
(040101,4,'DNI','78945014','Karen','Rios','911000014','karen@empresa.com','Av Empresa 114','2025-06-14','ACTIVO','123456'),
(130101,5,'DNI','78945015','Edgar','Velasquez','911000015','edgar@empresa.com','Av Empresa 115','2025-06-15','ACTIVO','123456');

-- =====================================================
-- PRODUCTS_SALE (20 registros)
-- =====================================================
INSERT INTO PRODUCTS_SALE(product_name, price, available_stock, unit_measurement, description, category_id) VALUES
('Arándano Selecto',        25.00, 150, 'KG',     'Arándano premium exportación',        1),
('Frutilla Fresca',         15.00, 200, 'KG',     'Frutilla cosechada del sur',          1),
('Frambuesa Natural',       20.00, 180, 'KG',     'Frambuesa jugosa y dulce',            2),
('Mora Silvestre',          18.00, 120, 'KG',     'Mora recolectada artesanal',          2),
('Mix Berries Sur',         30.00,  90, 'KG',     'Mezcla de berries del sur',           3),
('Arándano Congelado',      22.00, 300, 'KG',     'Arándano IQF listo exportar',         1),
('Frutilla Congelada',      14.00, 250, 'KG',     'Frutilla IQF seleccionada',           1),
('Frambuesa Congelada',     19.00, 210, 'KG',     'Frambuesa IQF premium',               2),
('Mora Congelada',          17.00, 190, 'KG',     'Mora IQF recolectada sur',            2),
('Arándano Deshidratado',   35.00,  80, 'KG',     'Arándano seco snack natural',         3),
('Frutilla Deshidratada',   28.00,  70, 'KG',     'Frutilla seca seleccionada',          3),
('Frambuesa Deshidratada',  32.00,  60, 'KG',     'Frambuesa seca premium sur',          3),
('Mora Deshidratada',       27.00,  65, 'KG',     'Mora seca artesanal del sur',         4),
('Mermelada Arándano',      12.00, 100, 'UNIDAD', 'Mermelada artesanal arándano',        4),
('Mermelada Frutilla',      10.00, 120, 'UNIDAD', 'Mermelada artesanal frutilla',        4),
('Mermelada Mix Berries',   13.00,  90, 'UNIDAD', 'Mermelada mezcla berries sur',        5),
('Jugo Arándano Natural',   18.00,  75, 'LITRO',  'Jugo puro arándano sin azúcar',       5),
('Jugo Frutilla Natural',   15.00,  80, 'LITRO',  'Jugo puro frutilla sin azúcar',       5),
('Pack Berries Frescos',    45.00,  50, 'UNIDAD', 'Pack surtido berries frescos sur',    5), 
('Pack Berries Congelados', 40.00,  55, 'UNIDAD', 'Pack surtido berries congelados sur', 5); 

-- =====================================================
-- PRODUCTS_SUPPLY (20 registros)
-- =====================================================
INSERT INTO PRODUCTS_SUPPLY(product_name,description,price,available_stock,expiry_date,unit_measurement,product_image,category_id) VALUES
('Espuma Floral','Espuma flores',15,50,'2026-12-31','UNIDAD',0x1234,3),
('Cinta Roja','Cinta decorativa',5,100,'2027-01-15','UNIDAD',0x1234,5),
('Maceta Blanca','Maceta cerámica',25,30,'2028-05-20','UNIDAD',0x1234,4),
('Papel Coreano','Papel decorativo',8,70,'2027-03-11','UNIDAD',0x1234,5),
('Fertilizante','Nutriente floral',18,40,'2026-08-01','UNIDAD',0x1234,3),
('Cinta Dorada','Decoración lujo',7,90,'2027-02-10','UNIDAD',0x1234,5),
('Maceta Negra','Maceta elegante',28,25,'2028-07-15','UNIDAD',0x1234,4),
('Espuma Premium','Espuma resistente',20,45,'2026-11-20','UNIDAD',0x1234,3),
('Papel Satinado','Papel premium',10,60,'2027-04-18','UNIDAD',0x1234,5),
('Abono Floral','Abono natural',22,35,'2026-09-10','UNIDAD',0x1234,3),
('Maceta Roja','Maceta moderna',30,22,'2028-01-05','UNIDAD',0x1234,4),
('Cinta Plateada','Decoración plateada',6,110,'2027-06-06','UNIDAD',0x1234,5),
('Silicona Floral','Pegamento floral',14,55,'2027-07-01','UNIDAD',0x1234,3),
('Papel Kraft','Empaque natural',9,80,'2027-05-12','UNIDAD',0x1234,5),
('Maceta Beige','Maceta clásica',27,20,'2028-03-14','UNIDAD',0x1234,4),
('Espuma Económica','Espuma básica',12,65,'2026-10-10','UNIDAD',0x1234,3),
('Cinta Azul','Decoración azul',5,120,'2027-08-08','UNIDAD',0x1234,5),
('Fertilizante Plus','Nutriente premium',25,28,'2026-12-15','UNIDAD',0x1234,3),
('Maceta Decorativa','Diseño especial',35,18,'2028-06-22','UNIDAD',0x1234,4),
('Papel Japonés','Papel elegante',11,75,'2027-09-09','UNIDAD',0x1234,5);

-- =====================================================
-- SUPPLIER (20 registros)
-- =====================================================
INSERT INTO SUPPLIER(company_name, ruc, phone, email, address, status, ubigeo_code, category_id) VALUES
('Flores SAC',           '20111111111', 987000111, 'ventas@flores.com',       'Av Floral 111',         1, 150122, 1),
('Deco Perú',            '20222222222', 987000112, 'ventas@deco.com',         'Av Deco 222',           1, 070101, 5),
('Insumos Flor',         '20333333333', 987000113, 'ventas@insumos.com',      'Av Insumos 333',        1, 080101, 3),
('Macetas Perú',         '20444444444', 987000114, 'ventas@macetas.com',      'Av Macetas 444',        1, 040101, 4),
('Tulipanes SAC',        '20555555555', 987000115, 'ventas@tulipanes.com',    'Av Tulipanes 555',      1, 130101, 2),
('Jardines Lima',        '20666666666', 987000116, 'ventas@jardines.com',     'Av Jardines 666',       1, 150101, 1),
('Verde Natural',        '20777777777', 987000117, 'ventas@verde.com',        'Av Verde 777',          1, 070201, 3),
('Semillas Perú',        '20888888888', 987000118, 'ventas@semillas.com',     'Av Semillas 888',       1, 080201, 2),
('Plantas Express',      '20999999999', 987000119, 'ventas@plantas.com',      'Av Plantas 999',        1, 040201, 5),
('Agro Lima SAC',        '20100000001', 987000120, 'ventas@agrolima.com',     'Av Agro 100',           1, 130201, 4),
('Flores del Norte',     '20100000002', 987000121, 'ventas@floresnorte.com',  'Av Norte 111',          1, 150301, 1),
('Cactus World',         '20100000003', 987000122, 'ventas@cactus.com',       'Av Cactus 222',         1, 070301, 3),
('Tierra Viva',          '20100000004', 987000123, 'ventas@tierraviva.com',   'Av Tierra 333',         1, 080301, 2),
('Humus Natural',        '20100000005', 987000124, 'ventas@humus.com',        'Av Humus 444',          1, 040301, 4),
('Rosas del Sur',        '20100000006', 987000125, 'ventas@rosassur.com',     'Av Sur 555',            1, 130301, 5),
('Agro Verde SAC',       '20100000007', 987000126, 'ventas@agroverde.com',    'Av Agro Verde 666',     0, 150401, 2),
('Orquídeas Perú',       '20100000008', 987000127, 'ventas@orquideas.com',    'Av Orquídeas 777',      0, 070401, 1),
('Fertilizantes SAC',    '20100000009', 987000128, 'ventas@fertilizantes.com','Av Fertilizantes 888',  0, 080401, 3),
('Vivero Central',       '20100000010', 987000129, 'ventas@vivero.com',       'Av Vivero 999',         0, 040401, 4),
('Jardín Paraíso',       '20100000011', 987000130, 'ventas@jardinparaiso.com','Av Paraíso 1000',       0, 130401, 5);

-- =====================================================
-- PURCHASES (20 registros)
-- =====================================================
INSERT INTO PURCHASES(supplier_id,employee_id,date_purchases,total_amount,status) VALUES
(1,1,'2026-01-10',500,'COMPLETADO'),
(2,2,'2026-01-12',650,'COMPLETADO'),
(3,3,'2026-01-14',400,'PENDIENTE'),
(4,4,'2026-01-16',750,'COMPLETADO'),
(5,5,'2026-01-18',900,'COMPLETADO'),
(6,6,'2026-01-20',350,'COMPLETADO'),
(7,7,'2026-01-22',470,'PENDIENTE'),
(8,8,'2026-01-24',800,'COMPLETADO'),
(9,9,'2026-01-26',920,'COMPLETADO'),
(10,10,'2026-01-28',610,'COMPLETADO'),
(11,11,'2026-02-01',300,'PENDIENTE'),
(12,12,'2026-02-03',550,'COMPLETADO'),
(13,13,'2026-02-05',720,'COMPLETADO'),
(14,14,'2026-02-07',410,'COMPLETADO'),
(15,15,'2026-02-09',880,'COMPLETADO'),
(16,16,'2026-02-11',990,'PENDIENTE'),
(17,17,'2026-02-13',640,'COMPLETADO'),
(18,18,'2026-02-15',530,'COMPLETADO'),
(19,19,'2026-02-17',770,'COMPLETADO'),
(20,20,'2026-02-19',860,'COMPLETADO');

-- =====================================================
-- PURCHASES_DETAILS (20 registros)
-- =====================================================
INSERT INTO PURCHASES_DETAILS(unit_price,amount_product,total_cost,product_id,id_purchase) VALUES
(15,10,150,1,1),
(5,20,100,2,2),
(25,8,200,3,3),
(8,15,120,4,4),
(18,12,216,5,5),
(7,25,175,6,6),
(28,6,168,7,7),
(20,9,180,8,8),
(10,14,140,9,9),
(22,11,242,10,10),
(30,5,150,11,11),
(6,30,180,12,12),
(14,10,140,13,13),
(9,18,162,14,14),
(27,7,189,15,15),
(12,20,240,16,16),
(5,35,175,17,17),
(25,9,225,18,18),
(35,4,140,19,19),
(11,16,176,20,20);

-- =====================================================
-- SALE (20 registros)
-- =====================================================
INSERT INTO SALE(sale_date,receipt_type,payment_method,status,total_cost,employee_id,id_customer) VALUES
('2026-02-01','BOLETA','YAPE','COMPLETADO',150,1,1),
('2026-02-02','FACTURA','EFECTIVO','COMPLETADO',200,2,2),
('2026-02-03','BOLETA','TARJETA','COMPLETADO',180,3,3),
('2026-02-04','FACTURA','PLIN','COMPLETADO',250,4,4),
('2026-02-05','BOLETA','YAPE','COMPLETADO',300,5,5),
('2026-02-06','FACTURA','EFECTIVO','COMPLETADO',120,6,6),
('2026-02-07','BOLETA','PLIN','COMPLETADO',220,7,7),
('2026-02-08','FACTURA','TARJETA','COMPLETADO',280,8,8),
('2026-02-09','BOLETA','YAPE','COMPLETADO',350,9,9),
('2026-02-10','FACTURA','EFECTIVO','COMPLETADO',170,10,10),
('2026-02-11','BOLETA','PLIN','COMPLETADO',160,11,11),
('2026-02-12','FACTURA','TARJETA','COMPLETADO',260,12,12),
('2026-02-13','BOLETA','YAPE','COMPLETADO',400,13,13),
('2026-02-14','FACTURA','EFECTIVO','COMPLETADO',190,14,14),
('2026-02-15','BOLETA','PLIN','COMPLETADO',310,15,15),
('2026-02-16','FACTURA','TARJETA','COMPLETADO',210,16,16),
('2026-02-17','BOLETA','YAPE','COMPLETADO',500,17,17),
('2026-02-18','FACTURA','EFECTIVO','COMPLETADO',230,18,18),
('2026-02-19','BOLETA','PLIN','COMPLETADO',240,19,19),
('2026-02-20','FACTURA','TARJETA','COMPLETADO',450,20,20);

-- =====================================================
-- SALE_DETAILS (20 registros)
-- =====================================================
INSERT INTO SALE_DETAILS(unit_price,product_amount,subtotal_cost,products_sale_id,sale_id) VALUES
(150,1,150,1,1),
(200,1,200,2,2),
(180,1,180,3,3),
(250,1,250,4,4),
(300,1,300,5,5),
(120,1,120,6,6),
(220,1,220,7,7),
(280,1,280,8,8),
(350,1,350,9,9),
(170,1,170,10,10),
(160,1,160,11,11),
(260,1,260,12,12),
(400,1,400,13,13),
(190,1,190,14,14),
(310,1,310,15,15),
(210,1,210,16,16),
(500,1,500,17,17),
(230,1,230,18,18),
(240,1,240,19,19),
(450,1,450,20,20);

-- =====================================================
-- ORDERS (20 registros)
-- =====================================================
INSERT INTO ORDERS(order_date,estimated_delivery,status,notes,total_estimated,employee_id,id_customer) VALUES
('2026-03-01','2026-03-03','PENDIENTE','Pedido urgente',150,1,1),
('2026-03-02','2026-03-04','EN PROCESO','Decoración especial',200,2,2),
('2026-03-03','2026-03-05','PENDIENTE','Pedido empresarial',180,3,3),
('2026-03-04','2026-03-06','COMPLETADO','Evento social',250,4,4),
('2026-03-05','2026-03-07','EN PROCESO','San Valentín',300,5,5),
('2026-03-06','2026-03-08','PENDIENTE','Decoración boda',120,6,6),
('2026-03-07','2026-03-09','COMPLETADO','Cumpleaños',220,7,7),
('2026-03-08','2026-03-10','EN PROCESO','Evento corporativo',280,8,8),
('2026-03-09','2026-03-11','PENDIENTE','Pedido floral',350,9,9),
('2026-03-10','2026-03-12','COMPLETADO','Decoración hogar',170,10,10),
('2026-03-11','2026-03-13','EN PROCESO','Pedido especial',160,11,11),
('2026-03-12','2026-03-14','PENDIENTE','Arreglo premium',260,12,12),
('2026-03-13','2026-03-15','COMPLETADO','Evento familiar',400,13,13),
('2026-03-14','2026-03-16','EN PROCESO','Decoración salón',190,14,14),
('2026-03-15','2026-03-17','PENDIENTE','Ramo especial',310,15,15),
('2026-03-16','2026-03-18','COMPLETADO','Pedido aniversario',210,16,16),
('2026-03-17','2026-03-19','EN PROCESO','Evento elegante',500,17,17),
('2026-03-18','2026-03-20','PENDIENTE','Decoración oficina',230,18,18),
('2026-03-19','2026-03-21','COMPLETADO','Arreglo moderno',240,19,19),
('2026-03-20','2026-03-22','EN PROCESO','Pedido deluxe',450,20,20);

-- =====================================================
-- ORDER_DETAILS (20 registros)
-- =====================================================
INSERT INTO ORDER_DETAILS(quantity,unit_price,subtotal,order_id,products_sale_id) VALUES
(1,150,150,1,1),
(1,200,200,2,2),
(1,180,180,3,3),
(1,250,250,4,4),
(1,300,300,5,5),
(1,120,120,6,6),
(1,220,220,7,7),
(1,280,280,8,8),
(1,350,350,9,9),
(1,170,170,10,10),
(1,160,160,11,11),
(1,260,260,12,12),
(1,400,400,13,13),
(1,190,190,14,14),
(1,310,310,15,15),
(1,210,210,16,16),
(1,500,500,17,17),
(1,230,230,18,18),
(1,240,240,19,19),
(1,450,450,20,20);

-- =====================================================
-- PRODUCTION_BATCH (20 registros)
-- =====================================================
INSERT INTO PRODUCTION_BATCH(id_order_detail,products_sale_id,employee_id,quantity_initial,start_date,estimated_ready_date,status,observations) VALUES
(1,1,1,10,'2026-03-01','2026-03-02','EN PROCESO','Producción normal'),
(2,2,2,8,'2026-03-02','2026-03-03','EN PROCESO','Pedido decorativo'),
(3,3,3,5,'2026-03-03','2026-03-04','PENDIENTE','Pendiente materiales'),
(4,4,4,7,'2026-03-04','2026-03-05','COMPLETADO','Terminado'),
(5,5,5,6,'2026-03-05','2026-03-06','EN PROCESO','Producción activa'),
(6,6,6,4,'2026-03-06','2026-03-07','PENDIENTE','Falta stock'),
(7,7,7,9,'2026-03-07','2026-03-08','COMPLETADO','Correcto'),
(8,8,8,11,'2026-03-08','2026-03-09','EN PROCESO','Producción rápida'),
(9,9,9,3,'2026-03-09','2026-03-10','PENDIENTE','En espera'),
(10,10,10,6,'2026-03-10','2026-03-11','COMPLETADO','Finalizado'),
(11,11,11,5,'2026-03-11','2026-03-12','EN PROCESO','Proceso normal'),
(12,12,12,7,'2026-03-12','2026-03-13','PENDIENTE','Falta material'),
(13,13,13,2,'2026-03-13','2026-03-14','COMPLETADO','Entrega lista'),
(14,14,14,10,'2026-03-14','2026-03-15','EN PROCESO','Trabajo continuo'),
(15,15,15,4,'2026-03-15','2026-03-16','PENDIENTE','Pendiente aprobación'),
(16,16,16,8,'2026-03-16','2026-03-17','COMPLETADO','Pedido terminado'),
(17,17,17,5,'2026-03-17','2026-03-18','EN PROCESO','Producción especial'),
(18,18,18,9,'2026-03-18','2026-03-19','PENDIENTE','Esperando materiales'),
(19,19,19,3,'2026-03-19','2026-03-20','COMPLETADO','Sin observaciones'),
(20,20,20,12,'2026-03-20','2026-03-21','EN PROCESO','Pedido premium');

-- =====================================================
-- PRODUCTION_STAGE (20 registros)
-- =====================================================
INSERT INTO PRODUCTION_STAGE(stage_name,quantity_in,quantity_lost,start_date,end_date,observations,employee_id,batch_id) VALUES
('Diseño',10,0,'2026-03-01','2026-03-01','Sin pérdidas',1,1),
('Corte',8,1,'2026-03-02','2026-03-02','Pérdida mínima',2,2),
('Armado',5,0,'2026-03-03','2026-03-03','Correcto',3,3),
('Decoración',7,1,'2026-03-04','2026-03-04','Detalle menor',4,4),
('Empaque',6,0,'2026-03-05','2026-03-05','Finalizado',5,5),
('Diseño',4,0,'2026-03-06','2026-03-06','Proceso normal',6,6),
('Corte',9,1,'2026-03-07','2026-03-07','Pérdida leve',7,7),
('Armado',11,0,'2026-03-08','2026-03-08','Sin errores',8,8),
('Decoración',3,0,'2026-03-09','2026-03-09','Trabajo limpio',9,9),
('Empaque',6,1,'2026-03-10','2026-03-10','Caja dañada',10,10),
('Diseño',5,0,'2026-03-11','2026-03-11','Todo correcto',11,11),
('Corte',7,1,'2026-03-12','2026-03-12','Pérdida regular',12,12),
('Armado',2,0,'2026-03-13','2026-03-13','Sin observaciones',13,13),
('Decoración',10,1,'2026-03-14','2026-03-14','Detalle pequeño',14,14),
('Empaque',4,0,'2026-03-15','2026-03-15','Correcto',15,15),
('Diseño',8,0,'2026-03-16','2026-03-16','Producción estable',16,16),
('Corte',5,1,'2026-03-17','2026-03-17','Pérdida menor',17,17),
('Armado',9,0,'2026-03-18','2026-03-18','Buen armado',18,18),
('Decoración',3,0,'2026-03-19','2026-03-19','Sin daños',19,19),
('Empaque',12,1,'2026-03-20','2026-03-20','Empaque premium',20,20);

-- =====================================================
-- STOCK_MOVEMENT (20 registros)
-- =====================================================
INSERT INTO STOCK_MOVEMENT(movement_type,movement_reason,quantity,stock_before,stock_after,comments,movement_date,employee_id,sale_id,batch_id,products_sale_id,product_id,id_purchase) VALUES
('SALIDA','Venta producto',1,20,19,'Venta realizada','2026-04-01',1,1,1,1,1,1),
('ENTRADA','Compra proveedor',20,50,70,'Ingreso stock','2026-04-02',2,2,2,2,2,2),
('SALIDA','Producción',5,30,25,'Uso interno','2026-04-03',3,3,3,3,3,3),
('ENTRADA','Reposición',10,25,35,'Reposición almacén','2026-04-04',4,4,4,4,4,4),
('SALIDA','Venta especial',2,15,13,'Pedido VIP','2026-04-05',5,5,5,5,5,5),
('ENTRADA','Compra stock',15,40,55,'Nuevo ingreso','2026-04-06',6,6,6,6,6,6),
('SALIDA','Producción floral',4,22,18,'Uso producción','2026-04-07',7,7,7,7,7,7),
('ENTRADA','Reposición proveedor',18,35,53,'Stock renovado','2026-04-08',8,8,8,8,8,8),
('SALIDA','Venta rápida',3,16,13,'Cliente frecuente','2026-04-09',9,9,9,9,9,9),
('ENTRADA','Compra masiva',25,45,70,'Ingreso mayor','2026-04-10',10,10,10,10,10,10),
('SALIDA','Pedido empresarial',6,28,22,'Salida almacén','2026-04-11',11,11,11,11,11,11),
('ENTRADA','Ajuste inventario',12,30,42,'Regularización','2026-04-12',12,12,12,12,12,12),
('SALIDA','Decoración evento',5,19,14,'Evento social','2026-04-13',13,13,13,13,13,13),
('ENTRADA','Compra adicional',10,33,43,'Stock adicional','2026-04-14',14,14,14,14,14,14),
('SALIDA','Venta online',2,17,15,'Compra web','2026-04-15',15,15,15,15,15,15),
('ENTRADA','Ingreso almacén',8,24,32,'Ingreso normal','2026-04-16',16,16,16,16,16,16),
('SALIDA','Pedido premium',7,29,22,'Uso especial','2026-04-17',17,17,17,17,17,17),
('ENTRADA','Reposición urgente',14,20,34,'Reposición rápida','2026-04-18',18,18,18,18,18,18),
('SALIDA','Venta directa',1,13,12,'Cliente mostrador','2026-04-19',19,19,19,19,19,19),
('ENTRADA','Compra mensual',30,50,80,'Ingreso mensual','2026-04-20',20,20,20,20,20,20);
