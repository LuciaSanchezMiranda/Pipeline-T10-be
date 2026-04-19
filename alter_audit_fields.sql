-- Alter tables to add audit fields

USE AgroPacayales;
GO

-- Add audit fields to customer table
ALTER TABLE customer ADD created_at DATETIME2;
ALTER TABLE customer ADD updated_at DATETIME2;
ALTER TABLE customer ADD deleted_at DATETIME2;
ALTER TABLE customer ADD restored_at DATETIME2;
GO

-- Add audit fields to PRODUCTO table
ALTER TABLE PRODUCTO ADD created_at DATETIME2;
ALTER TABLE PRODUCTO ADD updated_at DATETIME2;
ALTER TABLE PRODUCTO ADD deleted_at DATETIME2;
ALTER TABLE PRODUCTO ADD restored_at DATETIME2;
GO

-- Add missing fields to Supplier table
ALTER TABLE Supplier ADD credit_limit DECIMAL(10,2);
ALTER TABLE Supplier ADD created_date DATETIME2;
ALTER TABLE Supplier ADD updated_at DATETIME2;
ALTER TABLE Supplier ADD deleted_at DATETIME2;
ALTER TABLE Supplier ADD restored_at DATETIME2;
GO