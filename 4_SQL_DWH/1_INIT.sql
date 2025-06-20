/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'My_Hospital' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	
WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
Note: 
	Each layer can be  a seperate database and have default shcema dbo . 
		In each data base we can create other schema for storing metadata
		eg : there can be support schema -> track logs, metadata 
		eg : there can be error schema -> to handle records which could not be processed.

Since this is a small project to demonstarte DWH concepts and SQL skills , we are not creating differnt database and support and error schema.

*/



USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'My_Hospital')
BEGIN
    ALTER DATABASE My_Hospital SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE My_Hospital;
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE My_Hospital;
GO

USE My_Hospital;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

CREATE SCHEMA silver_error;
GO


