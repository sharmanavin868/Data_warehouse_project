




-- dimensiosn(Pdts)
create view gold.dim_products as 
select 
ROW_NUMBER() over(order by pn.prd_start_dt, pn.prd_key) as product_key,
pn.prd_id as product_id,
pn.cat_id as category_id,
pn.prd_key  as product_number,
pn.prd_nm as product_name ,
pn.prd_cost as cost,
pn.prd_line as product_line,
pn.prd_start_dt as start_date,
pn.prd_end_dt as end_date,
pc.CAT as category ,
pc.SUBCAT as subcategory ,
pc.MAINTENANCE 
from silver.crm_prd_info pn
left join Silver.erp_px_cat_g1v2 pc
on pn.cat_id = pc.ID
where prd_end_dt is null -- to get current information

-- Dimensions(Cust)
create view gold.dim_customers as
select 
ROW_NUMBER() over (order by cst_id) as customer_key,
ci.cst_id as customer_id,
ci.cst_key as customer_number,
ci.cst_firstname as firstname,
ci.cst_lastname as lastname,
la.cntry as country,
ci.cst_marital_status,
case when ci.cst_gndr != 'n/a' then ci.cst_gndr -- CRM is master for gender info
	else coalesce(ca.gen, 'n/a')
end as new_gen,
ca.bdate as birthdate,
ci.cst_create_date as create_date
from Silver.crm_cust_info ci
left join  silver.erp_cust_az12 ca
on ci.cst_key = ca.cid
left join Silver.erp_loc_a101 la
on ci.cst_key = la.cid


-- Fact(Sales)
Create view gold.fact_sales as
SELECT  sd.[sls_ord_num] as order_number
      ,pr.product_key
	  , cu.customer_key
      ,sd.[sls_cust_id] as customer_id
      ,sd.[sls_order_dt] as order_date
      ,sd.[sls_ship_dt] as shipping_date
      ,sd.[sls_due_dt] as due_date
      ,sd.[sls_sales] as sales
      ,sd.[sls_quantity] as quantity
      ,sd.[sls_price] as price
      ,sd.[dwh_create_date] as create_date
  FROM [datawarehouse].[Silver].[crm_sales_details] sd
  left join gold.dim_products pr
  on sd.sls_prd_key = pr.product_number
  left join gold.dim_customers cu
  on
  sd.sls_cust_id = cu.customer_id
