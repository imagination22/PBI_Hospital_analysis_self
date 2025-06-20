	 use My_Hospital
														-- create Sb and schema
	exec bronze.create_ddl_bronze
														--exec Silver.create_silver_cleanup
	exec Silver.create_ddl_silver
	exec Silver_error.create_ddl_error_silver
														--exec Silver_error.create_silver_error_cleanup
														--exec Gold.cleanup
	exec Gold.create_ddl_gold
	EXEC bronze.load_bronze;
	EXEC silver.load_silver;
	exec gold.insert_dim_date
														--exec  Gold.inssert_gold
	exec Gold.insert_gold



	select * from silver_error.PatientTest		where patient_id not in (select patient_id from silver.Patient)
	select * from silver_error.PatientTest		where doctor_id not in (select doctor_id from silver.Doctor)
	select * from silver_error.PatientTest		where test_id not in (select test_id from silver.MedicalTest)


		