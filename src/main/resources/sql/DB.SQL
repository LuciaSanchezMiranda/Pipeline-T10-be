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
ubigeo_code INT IDENTITY(1,1) PRIMARY KEY,
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
customer_name VARCHAR(50) NOT NULL,
customer_lastname VARCHAR(60) NOT NULL,
customer_type VARCHAR(20) NOT NULL,
document_type VARCHAR(5) NOT NULL,
document_number VARCHAR(15) UNIQUE NOT NULL,
email VARCHAR(150) UNIQUE NOT NULL,
phone CHAR(9) NOT NULL,
address VARCHAR(200) NOT NULL,
status VARCHAR(10) NOT NULL,
created_at DATETIME DEFAULT GETDATE(),
updated_at DATETIME DEFAULT GETDATE(),
deleted_at DATETIME NULL,
restored_at DATETIME NULL,
ubigeo_code INT NOT NULL,
CONSTRAINT FK_CUSTOMER_UBIGEO FOREIGN KEY(ubigeo_code) REFERENCES UBIGEO(ubigeo_code)
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
description VARCHAR(MAX) NOT NULL,
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

CREATE TABLE SUPPLIER(
supplier_id INT IDENTITY(1,1) PRIMARY KEY,
company_name VARCHAR(150) NOT NULL,
ruc CHAR(11) UNIQUE NOT NULL,
phone CHAR(9) NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
address VARCHAR(200) NOT NULL,
status VARCHAR(20) NOT NULL,
created_at DATETIME DEFAULT GETDATE(),
updated_at DATETIME DEFAULT GETDATE(),
deleted_at DATETIME NULL,
restored_at DATETIME NULL,
ubigeo_code INT NOT NULL,
category_id INT NOT NULL,
CONSTRAINT FK_SUPPLIER_UBIGEO FOREIGN KEY(ubigeo_code) REFERENCES UBIGEO(ubigeo_code),
CONSTRAINT FK_SUPPLIER_CATEGORY FOREIGN KEY(category_id) REFERENCES CATEGORY(category_id)
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

INSERT INTO UBIGEO(department,province,district) VALUES
('Lima','Lima','Miraflores'),
('Lima','Callao','Bellavista'),
('Cusco','Cusco','Wanchaq'),
('Arequipa','Arequipa','Cayma'),
('La Libertad','Trujillo','Víctor Larco');

INSERT INTO CATEGORY(category_name,category_type,status) VALUES
('Flores Naturales','VENTA','ACTIVO'),
('Arreglos Premium','VENTA','ACTIVO'),
('Insumos Florales','INSUMO','ACTIVO'),
('Macetas','INSUMO','ACTIVO'),
('Decoraciones','VENTA','ACTIVO');

INSERT INTO ROLES(role_name,status,description) VALUES
('Administrador','ACTIVO','Control total'),
('Vendedor','ACTIVO','Gestiona ventas'),
('Supervisor','ACTIVO','Supervisa producción'),
('Almacenero','ACTIVO','Gestiona inventario'),
('Operario','ACTIVO','Trabaja producción');

INSERT INTO CUSTOMER(customer_name,customer_lastname,customer_type,document_type,document_number,email,phone,address,status,ubigeo_code) VALUES
('Maria','Ninahuanca','FRECUENTE','DNI','71234567','maria@gmail.com','987654321','Av Lima 123','ACTIVO',1),
('Carlos','Ramirez','NORMAL','DNI','74561234','carlos@gmail.com','912345678','Jr Sol 456','ACTIVO',2),
('Lucia','Torres','VIP','DNI','70123456','lucia@gmail.com','923456781','Av Perú 789','ACTIVO',3),
('Jorge','Mendoza','NORMAL','DNI','73456789','jorge@gmail.com','934567812','Calle Norte 321','ACTIVO',4),
('Andrea','Salas','VIP','DNI','75678901','andrea@gmail.com','945678123','Av Central 852','ACTIVO',5);

INSERT INTO EMPLOYEE(ubigeo_code,role_id,document_type,document_number,name,last_name,phone,email,address,entry_date,status,password) VALUES
(1,1,'DNI','78945612','Luis','Paredes','987111222','luis@empresa.com','Av Principal 111','2025-01-10','ACTIVO','123456'),
(2,2,'DNI','78945613','Ana','Rojas','987111223','ana@empresa.com','Av Principal 112','2025-02-15','ACTIVO','123456'),
(3,3,'DNI','78945614','Pedro','Castro','987111224','pedro@empresa.com','Av Principal 113','2025-03-12','ACTIVO','123456'),
(4,4,'DNI','78945615','Elena','Quispe','987111225','elena@empresa.com','Av Principal 114','2025-04-18','ACTIVO','123456'),
(5,5,'DNI','78945616','Mario','Vega','987111226','mario@empresa.com','Av Principal 115','2025-05-05','ACTIVO','123456');

INSERT INTO PRODUCTS_SALE(product_name,price,available_stock,unit_measurement,description,category_id) VALUES
('Ramo Rosas',150,20,'UNIDAD','Ramo premium',1),
('Caja Floral',200,15,'UNIDAD','Caja floral',2),
('Bouquet Tulipanes',180,12,'UNIDAD','Bouquet elegante',1),
('Centro Mesa',250,8,'UNIDAD','Decoración floral',5),
('Arreglo Corazón',300,5,'UNIDAD','Arreglo romántico',2);

INSERT INTO PRODUCTS_SUPPLY(product_name,description,price,available_stock,expiry_date,unit_measurement,product_image,category_id) VALUES
('Espuma Floral','Espuma flores',15,50,'2026-12-31','UNIDAD',0x1234,3),
('Cinta Roja','Cinta decorativa',5,100,'2027-01-15','UNIDAD',0x1234,5),
('Maceta Blanca','Maceta cerámica',25,30,'2028-05-20','UNIDAD',0x1234,4),
('Papel Coreano','Papel decorativo',8,70,'2027-03-11','UNIDAD',0x1234,5),
('Fertilizante','Nutriente floral',18,40,'2026-08-01','UNIDAD',0x1234,3);

INSERT INTO SUPPLIER(company_name,ruc,phone,email,address,status,ubigeo_code,category_id) VALUES
('Flores SAC','20111111111','987000111','ventas@flores.com','Av Floral 111','ACTIVO',1,1),
('Deco Perú','20222222222','987000112','ventas@deco.com','Av Deco 222','ACTIVO',2,5),
('Insumos Flor','20333333333','987000113','ventas@insumos.com','Av Insumos 333','ACTIVO',3,3),
('Macetas Perú','20444444444','987000114','ventas@macetas.com','Av Macetas 444','ACTIVO',4,4),
('Tulipanes SAC','20555555555','987000115','ventas@tulipanes.com','Av Tulipanes 555','ACTIVO',5,2);

INSERT INTO PURCHASES(supplier_id,employee_id,date_purchases,total_amount,status) VALUES
(1,1,'2026-01-10',500,'COMPLETADO'),
(2,2,'2026-01-12',650,'COMPLETADO'),
(3,3,'2026-01-14',400,'PENDIENTE'),
(4,4,'2026-01-16',750,'COMPLETADO'),
(5,5,'2026-01-18',900,'COMPLETADO');

INSERT INTO PURCHASES_DETAILS(unit_price,amount_product,total_cost,product_id,id_purchase) VALUES
(15,10,150,1,1),
(5,20,100,2,2),
(25,8,200,3,3),
(8,15,120,4,4),
(18,12,216,5,5);

INSERT INTO SALE(sale_date,receipt_type,payment_method,status,total_cost,employee_id,id_customer) VALUES
('2026-02-01','BOLETA','YAPE','COMPLETADO',150,1,1),
('2026-02-02','FACTURA','EFECTIVO','COMPLETADO',200,2,2),
('2026-02-03','BOLETA','TARJETA','COMPLETADO',180,3,3),
('2026-02-04','FACTURA','PLIN','COMPLETADO',250,4,4),
('2026-02-05','BOLETA','YAPE','COMPLETADO',300,5,5);

INSERT INTO SALE_DETAILS(unit_price,product_amount,subtotal_cost,products_sale_id,sale_id) VALUES
(150,1,150,1,1),
(200,1,200,2,2),
(180,1,180,3,3),
(250,1,250,4,4),
(300,1,300,5,5);

INSERT INTO ORDERS(order_date,estimated_delivery,status,notes,total_estimated,employee_id,id_customer) VALUES
('2026-03-01','2026-03-03','PENDIENTE','Pedido urgente',150,1,1),
('2026-03-02','2026-03-04','EN PROCESO','Decoración especial',200,2,2),
('2026-03-03','2026-03-05','PENDIENTE','Pedido empresarial',180,3,3),
('2026-03-04','2026-03-06','COMPLETADO','Evento social',250,4,4),
('2026-03-05','2026-03-07','EN PROCESO','San Valentín',300,5,5);

INSERT INTO ORDER_DETAILS(quantity,unit_price,subtotal,order_id,products_sale_id) VALUES
(1,150,150,1,1),
(1,200,200,2,2),
(1,180,180,3,3),
(1,250,250,4,4),
(1,300,300,5,5);

INSERT INTO PRODUCTION_BATCH(id_order_detail,products_sale_id,employee_id,quantity_initial,start_date,estimated_ready_date,status,observations) VALUES
(1,1,1,10,'2026-03-01','2026-03-02','EN PROCESO','Producción normal'),
(2,2,2,8,'2026-03-02','2026-03-03','EN PROCESO','Pedido decorativo'),
(3,3,3,5,'2026-03-03','2026-03-04','PENDIENTE','Pendiente materiales'),
(4,4,4,7,'2026-03-04','2026-03-05','COMPLETADO','Terminado'),
(5,5,5,6,'2026-03-05','2026-03-06','EN PROCESO','Producción activa');

INSERT INTO PRODUCTION_STAGE(stage_name,quantity_in,quantity_lost,start_date,end_date,observations,employee_id,batch_id) VALUES
('Diseño',10,0,'2026-03-01','2026-03-01','Sin pérdidas',1,1),
('Corte',8,1,'2026-03-02','2026-03-02','Pérdida mínima',2,2),
('Armado',5,0,'2026-03-03','2026-03-03','Correcto',3,3),
('Decoración',7,1,'2026-03-04','2026-03-04','Detalle menor',4,4),
('Empaque',6,0,'2026-03-05','2026-03-05','Finalizado',5,5);

INSERT INTO STOCK_MOVEMENT(movement_type,movement_reason,quantity,stock_before,stock_after,comments,movement_date,employee_id,sale_id,batch_id,products_sale_id,product_id,id_purchase) VALUES
('SALIDA','Venta producto',1,20,19,'Venta realizada','2026-04-01',1,1,1,1,1,1),
('ENTRADA','Compra proveedor',20,50,70,'Ingreso stock','2026-04-02',2,2,2,2,2,2),
('SALIDA','Producción',5,30,25,'Uso interno','2026-04-03',3,3,3,3,3,3),
('ENTRADA','Reposición',10,25,35,'Reposición almacén','2026-04-04',4,4,4,4,4,4),
('SALIDA','Venta especial',2,15,13,'Pedido VIP','2026-04-05',5,5,5,5,5,5);