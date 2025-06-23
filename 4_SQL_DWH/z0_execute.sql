USE My_Hospital
/******************************************************************************/
/*  create DB and schema  */
-- run 1_INIT.sql


/******************************************************************************/

/*  create tables in schema  */
-- Bronze													
EXEC bronze.create_ddl_bronze

EXEC bronze.load_bronze;


/******************************************************************************/

-- Silver
--exec Silver.create_silver_cleanup
--exec Silver_error.create_silver_error_cleanup
EXEC Silver.create_ddl_silver

EXEC Silver_error.create_ddl_error_silver

EXEC silver.load_silver;

/******************************************************************************/

-- gOLD													
EXEC Gold.cleanup

EXEC Gold.create_ddl_gold

EXEC gold.insert_dim_date

EXEC Gold.insert_gold

EXEC Gold.pivot_bill_sp

