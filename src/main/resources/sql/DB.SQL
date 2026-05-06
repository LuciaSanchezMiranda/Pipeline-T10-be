-- Create the database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'DF_BerryControl')
BEGIN
    CREATE DATABASE DF_BerryControl;
END
GO

-- Use the database
USE DF_BerryControl;
GO

-- Drop tables in reverse order of dependencies to avoid FK errors
IF OBJECT_ID('dbo.STOCK_MOVEMENT', 'U') IS NOT NULL DROP TABLE dbo.STOCK_MOVEMENT;
IF OBJECT_ID('dbo.SALE_DETAILS', 'U') IS NOT NULL DROP TABLE dbo.SALE_DETAILS;
IF OBJECT_ID('dbo.SALE', 'U') IS NOT NULL DROP TABLE dbo.SALE;
IF OBJECT_ID('dbo.PRODUCTION_STAGE', 'U') IS NOT NULL DROP TABLE dbo.PRODUCTION_STAGE;
IF OBJECT_ID('dbo.PRODUCTION_BATCH', 'U') IS NOT NULL DROP TABLE dbo.PRODUCTION_BATCH;
IF OBJECT_ID('dbo.ORDER_DETAILS', 'U') IS NOT NULL DROP TABLE dbo.ORDER_DETAILS;
IF OBJECT_ID('dbo.ORDERS', 'U') IS NOT NULL DROP TABLE dbo.ORDERS;
IF OBJECT_ID('dbo.PURCHASES_DETAILS', 'U') IS NOT NULL DROP TABLE dbo.PURCHASES_DETAILS;
IF OBJECT_ID('dbo.PURCHASES', 'U') IS NOT NULL DROP TABLE dbo.PURCHASES;
IF OBJECT_ID('dbo.PRODUCTS_SUPPLY', 'U') IS NOT NULL DROP TABLE dbo.PRODUCTS_SUPPLY;
IF OBJECT_ID('dbo.PRODUCTS_SALE', 'U') IS NOT NULL DROP TABLE dbo.PRODUCTS_SALE;
IF OBJECT_ID('dbo.EMPLOYEE', 'U') IS NOT NULL DROP TABLE dbo.EMPLOYEE;
IF OBJECT_ID('dbo.CUSTOMER', 'U') IS NOT NULL DROP TABLE dbo.CUSTOMER;
IF OBJECT_ID('dbo.SUPPLIER', 'U') IS NOT NULL DROP TABLE dbo.SUPPLIER;
IF OBJECT_ID('dbo.ROLES', 'U') IS NOT NULL DROP TABLE dbo.ROLES;
IF OBJECT_ID('dbo.UBIGEO', 'U') IS NOT NULL DROP TABLE dbo.UBIGEO;
IF OBJECT_ID('dbo.CATEGORY', 'U') IS NOT NULL DROP TABLE dbo.CATEGORY;
GO

-- Table: CATEGORY
CREATE TABLE CATEGORY (
    category_id int NOT NULL,
    category_name varchar(100) NOT NULL,
    category_type varchar(20) NOT NULL,
    status varchar(20) NOT NULL,
    CONSTRAINT CATEGORY_pk PRIMARY KEY (category_id)
);

-- Insert data into CATEGORY
INSERT INTO CATEGORY (category_id, category_name, category_type, status) VALUES (1,'Plantas','VENTA','ACTIVO');
INSERT INTO CATEGORY (category_id, category_name, category_type, status) VALUES (2,'Fertilizantes','SUMINISTRO','ACTIVO');
INSERT INTO CATEGORY (category_id, category_name, category_type, status) VALUES (3,'Herramientas','SUMINISTRO','ACTIVO');
INSERT INTO CATEGORY (category_id, category_name, category_type, status) VALUES (4,'Macetas','VENTA','ACTIVO');
INSERT INTO CATEGORY (category_id, category_name, category_type, status) VALUES (5,'Semillas','VENTA','ACTIVO');

-- Table: UBIGEO
CREATE TABLE UBIGEO (
    ubigeo_code int NOT NULL,
    department varchar(100) NOT NULL,
    province varchar(100) NOT NULL,
    district varchar(100) NOT NULL,
    CONSTRAINT UBIGEO_pk PRIMARY KEY (ubigeo_code)
);

-- Insert data into UBIGEO
INSERT INTO UBIGEO (ubigeo_code, department, province, district) VALUES (150101,'Lima','Lima','Cercado');
INSERT INTO UBIGEO (ubigeo_code, department, province, district) VALUES (150102,'Lima','Lima','Ate');
INSERT INTO UBIGEO (ubigeo_code, department, province, district) VALUES (150103,'Lima','Lima','Surco');
INSERT INTO UBIGEO (ubigeo_code, department, province, district) VALUES (150104,'Lima','Lima','Miraflores');
INSERT INTO UBIGEO (ubigeo_code, department, province, district) VALUES (150105,'Lima','Lima','San Isidro');

-- Table: ROLES
CREATE TABLE ROLES (
    role_id int NOT NULL,
    role_name varchar(20) NOT NULL,
    status varchar(20) NOT NULL,
    description varchar(200) NOT NULL,
    CONSTRAINT ROLES_pk PRIMARY KEY (role_id)
);

-- Insert data into ROLES
INSERT INTO ROLES (role_id, role_name, status, description) VALUES (1,'Admin','activo','Administrador del sistema');
INSERT INTO ROLES (role_id, role_name, status, description) VALUES (2,'Vendedor','activo','Vendedor del sistema');
INSERT INTO ROLES (role_id, role_name, status, description) VALUES (3,'Almacenero','activo','Almacenero del sistema');
INSERT INTO ROLES (role_id, role_name, status, description) VALUES (4,'Repartidor','activo','Repartidor del sistema');

-- Table: SUPPLIER
CREATE TABLE SUPPLIER (
    supplier_id int NOT NULL,
    company_name varchar(150) NOT NULL,
    ruc char(11) NOT NULL,
    phone char(9) NOT NULL,
    email varchar(100) NOT NULL,
    address geography NOT NULL,
    status varchar(20) NOT NULL,
    created_at datetime NOT NULL,
    updated_at datetime NOT NULL,
    deleted_at datetime NULL,
    restored_at datetime NULL,
    ubigeo_code int NOT NULL,
    CONSTRAINT SUPPLIER_pk PRIMARY KEY (supplier_id),
    CONSTRAINT SUPPLIER_UBIGEO FOREIGN KEY (ubigeo_code) REFERENCES UBIGEO (ubigeo_code)
);

-- Insert data into SUPPLIER
INSERT INTO SUPPLIER (supplier_id, company_name, ruc, phone, email, address, status, created_at, updated_at, deleted_at, restored_at, ubigeo_code)
VALUES (1,'AgroPeru SAC','20123456789','987654321','proveedor1@gmail.com',geography::STGeomFromText('POINT(-77.01 -12.04)',4326),'ACTIVO',GETDATE(),GETDATE(),NULL,NULL,150101);
INSERT INTO SUPPLIER (supplier_id, company_name, ruc, phone, email, address, status, created_at, updated_at, deleted_at, restored_at, ubigeo_code)
VALUES (2,'FertiPlus','20123456780','987654322','proveedor2@gmail.com',geography::STGeomFromText('POINT(-77.02 -12.05)',4326),'ACTIVO',GETDATE(),GETDATE(),NULL,NULL,150102);
INSERT INTO SUPPLIER (supplier_id, company_name, ruc, phone, email, address, status, created_at, updated_at, deleted_at, restored_at, ubigeo_code)
VALUES (3,'ToolsAgro','20123456781','987654323','proveedor3@gmail.com',geography::STGeomFromText('POINT(-77.03 -12.06)',4326),'ACTIVO',GETDATE(),GETDATE(),NULL,NULL,150103);
INSERT INTO SUPPLIER (supplier_id, company_name, ruc, phone, email, address, status, created_at, updated_at, deleted_at, restored_at, ubigeo_code)
VALUES (4,'GreenWorld','20123456782','987654324','proveedor4@gmail.com',geography::STGeomFromText('POINT(-77.04 -12.07)',4326),'ACTIVO',GETDATE(),GETDATE(),NULL,NULL,150104);
INSERT INTO SUPPLIER (supplier_id, company_name, ruc, phone, email, address, status, created_at, updated_at, deleted_at, restored_at, ubigeo_code)
VALUES (5,'AgroTech','20123456783','987654325','proveedor5@gmail.com',geography::STGeomFromText('POINT(-77.05 -12.08)',4326),'ACTIVO',GETDATE(),GETDATE(),NULL,NULL,150105);

-- Table: CUSTOMER
CREATE TABLE CUSTOMER (
    id_customer int NOT NULL,
    customer_type varchar(20) NOT NULL,
    customer_number varchar(15) NOT NULL,
    customer_name varchar(50) NOT NULL,
    customer_lastname varchar(60) NOT NULL,
    phone char(9) NOT NULL,
    email varchar(150) NOT NULL,
    address geography NOT NULL,
    status varchar(10) NOT NULL,
    created_at datetime NOT NULL,
    updated_at datetime NOT NULL,
    deleted_at datetime NULL,
    restored_at datetime NULL,
    ubigeo_code int NOT NULL,
    CONSTRAINT CUSTOMER_pk PRIMARY KEY (id_customer),
    CONSTRAINT CUSTOMER_UBIGEO FOREIGN KEY (ubigeo_code) REFERENCES UBIGEO (ubigeo_code)
);

-- Insert data into CUSTOMER
INSERT INTO CUSTOMER (id_customer, customer_type, customer_number, customer_name, customer_lastname, phone, email, address, status, created_at, updated_at, deleted_at, restored_at, ubigeo_code)
VALUES (1,'DNI','12345678','Luis','Perez','999111111','luis@gmail.com',geography::STGeomFromText('POINT(-77.01 -12.04)',4326),'ACTIVO',GETDATE(),GETDATE(),NULL,NULL,150101);
INSERT INTO CUSTOMER (id_customer, customer_type, customer_number, customer_name, customer_lastname, phone, email, address, status, created_at, updated_at, deleted_at, restored_at, ubigeo_code)
VALUES (2,'DNI','87654321','Ana','Torres','999222222','ana@gmail.com',geography::STGeomFromText('POINT(-77.02 -12.05)',4326),'ACTIVO',GETDATE(),GETDATE(),NULL,NULL,150102);
INSERT INTO CUSTOMER (id_customer, customer_type, customer_number, customer_name, customer_lastname, phone, email, address, status, created_at, updated_at, deleted_at, restored_at, ubigeo_code)
VALUES (3,'RUC','20111111111','Empresa','SAC','999333333','empresa@gmail.com',geography::STGeomFromText('POINT(-77.03 -12.06)',4326),'ACTIVO',GETDATE(),GETDATE(),NULL,NULL,150103);
INSERT INTO CUSTOMER (id_customer, customer_type, customer_number, customer_name, customer_lastname, phone, email, address, status, created_at, updated_at, deleted_at, restored_at, ubigeo_code)
VALUES (4,'DNI','45678912','Carlos','Lopez','999444444','carlos@gmail.com',geography::STGeomFromText('POINT(-77.04 -12.07)',4326),'ACTIVO',GETDATE(),GETDATE(),NULL,NULL,150104);
INSERT INTO CUSTOMER (id_customer, customer_type, customer_number, customer_name, customer_lastname, phone, email, address, status, created_at, updated_at, deleted_at, restored_at, ubigeo_code)
VALUES (5,'DNI','78912345','Maria','Gomez','999555555','maria@gmail.com',geography::STGeomFromText('POINT(-77.05 -12.08)',4326),'ACTIVO',GETDATE(),GETDATE(),NULL,NULL,150105);

-- Table: EMPLOYEE
CREATE TABLE EMPLOYEE (
    employee_id int NOT NULL,
    ubigeo_code int NOT NULL,
    role_id int NOT NULL,
    document_type varchar(12) NOT NULL,
    documento_number varchar(50) NOT NULL,
    name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    phone char(9) NOT NULL,
    email varchar(150) NOT NULL,
    address geography NOT NULL,
    entry_date date NOT NULL,
    status varchar(10) NOT NULL,
    password varchar(255) NOT NULL,
    created_at datetime NOT NULL,
    updated_at datetime NOT NULL,
    deleted_at datetime NULL,
    restored_at datetime NULL,
    CONSTRAINT EMPLOYEE_pk PRIMARY KEY (employee_id),
    CONSTRAINT EMPLOYEE_UBIGEO FOREIGN KEY (ubigeo_code) REFERENCES UBIGEO (ubigeo_code),
    CONSTRAINT EMPLOYEE_ROLES FOREIGN KEY (role_id) REFERENCES ROLES (role_id)
);

-- Insert data into EMPLOYEE
INSERT INTO EMPLOYEE (employee_id, ubigeo_code, role_id, document_type, documento_number, name, last_name, phone, email, address, entry_date, status, password, created_at, updated_at, deleted_at, restored_at)
VALUES (1,150101,1,'DNI','12345678','Luis','Perez','999111111','luis@empresa.com',geography::STGeomFromText('POINT(-77.01 -12.04)',4326),'2022-01-01','ACTIVO','admin','2022-01-01','2022-01-01',NULL,NULL);
INSERT INTO EMPLOYEE (employee_id, ubigeo_code, role_id, document_type, documento_number, name, last_name, phone, email, address, entry_date, status, password, created_at, updated_at, deleted_at, restored_at)
VALUES (2,150102,2,'DNI','87654321','Ana','Torres','999222222','ana@empresa.com',geography::STGeomFromText('POINT(-77.02 -12.05)',4326),'2022-01-02','ACTIVO','vendedor','2022-01-02','2022-01-02',NULL,NULL);
INSERT INTO EMPLOYEE (employee_id, ubigeo_code, role_id, document_type, documento_number, name, last_name, phone, email, address, entry_date, status, password, created_at, updated_at, deleted_at, restored_at)
VALUES (3,150103,3,'RUC','20111111111','Empresa','SAC','999333333','empresa@empresa.com',geography::STGeomFromText('POINT(-77.03 -12.06)',4326),'2022-01-03','ACTIVO','almacenero','2022-01-03','2022-01-03',NULL,NULL);
INSERT INTO EMPLOYEE (employee_id, ubigeo_code, role_id, document_type, documento_number, name, last_name, phone, email, address, entry_date, status, password, created_at, updated_at, deleted_at, restored_at)
VALUES (4,150104,4,'DNI','45678912','Carlos','Lopez','999444444','carlos@empresa.com',geography::STGeomFromText('POINT(-77.04 -12.07)',4326),'2022-01-04','ACTIVO','repartidor','2022-01-04','2022-01-04',NULL,NULL);
INSERT INTO EMPLOYEE (employee_id, ubigeo_code, role_id, document_type, documento_number, name, last_name, phone, email, address, entry_date, status, password, created_at, updated_at, deleted_at, restored_at)
VALUES (5,150105,1,'DNI','78912345','Maria','Gomez','999555555','maria@empresa.com',geography::STGeomFromText('POINT(-77.05 -12.08)',4326),'2022-01-05','ACTIVO','admin','2022-01-05','2022-01-05',NULL,NULL);

-- Table: PRODUCTS_SALE
CREATE TABLE PRODUCTS_SALE (
    products_sale_id int NOT NULL,
    product_name varchar(100) NOT NULL,
    price decimal(10,2) NOT NULL,
    available_stock int NOT NULL,
    unit_meansurement varchar(30) NOT NULL,
    description text NOT NULL,
    created_at datetime NOT NULL,
    updated_at datetime NOT NULL,
    deleted_at datetime NULL,
    restored_at datetime NULL,
    category_id int NOT NULL,
    CONSTRAINT PRODUCTS_SALE_pk PRIMARY KEY (products_sale_id),
    CONSTRAINT PRODUCTS_SALE_CATEGORY FOREIGN KEY (category_id) REFERENCES CATEGORY (category_id)
);

-- Insert data into PRODUCTS_SALE
INSERT INTO PRODUCTS_SALE (products_sale_id, product_name, price, available_stock, unit_meansurement, description, created_at, updated_at, deleted_at, restored_at, category_id)
VALUES (1,'Rosa',10.00,100,'unidad','Rosa roja',GETDATE(),GETDATE(),NULL,NULL,1);
INSERT INTO PRODUCTS_SALE (products_sale_id, product_name, price, available_stock, unit_meansurement, description, created_at, updated_at, deleted_at, restored_at, category_id)
VALUES (2,'Clavel',15.00,150,'unidad','Clavel rojo',GETDATE(),GETDATE(),NULL,NULL,2);
INSERT INTO PRODUCTS_SALE (products_sale_id, product_name, price, available_stock, unit_meansurement, description, created_at, updated_at, deleted_at, restored_at, category_id)
VALUES (3,'Tulipan',20.00,200,'unidad','Tulipan rojo',GETDATE(),GETDATE(),NULL,NULL,3);
INSERT INTO PRODUCTS_SALE (products_sale_id, product_name, price, available_stock, unit_meansurement, description, created_at, updated_at, deleted_at, restored_at, category_id)
VALUES (4,'Lirio',25.00,250,'unidad','Lirio rojo',GETDATE(),GETDATE(),NULL,NULL,4);
INSERT INTO PRODUCTS_SALE (products_sale_id, product_name, price, available_stock, unit_meansurement, description, created_at, updated_at, deleted_at, restored_at, category_id)
VALUES (5,'Orquidea',30.00,300,'unidad','Orquidea roja',GETDATE(),GETDATE(),NULL,NULL,5);

-- Table: PRODUCTS_SUPPLY
CREATE TABLE PRODUCTS_SUPPLY (
    pruduct_id int NOT NULL,
    product_name varchar(100) NOT NULL,
    description text NOT NULL,
    price decimal(10,2) NOT NULL,
    available_stock decimal(10,2) NOT NULL,
    epiry_date datetime NOT NULL,
    unit_measurement varchar(30) NOT NULL,
    product_image varbinary(300) NOT NULL,
    created_at datetime NOT NULL,
    updated_at datetime NOT NULL,
    deleted_at datetime NULL,
    restored_at datetime NULL,
    category_id int NOT NULL,
    CONSTRAINT PRODUCTS_SUPPLY_pk PRIMARY KEY (pruduct_id),
    CONSTRAINT PRODUCTS_SUPPLY_CATEGORY FOREIGN KEY (category_id) REFERENCES CATEGORY (category_id)
);

-- Insert data into PRODUCTS_SUPPLY (CORREGIDO: CAST para varbinary)
INSERT INTO PRODUCTS_SUPPLY (pruduct_id, product_name, description, price, available_stock, epiry_date, unit_measurement, product_image, created_at, updated_at, deleted_at, restored_at, category_id)
VALUES (1,'Rosa','Rosa roja',10.00,100,'2022-12-31','unidad',CAST('rosa.jpg' AS varbinary(300)),GETDATE(),GETDATE(),NULL,NULL,1);
INSERT INTO PRODUCTS_SUPPLY (pruduct_id, product_name, description, price, available_stock, epiry_date, unit_measurement, product_image, created_at, updated_at, deleted_at, restored_at, category_id)
VALUES (2,'Clavel','Clavel rojo',15.00,150,'2022-12-31','unidad',CAST('clavel.jpg' AS varbinary(300)),GETDATE(),GETDATE(),NULL,NULL,2);
INSERT INTO PRODUCTS_SUPPLY (pruduct_id, product_name, description, price, available_stock, epiry_date, unit_measurement, product_image, created_at, updated_at, deleted_at, restored_at, category_id)
VALUES (3,'Tulipan','Tulipan rojo',20.00,200,'2022-12-31','unidad',CAST('tulipan.jpg' AS varbinary(300)),GETDATE(),GETDATE(),NULL,NULL,3);
INSERT INTO PRODUCTS_SUPPLY (pruduct_id, product_name, description, price, available_stock, epiry_date, unit_measurement, product_image, created_at, updated_at, deleted_at, restored_at, category_id)
VALUES (4,'Lirio','Lirio rojo',25.00,250,'2022-12-31','unidad',CAST('lirio.jpg' AS varbinary(300)),GETDATE(),GETDATE(),NULL,NULL,4);
INSERT INTO PRODUCTS_SUPPLY (pruduct_id, product_name, description, price, available_stock, epiry_date, unit_measurement, product_image, created_at, updated_at, deleted_at, restored_at, category_id)
VALUES (5,'Orquidea','Orquidea roja',30.00,300,'2022-12-31','unidad',CAST('orquidea.jpg' AS varbinary(300)),GETDATE(),GETDATE(),NULL,NULL,5);

-- Table: PURCHASES
CREATE TABLE PURCHASES (
    id_purchase int NOT NULL,
    supplier_id int NOT NULL,
    employee_id int NOT NULL,
    date_puchases datetime NOT NULL,
    total_amaunt decimal(10,2) NOT NULL,
    status varchar(20) NOT NULL,
    CONSTRAINT PURCHASES_pk PRIMARY KEY (id_purchase),
    CONSTRAINT PURCHASES_SUPPLIER FOREIGN KEY (supplier_id) REFERENCES SUPPLIER (supplier_id),
    CONSTRAINT PURCHASES_EMPLOYEE FOREIGN KEY (employee_id) REFERENCES EMPLOYEE (employee_id)
);

-- Insert data into PURCHASES
INSERT INTO PURCHASES (id_purchase, supplier_id, employee_id, date_puchases, total_amaunt, status)
VALUES (1,1,1,'2022-01-01',100.00,'ACTIVO');
INSERT INTO PURCHASES (id_purchase, supplier_id, employee_id, date_puchases, total_amaunt, status)
VALUES (2,2,2,'2022-01-02',150.00,'ACTIVO');
INSERT INTO PURCHASES (id_purchase, supplier_id, employee_id, date_puchases, total_amaunt, status)
VALUES (3,3,3,'2022-01-03',200.00,'ACTIVO');
INSERT INTO PURCHASES (id_purchase, supplier_id, employee_id, date_puchases, total_amaunt, status)
VALUES (4,4,4,'2022-01-04',250.00,'ACTIVO');
INSERT INTO PURCHASES (id_purchase, supplier_id, employee_id, date_puchases, total_amaunt, status)
VALUES (5,5,5,'2022-01-05',300.00,'ACTIVO');

-- Table: PURCHASES_DETAILS
CREATE TABLE PURCHASES_DETAILS (
    id_purchases_detail int NOT NULL,
    unit_price decimal(10,2) NOT NULL,
    amount_product int NOT NULL,
    total_cost decimal(10,2) NOT NULL,
    pruduct_id int NOT NULL,
    id_purchase int NOT NULL,
    CONSTRAINT PURCHASES_DETAILS_pk PRIMARY KEY (id_purchases_detail),
    CONSTRAINT PURCHASES_DETAILS_PRODUCTS_SUPPLY FOREIGN KEY (pruduct_id) REFERENCES PRODUCTS_SUPPLY (pruduct_id),
    CONSTRAINT PURCHASES_DETAILS_PURCHASES FOREIGN KEY (id_purchase) REFERENCES PURCHASES (id_purchase)
);

-- Insert data into PURCHASES_DETAILS
INSERT INTO PURCHASES_DETAILS (id_purchases_detail, unit_price, amount_product, total_cost, pruduct_id, id_purchase)
VALUES (1,10.00,100,1000.00,1,1);
INSERT INTO PURCHASES_DETAILS (id_purchases_detail, unit_price, amount_product, total_cost, pruduct_id, id_purchase)
VALUES (2,15.00,150,2250.00,2,2);
INSERT INTO PURCHASES_DETAILS (id_purchases_detail, unit_price, amount_product, total_cost, pruduct_id, id_purchase)
VALUES (3,20.00,200,4000.00,3,3);
INSERT INTO PURCHASES_DETAILS (id_purchases_detail, unit_price, amount_product, total_cost, pruduct_id, id_purchase)
VALUES (4,25.00,250,6250.00,4,4);
INSERT INTO PURCHASES_DETAILS (id_purchases_detail, unit_price, amount_product, total_cost, pruduct_id, id_purchase)
VALUES (5,30.00,300,9000.00,5,5);

-- Table: ORDERS
CREATE TABLE ORDERS (
    order_id int NOT NULL,
    order_date datetime NOT NULL,
    estimated_delivery date NOT NULL,
    status varchar(20) NOT NULL,
    notes text NOT NULL,
    total_estimated decimal(10,2) NOT NULL,
    created_at datetime NOT NULL,
    updated_at datetime NOT NULL,
    deleted_at datetime NULL,
    restored_at datetime NULL,
    employee_id int NOT NULL,
    id_customer int NOT NULL,
    CONSTRAINT ORDERS_pk PRIMARY KEY (order_id),
    CONSTRAINT ORDERS_EMPLOYEE FOREIGN KEY (employee_id) REFERENCES EMPLOYEE (employee_id),
    CONSTRAINT ORDERS_CUSTOMER FOREIGN KEY (id_customer) REFERENCES CUSTOMER (id_customer)
);

-- Insert data into ORDERS
INSERT INTO ORDERS (order_id, order_date, estimated_delivery, status, notes, total_estimated, created_at, updated_at, deleted_at, restored_at, employee_id, id_customer)
VALUES (1,'2022-01-01','2022-01-05','ACTIVO','',100.00,GETDATE(),GETDATE(),NULL,NULL,1,1);
INSERT INTO ORDERS (order_id, order_date, estimated_delivery, status, notes, total_estimated, created_at, updated_at, deleted_at, restored_at, employee_id, id_customer)
VALUES (2,'2022-01-02','2022-01-06','ACTIVO','',150.00,GETDATE(),GETDATE(),NULL,NULL,2,2);
INSERT INTO ORDERS (order_id, order_date, estimated_delivery, status, notes, total_estimated, created_at, updated_at, deleted_at, restored_at, employee_id, id_customer)
VALUES (3,'2022-01-03','2022-01-07','ACTIVO','',200.00,GETDATE(),GETDATE(),NULL,NULL,3,3);
INSERT INTO ORDERS (order_id, order_date, estimated_delivery, status, notes, total_estimated, created_at, updated_at, deleted_at, restored_at, employee_id, id_customer)
VALUES (4,'2022-01-04','2022-01-08','ACTIVO','',250.00,GETDATE(),GETDATE(),NULL,NULL,4,4);
INSERT INTO ORDERS (order_id, order_date, estimated_delivery, status, notes, total_estimated, created_at, updated_at, deleted_at, restored_at, employee_id, id_customer)
VALUES (5,'2022-01-05','2022-01-09','ACTIVO','',300.00,GETDATE(),GETDATE(),NULL,NULL,5,5);

-- Table: ORDER_DETAILS
CREATE TABLE ORDER_DETAILS (
    Id_order_detail int NOT NULL,
    quantity int NOT NULL,
    unit_price decimal(10,2) NOT NULL,
    subtotal decimal(10,2) NOT NULL,
    order_id int NOT NULL,
    products_sale_id int NOT NULL,
    CONSTRAINT ORDER_DETAILS_pk PRIMARY KEY (Id_order_detail),
    CONSTRAINT ORDER_DETAILS_ORDERS FOREIGN KEY (order_id) REFERENCES ORDERS (order_id),
    CONSTRAINT ORDER_DETAILS_PRODUCTS_SALE FOREIGN KEY (products_sale_id) REFERENCES PRODUCTS_SALE (products_sale_id)
);

-- Insert data into ORDER_DETAILS
INSERT INTO ORDER_DETAILS (Id_order_detail, quantity, unit_price, subtotal, order_id, products_sale_id)
VALUES (1,100,10.00,1000.00,1,1);
INSERT INTO ORDER_DETAILS (Id_order_detail, quantity, unit_price, subtotal, order_id, products_sale_id)
VALUES (2,150,15.00,2250.00,2,2);
INSERT INTO ORDER_DETAILS (Id_order_detail, quantity, unit_price, subtotal, order_id, products_sale_id)
VALUES (3,200,20.00,4000.00,3,3);
INSERT INTO ORDER_DETAILS (Id_order_detail, quantity, unit_price, subtotal, order_id, products_sale_id)
VALUES (4,250,25.00,6250.00,4,4);
INSERT INTO ORDER_DETAILS (Id_order_detail, quantity, unit_price, subtotal, order_id, products_sale_id)
VALUES (5,300,30.00,9000.00,5,5);

-- Table: PRODUCTION_BATCH
CREATE TABLE PRODUCTION_BATCH (
    batch_id int NOT NULL,
    Id_order_detail int NOT NULL,
    products_sale_id int NOT NULL,
    employee_id int NOT NULL,
    quantity_initial int NOT NULL,
    start_date date NOT NULL,
    estimated_ready_date date NOT NULL,
    status varchar(20) NOT NULL,
    observations varchar(500) NOT NULL,
    created_at datetime NOT NULL,
    updated_at datetime NOT NULL,
    CONSTRAINT PRODUCTION_BATCH_pk PRIMARY KEY (batch_id),
    CONSTRAINT PRODUCTION_BATCH_ORDER_DETAILS FOREIGN KEY (Id_order_detail) REFERENCES ORDER_DETAILS (Id_order_detail),
    CONSTRAINT PRODUCTION_BATCH_PRODUCTS_SALE FOREIGN KEY (products_sale_id) REFERENCES PRODUCTS_SALE (products_sale_id),
    CONSTRAINT PRODUCTION_BATCH_EMPLOYEE FOREIGN KEY (employee_id) REFERENCES EMPLOYEE (employee_id)
);

-- Insert data into PRODUCTION_BATCH
INSERT INTO PRODUCTION_BATCH (batch_id, Id_order_detail, products_sale_id, employee_id, quantity_initial, start_date, estimated_ready_date, status, observations, created_at, updated_at)
VALUES (1,1,1,1,100,'2022-01-01','2022-01-01','ACTIVO','',GETDATE(),GETDATE());
INSERT INTO PRODUCTION_BATCH (batch_id, Id_order_detail, products_sale_id, employee_id, quantity_initial, start_date, estimated_ready_date, status, observations, created_at, updated_at)
VALUES (2,2,2,2,150,'2022-01-02','2022-01-02','ACTIVO','',GETDATE(),GETDATE());
INSERT INTO PRODUCTION_BATCH (batch_id, Id_order_detail, products_sale_id, employee_id, quantity_initial, start_date, estimated_ready_date, status, observations, created_at, updated_at)
VALUES (3,3,3,3,200,'2022-01-03','2022-01-03','ACTIVO','',GETDATE(),GETDATE());
INSERT INTO PRODUCTION_BATCH (batch_id, Id_order_detail, products_sale_id, employee_id, quantity_initial, start_date, estimated_ready_date, status, observations, created_at, updated_at)
VALUES (4,4,4,4,250,'2022-01-04','2022-01-04','ACTIVO','',GETDATE(),GETDATE());
INSERT INTO PRODUCTION_BATCH (batch_id, Id_order_detail, products_sale_id, employee_id, quantity_initial, start_date, estimated_ready_date, status, observations, created_at, updated_at)
VALUES (5,5,5,5,300,'2022-01-05','2022-01-05','ACTIVO','',GETDATE(),GETDATE());

-- Table: PRODUCTION_STAGE
CREATE TABLE PRODUCTION_STAGE (
    stage_id int NOT NULL,
    stage_name varchar(30) NOT NULL,
    quantity_in int NOT NULL,
    quantity_lost int NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    observations varchar(500) NOT NULL,
    employee_id int NOT NULL,
    batch_id int NOT NULL,
    CONSTRAINT PRODUCTION_STAGE_pk PRIMARY KEY (stage_id),
    CONSTRAINT PRODUCTION_STAGE_EMPLOYEE FOREIGN KEY (employee_id) REFERENCES EMPLOYEE (employee_id),
    CONSTRAINT PRODUCTION_STAGE_PRODUCTION_BATCH FOREIGN KEY (batch_id) REFERENCES PRODUCTION_BATCH (batch_id)
);

-- Insert data into PRODUCTION_STAGE
INSERT INTO PRODUCTION_STAGE (stage_id, stage_name, quantity_in, quantity_lost, start_date, end_date, observations, employee_id, batch_id)
VALUES (1,'Floristeria',100,10,'2022-01-01','2022-01-01','',1,1);
INSERT INTO PRODUCTION_STAGE (stage_id, stage_name, quantity_in, quantity_lost, start_date, end_date, observations, employee_id, batch_id)
VALUES (2,'Embalaje',150,15,'2022-01-02','2022-01-02','',2,2);
INSERT INTO PRODUCTION_STAGE (stage_id, stage_name, quantity_in, quantity_lost, start_date, end_date, observations, employee_id, batch_id)
VALUES (3,'Despacho',200,20,'2022-01-03','2022-01-03','',3,3);
INSERT INTO PRODUCTION_STAGE (stage_id, stage_name, quantity_in, quantity_lost, start_date, end_date, observations, employee_id, batch_id)
VALUES (4,'Entrega',250,25,'2022-01-04','2022-01-04','',4,4);
INSERT INTO PRODUCTION_STAGE (stage_id, stage_name, quantity_in, quantity_lost, start_date, end_date, observations, employee_id, batch_id)
VALUES (5,'Finalizado',300,30,'2022-01-05','2022-01-05','',5,5);

-- Table: SALE
CREATE TABLE SALE (
    sale_id int NOT NULL,
    sale_date datetime NOT NULL,
    receipt_type varchar(20) NOT NULL,
    payment_method varchar(20) NOT NULL,
    status varchar(20) NOT NULL,
    total_cost decimal(10,2) NOT NULL,
    employee_id int NOT NULL,
    id_customer int NOT NULL,
    CONSTRAINT SALE_pk PRIMARY KEY (sale_id),
    CONSTRAINT SALE_EMPLOYEE FOREIGN KEY (employee_id) REFERENCES EMPLOYEE (employee_id),
    CONSTRAINT SALE_CUSTOMER FOREIGN KEY (id_customer) REFERENCES CUSTOMER (id_customer)
);

-- Insert data into SALE
INSERT INTO SALE (sale_id, sale_date, receipt_type, payment_method, status, total_cost, employee_id, id_customer)
VALUES (1,'2022-01-01','FACTURA','EFECTIVO','ACTIVO',100.00,1,1);
INSERT INTO SALE (sale_id, sale_date, receipt_type, payment_method, status, total_cost, employee_id, id_customer)
VALUES (2,'2022-01-02','BOLETA','TARJETA','ACTIVO',150.00,2,2);
INSERT INTO SALE (sale_id, sale_date, receipt_type, payment_method, status, total_cost, employee_id, id_customer)
VALUES (3,'2022-01-03','FACTURA','EFECTIVO','ACTIVO',200.00,3,3);
INSERT INTO SALE (sale_id, sale_date, receipt_type, payment_method, status, total_cost, employee_id, id_customer)
VALUES (4,'2022-01-04','BOLETA','TARJETA','ACTIVO',250.00,4,4);
INSERT INTO SALE (sale_id, sale_date, receipt_type, payment_method, status, total_cost, employee_id, id_customer)
VALUES (5,'2022-01-05','FACTURA','EFECTIVO','ACTIVO',300.00,5,5);

-- Table: SALE_DETAILS
CREATE TABLE SALE_DETAILS (
    id_sale_detail int NOT NULL,
    unit_price decimal(10,2) NOT NULL,
    product_amount int NOT NULL,
    subtotal_cost decimal(10,2) NOT NULL,
    products_sale_id int NOT NULL,
    sale_id int NOT NULL,
    CONSTRAINT SALE_DETAILS_pk PRIMARY KEY (id_sale_detail),
    CONSTRAINT SALE_DETAILS_PRODUCTS_SALE FOREIGN KEY (products_sale_id) REFERENCES PRODUCTS_SALE (products_sale_id),
    CONSTRAINT SALE_DETAILS_SALE FOREIGN KEY (sale_id) REFERENCES SALE (sale_id)
);

-- Insert data into SALE_DETAILS
INSERT INTO SALE_DETAILS (id_sale_detail, unit_price, product_amount, subtotal_cost, products_sale_id, sale_id)
VALUES (1,10.00,100,1000.00,1,1);
INSERT INTO SALE_DETAILS (id_sale_detail, unit_price, product_amount, subtotal_cost, products_sale_id, sale_id)
VALUES (2,15.00,150,2250.00,2,2);
INSERT INTO SALE_DETAILS (id_sale_detail, unit_price, product_amount, subtotal_cost, products_sale_id, sale_id)
VALUES (3,20.00,200,4000.00,3,3);
INSERT INTO SALE_DETAILS (id_sale_detail, unit_price, product_amount, subtotal_cost, products_sale_id, sale_id)
VALUES (4,25.00,250,6250.00,4,4);
INSERT INTO SALE_DETAILS (id_sale_detail, unit_price, product_amount, subtotal_cost, products_sale_id, sale_id)
VALUES (5,30.00,300,9000.00,5,5);

-- Table: STOCK_MOVEMENT
CREATE TABLE STOCK_MOVEMENT (
    movement int NOT NULL,
    movement_type varchar(20) NOT NULL,
    movement_reason varchar(100) NOT NULL,
    quantity decimal(10,2) NOT NULL,
    stock_before decimal(10,2) NOT NULL,
    stock_after decimal(10,2) NOT NULL,
    comments varchar(500) NOT NULL,
    movement_date datetime NOT NULL,
    created_at datetime NOT NULL,
    employee_id int NOT NULL,
    sale_id int NOT NULL,
    batch_id int NOT NULL,
    products_sale_id int NOT NULL,
    pruduct_id int NOT NULL,
    id_purchase int NOT NULL,
    CONSTRAINT STOCK_MOVEMENT_pk PRIMARY KEY (movement),
    CONSTRAINT STOCK_MOVEMENT_EMPLOYEE FOREIGN KEY (employee_id) REFERENCES EMPLOYEE (employee_id),
    CONSTRAINT STOCK_MOVEMENT_PRODUCTION_BATCH FOREIGN KEY (batch_id) REFERENCES PRODUCTION_BATCH (batch_id),
    CONSTRAINT STOCK_MOVEMENT_PRODUCTS_SALE FOREIGN KEY (products_sale_id) REFERENCES PRODUCTS_SALE (products_sale_id),
    CONSTRAINT STOCK_MOVEMENT_PRODUCTS_SUPPLY FOREIGN KEY (pruduct_id) REFERENCES PRODUCTS_SUPPLY (pruduct_id),
    CONSTRAINT STOCK_MOVEMENT_PURCHASES FOREIGN KEY (id_purchase) REFERENCES PURCHASES (id_purchase),
    CONSTRAINT STOCK_MOVEMENT_SALE FOREIGN KEY (sale_id) REFERENCES SALE (sale_id)
);

-- Insert data into STOCK_MOVEMENT
INSERT INTO STOCK_MOVEMENT (movement, movement_type, movement_reason, quantity, stock_before, stock_after, comments, movement_date, created_at, employee_id, sale_id, batch_id, products_sale_id, pruduct_id, id_purchase)
VALUES (1,'ENTRADA','COMPRA',100,100,200,'',GETDATE(),GETDATE(),1,1,1,1,1,1);
INSERT INTO STOCK_MOVEMENT (movement, movement_type, movement_reason, quantity, stock_before, stock_after, comments, movement_date, created_at, employee_id, sale_id, batch_id, products_sale_id, pruduct_id, id_purchase)
VALUES (2,'SALIDA','VENTA',150,150,300,'',GETDATE(),GETDATE(),2,2,2,2,2,2);
INSERT INTO STOCK_MOVEMENT (movement, movement_type, movement_reason, quantity, stock_before, stock_after, comments, movement_date, created_at, employee_id, sale_id, batch_id, products_sale_id, pruduct_id, id_purchase)
VALUES (3,'ENTRADA','COMPRA',200,200,400,'',GETDATE(),GETDATE(),3,3,3,3,3,3);
INSERT INTO STOCK_MOVEMENT (movement, movement_type, movement_reason, quantity, stock_before, stock_after, comments, movement_date, created_at, employee_id, sale_id, batch_id, products_sale_id, pruduct_id, id_purchase)
VALUES (4,'SALIDA','VENTA',250,250,500,'',GETDATE(),GETDATE(),4,4,4,4,4,4);
INSERT INTO STOCK_MOVEMENT (movement, movement_type, movement_reason, quantity, stock_before, stock_after, comments, movement_date, created_at, employee_id, sale_id, batch_id, products_sale_id, pruduct_id, id_purchase)
VALUES (5,'ENTRADA','COMPRA',300,300,600,'',GETDATE(),GETDATE(),5,5,5,5,5,5);


-- JOINS
-- 1. INNER JOIN (Ventas + Clientes + Empleados)
SELECT 
    s.sale_id,
    s.sale_date,
    c.customer_name,
    e.name AS employee_name,
    s.total_cost
FROM SALE s
INNER JOIN CUSTOMER c ON s.id_customer = c.id_customer
INNER JOIN EMPLOYEE e ON s.employee_id = e.employee_id;

-- 2. LEFT JOIN (Productos + Categorías)
SELECT 
    p.product_name,
    p.price,
    c.category_name
FROM PRODUCTS_SALE p
LEFT JOIN CATEGORY c ON p.category_id = c.category_id;

-- 3. RIGHT JOIN (Empleados + Roles)
SELECT 
    e.name,
    r.role_name
FROM EMPLOYEE e
RIGHT JOIN ROLES r ON e.role_id = r.role_id;

-- 4. FULL OUTER JOIN (Productos + Categorías + Empleados)
SELECT 
    p.product_name,
    c.category_name,
    e.name AS employee_name
FROM PRODUCTS_SALE p
FULL OUTER JOIN CATEGORY c ON p.category_id = c.category_id
FULL OUTER JOIN EMPLOYEE e ON p.products_sale_id = e.employee_id;

-- 5. JOIN múltiple (Detalle de ventas completo)
SELECT 
    sd.id_sale_detail,
    ps.product_name,
    sd.product_amount,
    sd.subtotal_cost,
    s.sale_date,
    c.customer_name
FROM SALE_DETAILS sd
INNER JOIN PRODUCTS_SALE ps ON sd.products_sale_id = ps.products_sale_id
INNER JOIN SALE s ON sd.sale_id = s.sale_id
INNER JOIN CUSTOMER c ON s.id_customer = c.id_customer;

-- 6. JOIN complejo (Producción)
SELECT 
    pb.batch_id,
    ps.product_name,
    e.name AS employee,
    pb.start_date,
    pb.status
FROM PRODUCTION_BATCH pb
INNER JOIN PRODUCTS_SALE ps ON pb.products_sale_id = ps.products_sale_id
INNER JOIN EMPLOYEE e ON pb.employee_id = e.employee_id;