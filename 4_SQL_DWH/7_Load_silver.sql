/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
Source : 
	C:\Users\Lenovo\OneDrive\Desktop\Repository\SQL_DWH\SQL_DWH\Datawarehouse\source_csv\
	execute bronze.load_bronze 
===============================================================================
*/
CREATE OR ALTER PROCEDURE Silver.load_Silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY



		SET @batch_start_time = GETDATE();
		
		SET @start_time = GETDATE();
/************************************************************************************************************/
/*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/
insert into silver.Patient
(
patient_id
,name
,age
,gender
,weight
,blood_group
,address
,STATE
,phone
,email
,admission_date
,discharge_date
,admission_status
,image_path
)
select
trim(patient_id)	as patient_id
,trim(upper(name))
,age,
CASE 
				WHEN UPPER(TRIM(gender)) = 'F' THEN 'female'
				WHEN UPPER(TRIM(gender)) = 'M' THEN 'male'
				WHEN UPPER(TRIM(gender)) = 'Female' THEN 'female'
				WHEN UPPER(TRIM(gender)) = 'Male' THEN 'male'
				ELSE 'n/a'
			END AS gender,
 weight
,blood_group
,trim(lower(address))
,trim(lower(STATE)) as STATE
,phone
,trim(lower(email)) as email
,CASE 
				WHEN  LEN(trim(admission_date)) != 10 and LEN(trim(admission_date)) != 9 and LEN(trim(admission_date)) != 9
				THEN NULL
				ELSE CAST(admission_date AS DATE)
			END AS admission_date
,CASE 
				WHEN  LEN(trim(discharge_date)) != 10 and LEN(trim(discharge_date)) != 9 and LEN(trim(discharge_date)) != 8 THEN NULL
				ELSE CAST(discharge_date  AS DATE)
			END AS discharge_date

,trim(lower(admission_status)) as admission_status
,tRIM(image_path)
 from Bronze.Patient

 /*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/

ALTER TABLE Silver.Department NOCHECK CONSTRAINT ALL;

-- insert into SILVER.Department
INSERT INTO SILVER.Department (
department_id
,name
,floor
,head_doctor_id
,total_staff
,phone_extension)
 	Select 
	department_id
,name
,floor
,head_doctor_id
,total_staff
,phone_extension
	from    Bronze.Department
	where head_doctor_id  in (Select doctor_id from    Bronze.Doctor)
-- insert into SILVER_error.Department becuase head doctor doensot exists
-- logically we can have a department without doctor at first , hence we are loading into error table ,
-- error table doenst have PK , hence we can inser duplicates 
-- if we feel it needs to process , then we can talk with stakehilder , update correct doctorid and process.

INSERT INTO silver_error.Department (
department_id
,name
,floor
,head_doctor_id
,total_staff
,phone_extension)
 	Select 
	department_id
,name
,floor
,head_doctor_id
,total_staff
,phone_extension
	from    Bronze.Department
	where head_doctor_id not in (Select doctor_id from    Bronze.Doctor)


	
ALTER TABLE Silver.Department CHECK CONSTRAINT ALL;
 /*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/

ALTER TABLE Silver.Doctor NOCHECK CONSTRAINT ALL;

INSERT INTO SILVER.Doctor(
doctor_id
,name
,specialization
,department_name
,salary
,STATUS
,availability
,joining_date
,qualification
,experience_years
,phone
,email
,image_path
)
  Select 
tRIM(doctor_id) AS doctor_name
,tRIM(name) AS NAME
,tRIM(specialization)
,tRIM(department_name)
,salary
,tRIM(STATUS)
,tRIM(availability)
,CASE 
				WHEN  LEN(joining_date) != 10 THEN NULL
				ELSE CAST(joining_date AS DATE)
			END AS joining_date

,qualification
,experience_years
,phone
,tRIM(email)
,tRIM(image_path) FROM Bronze.Doctor
where department_name  in (select name from bronze.Department)


INSERT INTO silver_error.Doctor(
doctor_id
,name
,specialization
,department_name
,salary
,STATUS
,availability
,joining_date
,qualification
,experience_years
,phone
,email
,image_path
)
  Select 
tRIM(doctor_id) AS doctor_id
,tRIM(name) AS NAME
,tRIM(specialization)
,tRIM(department_name)
,salary
,tRIM(STATUS)
,tRIM(availability)
,CASE 
				WHEN  LEN(joining_date) != 10 THEN NULL
				ELSE CAST(joining_date AS DATE)
			END AS joining_date

,qualification
,experience_years
,phone
,tRIM(email)
,tRIM(image_path) FROM Bronze.Doctor
where department_name  not in (select name from bronze.Department)


ALTER TABLE Silver.Doctor CHECK CONSTRAINT ALL;


/*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/
  insert into  silver.Appointment
  (
  appointment_id
,patient_id
,doctor_id
,appointment_date
,appointment_time
,STATUS
,reason
,doctor_notes
,suggestions
,fees
,payment_method
,discount
,diagnosis
  )
  select 
 trim(upper(appointment_id))
,trim(upper(patient_id))
,trim(upper(doctor_id))
,CASE 
				WHEN  LEN(appointment_date) != 10 THEN NULL
				ELSE CAST(appointment_date AS DATE)
			END AS appointment_date
,CASE 
				WHEN  LEN(appointment_time) != 8 THEN NULL
				ELSE CAST(appointment_time AS time)
			END AS appointment_time

,trim(lower(STATUS))
,trim(reason)
,trim(doctor_notes)
,trim(suggestions)
,fees
,trim(lower(payment_method))
,discount
,  CASE 
    WHEN diagnosis LIKE '%"%' OR diagnosis LIKE '%,%' THEN 
      trim(REPLACE(REPLACE(diagnosis, '"', ''), ',', ''))
    ELSE 
      trim(diagnosis)
  END AS diagnosis

  from Bronze.Appointment
   where doctor_id  in (select doctor_id from bronze.Doctor)
   and patient_id in (select patient_id from bronze.Patient)


    insert into  silver_error.Appointment
  (
  appointment_id
,patient_id
,doctor_id
,appointment_date
,appointment_time
,STATUS
,reason
,doctor_notes
,suggestions
,fees
,payment_method
,discount
,diagnosis
  )
    select 
 trim(upper(appointment_id))
,trim(upper(patient_id))
,trim(upper(doctor_id))
,CASE 
				WHEN  LEN(trim(appointment_date)) != 10 and LEN(trim(appointment_date)) != 9 and LEN(trim(appointment_date)) != 8  THEN NULL
				ELSE CAST(appointment_date AS DATE)
			END AS appointment_date
,CASE 
				WHEN  LEN(trim(appointment_time)) != 8 and LEN(trim(appointment_time)) != 7 THEN NULL
				ELSE CAST(appointment_time AS time)
			END AS appointment_time


,trim(lower(STATUS))
,trim(reason)
,trim(doctor_notes)
,trim(suggestions)
,fees
,trim(lower(payment_method))
,discount
,  CASE 
    WHEN diagnosis LIKE '%"%' OR diagnosis LIKE '%,%' THEN 
      trim(REPLACE(REPLACE(diagnosis, '"', ''), ',', ''))
    ELSE 
      trim(diagnosis)
  END AS diagnosis

  from Bronze.Appointment
   where doctor_id  not in (select doctor_id from bronze.Doctor)
   or patient_id not  in (select patient_id from bronze.Patient)

   /*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/

insert into silver.Surgery
(
appointment_id
,patient_id
,doctor_id
,appointment_date
,Appointment_time
,STATUS
,reason
,comments
,surgery_notes
,fees
,payment_method
,discount
)
 Select
   appointment_id
,patient_id
,doctor_id
,CASE 
				WHEN  LEN(trim(appointment_date)) != 10 and LEN(trim(appointment_date)) != 9 and LEN(trim(appointment_date)) != 8  THEN NULL
				ELSE CAST(appointment_date AS DATE)
			END AS appointment_date
,CASE 
				WHEN  LEN(trim(appointment_time)) != 8 and LEN(trim(appointment_time)) != 7 THEN NULL
				ELSE CAST(appointment_time AS time)
			END AS appointment_time

,STATUS
,reason
,comments
,surgery_notes
,fees
,payment_method
,discount
from bronze.Surgery
where appointment_id in (select distinct appointment_id from bronze.Appointment)
and doctor_id in (select distinct doctor_id from bronze.Doctor)
and patient_id in (select distinct patient_id from bronze.Patient)



insert into silver_error.Surgery
(
appointment_id
,patient_id
,doctor_id
,appointment_date
,Appointment_time
,STATUS
,reason
,comments
,surgery_notes
,fees
,payment_method
,discount
)
 Select
   appointment_id
,patient_id
,doctor_id
,CASE 
				WHEN  LEN(trim(appointment_date)) != 10 and LEN(trim(appointment_date)) != 9 and LEN(trim(appointment_date)) != 8  THEN NULL
				ELSE CAST(appointment_date AS DATE)
			END AS appointment_date
,CASE 
				WHEN  LEN(trim(appointment_time)) != 8 and LEN(trim(appointment_time)) != 7 THEN NULL
				ELSE CAST(appointment_time AS time)
			END AS appointment_time

,STATUS
,reason
,comments
,surgery_notes
,fees
,payment_method
,discount
from bronze.Surgery
where appointment_id not in (select distinct appointment_id from bronze.Appointment)
or doctor_id not in (select distinct doctor_id from bronze.Doctor)
or patient_id not in (select distinct patient_id from bronze.Patient)

   /*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/


   insert into Silver.room
   (
   room_id
,department_id
,room_type
,floor
,capacity
,STATUS
,daily_charges
,avg_monthly_maintenance
   )
   Select 
room_id
,department_id
,room_type
,floor
,capacity
,STATUS
,daily_charges
,avg_monthly_maintenance
   
   from bronze.room
   where department_id in (select department_id from silver.Department)


   insert into Silver_error.room
   (
   room_id
,department_id
,room_type
,floor
,capacity
,STATUS
,daily_charges
,avg_monthly_maintenance
   )
   Select 
room_id
,department_id
,room_type
,floor
,capacity
,STATUS
,daily_charges
,avg_monthly_maintenance
   from bronze.room
   where department_id not  in (select department_id from silver.Department)

      /*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/


	  insert into silver.bed(
	  bed_id
,room_id
,current_status
,patient_id
,occupation_start_time
,occupation_end_time
	  )
	  select 
	  bed_id
,room_id
,current_status
, case when patient_id ='null' then NULL
		else patient_id end  as patient_id
,case when 
	occupation_start_time ='null' then NULL
		WHEN  LEN(trim(occupation_start_time)) != 10 and LEN(trim(occupation_start_time)) != 8 and LEN(trim(occupation_start_time)) != 9 THEN NULL
				ELSE CAST(occupation_start_time AS date)
	end as occupation_start_time
,case when 
	occupation_end_time ='null' then NULL
		WHEN  LEN(trim(occupation_end_time)) != 10 and LEN(trim(occupation_end_time)) != 8 and LEN(trim(occupation_end_time)) != 9 THEN NULL
				ELSE CAST(occupation_end_time AS date)
	end as occupation_end_time
from bronze.Bed
	where room_id in (select distinct room_id from silver.Room)  


	insert into silver_error.bed(
	  bed_id
,room_id
,current_status
,patient_id
,occupation_start_time
,occupation_end_time
	  )
		  select 
	  bed_id
,room_id
,current_status
, case when patient_id ='null' then NULL
		else patient_id end  as patient_id
,case when 
	occupation_start_time ='null' then NULL
		WHEN  LEN(trim(occupation_start_time)) != 10 and LEN(trim(occupation_start_time)) != 8 and LEN(trim(occupation_start_time)) != 9 THEN NULL
				ELSE CAST(occupation_start_time AS date)
	end as occupation_start_time
,case when 
	occupation_end_time ='null' then NULL
		WHEN  LEN(trim(occupation_end_time)) != 10 and LEN(trim(occupation_end_time)) != 8 and LEN(trim(occupation_end_time)) != 9 THEN NULL
				ELSE CAST(occupation_end_time AS date)
	end as occupation_end_time
from bronze.Bed
	where room_id not  in (select distinct room_id from silver.Room) 

	  /*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/


	  insert into silver.Billing(
	  bill_id
,patient_id
,admission_date
,discharge_date
,room_charges
,surgery_charges
,medicine_charges
,test_charges
,doctor_fees
,other_charges
,total_amount
,discount
,amount_paid
,payment_status
,payment_method
	  )
	  select bill_id
,patient_id
,case when 
	admission_date ='null' then NULL
		WHEN  LEN(trim(admission_date)) != 10 and LEN(trim(admission_date)) != 8 and LEN(trim(admission_date)) != 9 THEN NULL
				ELSE CAST(admission_date AS date) end as admission_date

,case when 
	discharge_date ='null' then NULL
		WHEN  LEN(trim(discharge_date)) != 10 and LEN(trim(discharge_date)) != 8 and LEN(trim(discharge_date)) != 9 THEN NULL
				ELSE CAST(discharge_date AS date) end as discharge_date


,room_charges
,surgery_charges
,medicine_charges
,test_charges
,doctor_fees
,other_charges
,total_amount
,discount
,amount_paid
,payment_status
,payment_method
from bronze.Billing
where patient_id in (select distinct patient_id from silver.Patient)




	   insert into silver.Billing(
	  bill_id
,patient_id
,admission_date
,discharge_date
,room_charges
,surgery_charges
,medicine_charges
,test_charges
,doctor_fees
,other_charges
,total_amount
,discount
,amount_paid
,payment_status
,payment_method
	  )
	  select bill_id
,patient_id
,case when 
	admission_date ='null' then NULL
		WHEN  LEN(trim(admission_date)) != 10 and LEN(trim(admission_date)) != 8 and LEN(trim(admission_date)) != 9 THEN NULL
				ELSE CAST(admission_date AS date) end as admission_date

,case when 
	discharge_date ='null' then NULL
		WHEN  LEN(trim(discharge_date)) != 10 and LEN(trim(discharge_date)) != 8 and LEN(trim(discharge_date)) != 9 THEN NULL
				ELSE CAST(discharge_date AS date) end as discharge_date


,room_charges
,surgery_charges
,medicine_charges
,test_charges
,doctor_fees
,other_charges
,total_amount
,discount
,amount_paid
,payment_status
,payment_method
from bronze.Billing
where patient_id not in (select distinct patient_id from silver.Patient)
 /*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/


 insert into Silver.Supplier
 (
 supplier_id
,name
,contact_person
,phone
,email
,address
,city
,landmark
,pincode
,STATE
,contract_start
,contract_end
 )
  select 
  trim(upper(supplier_id))
,name
,contact_person
,phone
,email
,CASE 
    WHEN address LIKE '%"%' OR address LIKE '%,%' THEN 
      trim(REPLACE(REPLACE(address, '"', ''), ',', ''))
    ELSE 
      trim(address)
  END AS address
,city
,CASE 
    WHEN landmark LIKE '%"%' OR landmark LIKE '%,%' THEN 
      trim(REPLACE(REPLACE(landmark, '"', ''), ',', ''))
    ELSE 
      trim(landmark)
  END AS landmark
,pincode
,STATE
,case when 
	contract_start ='null' then NULL
		WHEN  LEN(trim(contract_start)) != 10 and LEN(trim(contract_start)) != 8 and LEN(trim(contract_start)) != 9 THEN NULL
				ELSE CAST(contract_start AS date) end as contract_start
,case when 
	contract_end ='null' then NULL
		WHEN  LEN(trim(contract_end)) != 10 and LEN(trim(contract_end)) != 8 and LEN(trim(contract_end)) != 9 THEN NULL
				ELSE CAST(contract_end AS date) end as contract_end
  from bronze.Supplier

 /*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/
 

 insert into Silver.MedicalStock
 (
 medicine_id
,name
,category
,supplier_id
,cost_price
,unit_price
,stock_quantity
,expiry_date
,manufacturing_date
,batch_number
,reorder_level
 )
 select 
 trim(upper(medicine_id))
,name
,category
,trim(upper(supplier_id))
,cost_price
,unit_price
,stock_quantity
,case when 
	expiry_date ='null' then NULL
		WHEN  LEN(trim(expiry_date)) != 10 and LEN(trim(expiry_date)) != 8 and LEN(trim(expiry_date)) != 9 THEN NULL
				ELSE CAST(expiry_date AS date) end as expiry_date
,case when 
	manufacturing_date ='null' then NULL
		WHEN  LEN(trim(manufacturing_date)) != 10 and LEN(trim(manufacturing_date)) != 8 and LEN(trim(manufacturing_date)) != 9 THEN NULL
				ELSE CAST(manufacturing_date AS date) end as manufacturing_date
,trim(upper(batch_number))
,reorder_level
 from bronze.MedicalStock
 where supplier_id in (select supplier_id from silver.Supplier)




 insert into silver_error.MedicalStock
 (
 medicine_id
,name
,category
,supplier_id
,cost_price
,unit_price
,stock_quantity
,expiry_date
,manufacturing_date
,batch_number
,reorder_level
 )
 select 
 trim(upper(medicine_id))
,name
,category
,trim(upper(supplier_id))
,cost_price
,unit_price
,stock_quantity
,case when 
	expiry_date ='null' then NULL
		WHEN  LEN(trim(expiry_date)) != 10 and LEN(trim(expiry_date)) != 8 and LEN(trim(expiry_date)) != 9 THEN NULL
				ELSE CAST(expiry_date AS date) end as expiry_date
,case when 
	manufacturing_date ='null' then NULL
		WHEN  LEN(trim(manufacturing_date)) != 10 and LEN(trim(manufacturing_date)) != 8 and LEN(trim(manufacturing_date)) != 9 THEN NULL
				ELSE CAST(manufacturing_date AS date) end as manufacturing_date
,trim(upper(batch_number))
,reorder_level
 from bronze.MedicalStock
 where supplier_id not in (select supplier_id from silver.Supplier)
  /*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/

	insert into silver.MedicalTest(
test_id
,test_name
,category
,department_id
,cost
,duration
,fasting_required
	)
  Select 
  UPPER(TRIM(test_id))
,test_name
,category
,UPPER(TRIM(department_id))
,cost
,duration
,CASE 
				WHEN UPPER(TRIM(fasting_required)) = 'Y' THEN 'YES'
				WHEN UPPER(TRIM(fasting_required)) = 'N' THEN 'NO'
				WHEN UPPER(TRIM(fasting_required)) = 'YES' THEN 'YES'
				WHEN UPPER(TRIM(fasting_required)) = 'NO' THEN 'NO'
				ELSE 'n/a'
			END AS fasting_required

  from bronze.MedicalTest
  where department_id in (select department_id from silver.Department)


  insert into silver_error.MedicalTest(
test_id
,test_name
,category
,department_id
,cost
,duration
,fasting_required
	)
      Select 
  UPPER(TRIM(test_id))
,test_name
,category
,UPPER(TRIM(department_id))
,cost
,duration
,CASE 
				WHEN UPPER(TRIM(fasting_required)) = 'Y' THEN 'YES'
				WHEN UPPER(TRIM(fasting_required)) = 'N' THEN 'NO'
				WHEN UPPER(TRIM(fasting_required)) = 'YES' THEN 'YES'
				WHEN UPPER(TRIM(fasting_required)) = 'NO' THEN 'NO'
				ELSE 'n/a'
			END AS fasting_required

  from bronze.MedicalTest
  where department_id not in (select department_id from silver.Department)

    /*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/
	

	insert into silver.PatientTest
	(
	patient_test_id
,patient_id
,test_id
,doctor_id
,test_date
,result_date
,STATUS
,result
,result_notes
,amount
,payment_method
,discount
	)

		Select 
	trim(upper(	patient_test_id))
,trim(upper(	patient_id))
,trim(upper(	test_id))
,trim(upper(	doctor_id))
,case when 
	test_date ='null' then NULL
		WHEN  LEN(trim(test_date)) != 10 and LEN(trim(test_date)) != 8 and LEN(trim(test_date)) != 9 THEN NULL
				ELSE CAST(test_date AS date) end as test_date

,case when 
	result_date ='null' then NULL
		WHEN  LEN(trim(result_date)) != 10 and LEN(trim(result_date)) != 8 and LEN(trim(result_date)) != 9 THEN NULL
				ELSE CAST(result_date AS date) end as result_date
,STATUS
,result
,result_notes
,amount
,payment_method
,case when discount is null then 0.0
	when discount = 'null' or discount = 'Null' or discount = 'NULL' then 0.0
	else cast(discount as decimal(10,2)) end as 
discount
		from bronze.PatientTest
	where patient_id in (select patient_id from silver.Patient)
	and doctor_id in (select doctor_id from silver.Doctor)
	and test_id in (select test_id from silver.MedicalTest)




	insert into silver_error.PatientTest
	(
	patient_test_id
,patient_id
,test_id
,doctor_id
,test_date
,result_date
,STATUS
,result
,result_notes
,amount
,payment_method
,discount
	)

		Select 
	trim(upper(	patient_test_id))
,trim(upper(	patient_id))
,trim(upper(	test_id))
,trim(upper(	doctor_id))
,case when 
	test_date ='null' then NULL
		WHEN  LEN(trim(test_date)) != 10 and LEN(trim(test_date)) != 8 and LEN(trim(test_date)) != 9 THEN NULL
				ELSE CAST(test_date AS date) end as test_date

,case when 
	result_date ='null' then NULL
		WHEN  LEN(trim(result_date)) != 10 and LEN(trim(result_date)) != 8 and LEN(trim(result_date)) != 9 THEN NULL
				ELSE CAST(result_date AS date) end as result_date

,STATUS
,result
,result_notes
,amount
,payment_method
,case when discount is null then 0.0
	when discount = 'null' or discount = 'Null' or discount = 'NULL' then 0.0
	else cast(discount as decimal(10,2)) end as 
discount
		from bronze.PatientTest
	where patient_id not in (select patient_id from silver.Patient)
	or doctor_id not in (select doctor_id from silver.Doctor)
	or test_id not in (select test_id from silver.MedicalTest)



	    /*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/


insert into silver.SatisfactionScore(
satisfaction_id
,patient_id
,doctor_id
,rating
,feedback
,DATE
,department_name
)
Select 
satisfaction_id
,patient_id
,doctor_id
,rating
,feedback
,case when 
	DATE ='null' then NULL
		WHEN  LEN(trim(DATE)) != 10 and LEN(trim(DATE)) != 8 and LEN(trim(DATE)) != 9 THEN NULL
				ELSE CAST(DATE AS date) end as DATE
,department_name
from bronze.SatisfactionScore where  patient_id in (select patient_id from silver.Patient)
and doctor_id in (select doctor_id from silver.Doctor)
and department_name in (select name  from silver.Department)

insert into silver_error.SatisfactionScore(
satisfaction_id
,patient_id
,doctor_id
,rating
,feedback
,DATE
,department_name
)
Select 
satisfaction_id
,patient_id
,doctor_id
,rating
,feedback
,case when 
	DATE ='null' then NULL
		WHEN  LEN(trim(DATE)) != 10 and LEN(trim(DATE)) != 8 and LEN(trim(DATE)) != 9 THEN NULL
				ELSE CAST(DATE AS date) end as DATE
,department_name
from bronze.SatisfactionScore where  patient_id not in (select patient_id from silver.Patient)
or doctor_id not in (select doctor_id from silver.Doctor)
or department_name not in (select name  from silver.Department)

 /*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/


  insert into silver.Staff(
  staff_id
,name
,department_id
,ROLE
,salary

,joining_date
,shift
,phone
,email
,address
  )
   Select 
  staff_id
,name
,department_id
,ROLE
,salary

,case when 
	joining_date ='null' then NULL
		WHEN  LEN(trim(joining_date)) != 10 and LEN(trim(joining_date)) != 8 and LEN(trim(joining_date)) != 9 THEN NULL
				ELSE CAST(joining_date AS date) end as joining_date
,shift
,phone
,email
,address
   
   from bronze.Staff
   where department_id in (select department_id from silver.Department)
 
 insert into silver_error.Staff(
  staff_id
,name
,department_id
,ROLE
,salary
,joining_date
,shift
,phone
,email
,address
  )
  Select 
  staff_id
,name
,department_id
,ROLE
,salary

,case when 
	joining_date ='null' then NULL
		WHEN  LEN(trim(joining_date)) != 10 and LEN(trim(joining_date)) != 8 and LEN(trim(joining_date)) != 9 THEN NULL
				ELSE CAST(joining_date AS date) end as joining_date
,shift
,phone
,email
,address
   
   from bronze.Staff
   where department_id not  in (select department_id from silver.Department)


  /*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/




  insert into silver.medicine_patient
  (
  
patient_id
,medicine
,Quantity

,purchase_date
  )
   Select 
   patient_id
,medicine
,Quantity
,case when 
	purchase_date ='null' then NULL
		WHEN  LEN(trim(purchase_date)) != 10 and LEN(trim(purchase_date)) != 8 and LEN(trim(purchase_date)) != 9 THEN NULL
				ELSE CAST(purchase_date AS date) end as purchase_date
   
   from bronze.medicine_patient
where patient_id in (select patient_id from silver.Patient)

  insert into silver_error.medicine_patient
    (
 
patient_id
,medicine
,Quantity
,purchase_date
  )
     Select patient_id
,medicine
,Quantity
,case when 
	purchase_date ='null' then NULL
		WHEN  LEN(trim(purchase_date)) != 10 and LEN(trim(purchase_date)) != 8 and LEN(trim(purchase_date)) != 9 THEN NULL
				ELSE CAST(purchase_date AS date) end as purchase_date
    from bronze.medicine_patient
where patient_id not in (select patient_id from silver.Patient)

/*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/
 
		SET @batch_end_time = GETDATE();
	
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		

	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END