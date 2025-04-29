/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

if object_id('Bronze.crm_prd_info','U') is not NUll
	drop table Bronze.crm_prd_info
create table Bronze.crm_prd_info(
prd_id INT,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost NVARCHAR(50),
prd_line NVARCHAR(50),
prd_start_dt Date ,
prd_end_dt Date
)

IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
GO

CREATE TABLE bronze.crm_cust_info (
    cst_id              INT,
    cst_key             NVARCHAR(50),
    cst_firstname       NVARCHAR(50),
    cst_lastname        NVARCHAR(50),
    cst_marital_status  NVARCHAR(50),
    cst_gndr            NVARCHAR(50),
    cst_create_date     DATE
);

IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  NVARCHAR(50),
    sls_prd_key  NVARCHAR(50),
    sls_cust_id  Nvarchar(50),
    sls_order_dt Nvarchar(50),
    sls_ship_dt  Nvarchar(50),
    sls_due_dt   Nvarchar(50),
    sls_sales    Nvarchar(50),
    sls_quantity Nvarchar(50),
    sls_price    Varchar(100),
);

IF Object_ID('Bronze.erp_cust_az12', 'U') is not null
	Drop Table Bronze.erp_cust_az12
create table Bronze.erp_cust_az12(
CID NVARCHAR(50),
BDATE Date,
GEN NVARCHAR(50)

)

IF Object_ID('Bronze.erp_loc_a101', 'U') is not null
	Drop Table Bronze.erp_loc_a101
create table Bronze.erp_loc_a101(
CID NVARCHAR(50),
CNTRY NVARCHAR(50)

)

IF Object_ID('Bronze.erp_px_cat_g1v2', 'U') is not null
	Drop Table Bronze.erp_px_cat_g1v2
create table Bronze.erp_px_cat_g1v2(
ID NVARCHAR(50),
CAT NVARCHAR(50),
SUBCAT NVARCHAR(50),
MAINTENANCE NVARCHAR(50)

)

