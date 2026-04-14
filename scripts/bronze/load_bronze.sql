/*
Stored Procedure: Load Bronze Layer (Source -> Bronze)
    EXEC bronze.load_bronze;
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY
		SET @batch_start_time = GETDATE();

		PRINT '================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------';

		-- CRM CUSTOMER
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_cust_info;

		BULK INSERT bronze.crm_cust_info
		FROM 'D:\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);

		SET @end_time = GETDATE();

		-- CRM PRODUCT
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_prd_info;

		BULK INSERT bronze.crm_prd_info
		FROM 'D:\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);

		SET @end_time = GETDATE();

		-- CRM SALES
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_sales_details;

		BULK INSERT bronze.crm_sales_details
		FROM 'D:\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);

		SET @end_time = GETDATE();

		PRINT '------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------';

		-- ERP LOCATION
		TRUNCATE TABLE bronze.erp_loc_a101;

		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);

		-- ERP CUSTOMER
		TRUNCATE TABLE bronze.erp_cust_az12;

		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);

		-- ERP CATEGORY
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);

		SET @batch_end_time = GETDATE();

		PRINT '==========================================';
		PRINT 'Loading Bronze Layer is Completed';
		PRINT '==========================================';

	END TRY
	BEGIN CATCH
		PRINT '==========================================';
		PRINT 'ERROR OCCURRED';
		PRINT ERROR_MESSAGE();
		PRINT '==========================================';
	END CATCH
END
