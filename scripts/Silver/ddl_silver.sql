




if object_id('silver.crm_prd_info','U') is not NUll
	drop table silver.crm_prd_info
create table silver.crm_prd_info(
prd_id INT,
cat_id NVARCHAR(50),
prd_key NVARCHAR(50),

prd_nm NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt Date ,
prd_end_dt Date,
dwh_create_date datetime2 default getdate()
)

IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO

CREATE TABLE silver.crm_cust_info (
    cst_id              INT,
    cst_key             NVARCHAR(50),
    cst_firstname       NVARCHAR(50),
    cst_lastname        NVARCHAR(50),
    cst_marital_status  NVARCHAR(50),
    cst_gndr            NVARCHAR(50),
    cst_create_date     DATE,
	dwh_create_date datetime2 default getdate()
);

IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
    sls_ord_num  NVARCHAR(50),
    sls_prd_key  NVARCHAR(50),
    sls_cust_id  Nvarchar(50),
    sls_order_dt DATE,
    sls_ship_dt  DATE,
    sls_due_dt   DATE,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT,
	dwh_create_date datetime2 default getdate()
);

IF Object_ID('silver.erp_cust_az12', 'U') is not null
	Drop Table silver.erp_cust_az12
create table silver.erp_cust_az12(
CID NVARCHAR(50),
BDATE Date,
GEN NVARCHAR(50),
dwh_create_date datetime2 default getdate()

)

IF Object_ID('silver.erp_loc_a101', 'U') is not null
	Drop Table silver.erp_loc_a101
create table silver.erp_loc_a101(
CID NVARCHAR(50),
CNTRY NVARCHAR(50),
dwh_create_date datetime2 default getdate()

)

IF Object_ID('silver.erp_px_cat_g1v2', 'U') is not null
	Drop Table silver.erp_px_cat_g1v2
create table silver.erp_px_cat_g1v2(
ID NVARCHAR(50),
CAT NVARCHAR(50),
SUBCAT NVARCHAR(50),
MAINTENANCE NVARCHAR(50),
dwh_create_date datetime2 default getdate()

)
