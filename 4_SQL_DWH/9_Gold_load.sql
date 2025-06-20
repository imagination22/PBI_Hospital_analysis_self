CREATE OR ALTER PROCEDURE Gold.insert_gold AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY



		SET @batch_start_time = GETDATE();
		
		SET @start_time = GETDATE();
		
		
		INSERT INTO GOLD.Dim_Patient (
	patient_id
	,name
	,gender
	,age
	,blood_group
	,STATE
	,admission_status
	,image_path
	,address
	,email
	,phone
	)
SELECT patient_id
	,name
	,gender
	,age
	,blood_group
	,CAST(STATE AS VARCHAR(50))
	,admission_status
	,image_path
	,address
	,email
	,phone
FROM Silver.Patient;

INSERT INTO GOLD.Dim_Department (
	department_id
	,name
	,floor
	,head_doctor_id
	,total_staff
	,phone_extension
	)
SELECT DISTINCT department_id
	,name
	,floor
	,head_doctor_id
	,total_staff
	,phone_extension
FROM Silver.Department;

INSERT INTO GOLD.Dim_PaymentMethod (method_name)
SELECT DISTINCT payment_method
FROM Silver.Appointment
WHERE payment_method IS NOT NULL;

INSERT INTO GOLD.Dim_Doctor (
	doctor_id
	,name
	,specialization
	,experience_years
	,availability
	,department_skey
	,STATUS
	,joining_date
	,qualification
	,phone
	,email
	,image_path
	)
SELECT d.doctor_id
	,d.name
	,d.specialization
	,d.experience_years
	,d.availability
	,dd.department_skey
	,d.STATUS
	,d.joining_date
	,d.qualification
	,d.phone
	,d.email
	,d.image_path
FROM Silver.Doctor d
JOIN GOLD.Dim_Department dd ON d.department_name = dd.name;

INSERT INTO GOLD.Fact_PatientVitals (
	patient_skey
	,record_date
	,weight
	)
SELECT dp.patient_skey
	,GETDATE()
	,-- assuming latest vitals on load
	sp.weight
FROM Silver.Patient sp
JOIN GOLD.Dim_Patient dp ON sp.patient_id = dp.patient_id
WHERE sp.weight IS NOT NULL;

INSERT INTO GOLD.Fact_Admissions (
	patient_skey
	,admission_date
	,discharge_date
	,admission_status
	)
SELECT dp.patient_skey
	,sp.admission_date
	,sp.discharge_date
	,sp.admission_status
FROM Silver.Patient sp
JOIN GOLD.Dim_Patient dp ON sp.patient_id = dp.patient_id
WHERE sp.admission_date IS NOT NULL;

INSERT INTO GOLD.Fact_Appointments (
	appointment_id
	,patient_skey
	,doctor_skey
	,department_skey
	,date_skey
	,time_skey
	,reason
	,diagnosis
	,payment_method_skey
	,discount
	,fees
	,STATUS
	,doctor_notes
	,suggestions
	)
SELECT a.appointment_id
	,dp.patient_skey
	,dd.doctor_skey
	,dep.department_skey
	,dt.date_skey
	,tm.time_skey
	,a.reason
	,a.diagnosis
	,pm.payment_method_skey
	,a.discount
	,a.fees
	,a.STATUS
	,a.doctor_notes
	,a.suggestions
FROM Silver.Appointment a
JOIN GOLD.Dim_Patient dp ON a.patient_id = dp.patient_id
JOIN GOLD.Dim_Doctor dd ON a.doctor_id = dd.doctor_id
JOIN GOLD.Dim_Department dep ON dd.department_skey = dep.department_skey
JOIN GOLD.Dim_Date dt ON a.appointment_date = dt.full_date
JOIN GOLD.Dim_Time tm ON a.appointment_time = tm.time_value
JOIN GOLD.Dim_PaymentMethod pm ON a.payment_method = pm.method_name;

INSERT INTO GOLD.Dim_Room (
	room_id
	,room_type
	,floor
	,capacity
	,STATUS
	,daily_charges
	,avg_monthly_maintenance
	)
SELECT DISTINCT room_id
	,room_type
	,floor
	,capacity
	,STATUS
	,daily_charges
	,avg_monthly_maintenance
FROM Silver.Room;

INSERT INTO GOLD.Dim_Bed (
	bed_id
	,room_skey
	,STATUS
	,occupation_start_time
	,occupation_end_time
	)
SELECT b.bed_id
	,r.room_skey
	,b.current_status
	,b.occupation_start_time
	,b.occupation_end_time
FROM Silver.Bed b
JOIN GOLD.Dim_Room r ON b.room_id = r.room_id;

INSERT INTO GOLD.Fact_PatientStay (
	stay_id
	,patient_skey
	,room_skey
	,bed_skey
	,department_skey
	,admission_date
	,discharge_date
	,days_admitted
	,admission_status
	,image_path
	,daily_charge
	,total_room_cost
	,surgery_cost
	)
SELECT CONCAT (
		p.patient_id
		,'-'
		,sb.bed_id
		) AS stay_id
	,dp.patient_skey
	,dr.room_skey
	,db.bed_skey
	,dd.department_skey
	,p.admission_date
	,p.discharge_date
	,DATEDIFF(DAY, p.admission_date, p.discharge_date)
	,p.admission_status
	,p.image_path
	,dr.daily_charges
	,DATEDIFF(DAY, p.admission_date, p.discharge_date) * dr.daily_charges
	,0.00 AS surgery_cost -- Placeholder for now
FROM Silver.Patient p
JOIN Silver.Bed sb ON sb.patient_id = p.patient_id
JOIN GOLD.Dim_Patient dp ON dp.patient_id = p.patient_id
JOIN GOLD.Dim_Bed db ON sb.bed_id = db.bed_id
JOIN GOLD.Dim_Room dr ON sb.room_id = dr.room_id
JOIN Silver.Room sr ON sr.room_id = sb.room_id
JOIN GOLD.Dim_Department dd ON sr.department_id = dd.department_id;

INSERT INTO GOLD.Fact_Billing (
	bill_id
	,patient_skey
	,admission_date_skey
	,discharge_date_skey
	,room_charges
	,surgery_charges
	,medicine_charges
	,test_charges
	,doctor_fees
	,other_charges
	,total_amount
	,discount
	,amount_paid
	,balance_due
	,payment_status
	,payment_method_skey
	)
SELECT b.bill_id
	,dp.patient_skey
	,ad.date_skey
	,dd.date_skey
	,b.room_charges
	,b.surgery_charges
	,b.medicine_charges
	,b.test_charges
	,b.doctor_fees
	,b.other_charges
	,b.total_amount
	,b.discount
	,b.amount_paid
	,(b.total_amount - b.amount_paid) AS balance_due
	,b.payment_status
	,pm.payment_method_skey
FROM Silver.Billing b
JOIN GOLD.Dim_Patient dp ON b.patient_id = dp.patient_id
JOIN GOLD.Dim_Date ad ON ad.full_date = b.admission_date
JOIN GOLD.Dim_Date dd ON dd.full_date = b.discharge_date
JOIN GOLD.Dim_PaymentMethod pm ON pm.method_name = b.payment_method;

INSERT INTO GOLD.Fact_Tests (
	patient_test_id
	,test_skey
	,patient_skey
	,doctor_skey
	,test_date_skey
	,result_date_skey
	,test_cost
	,discount
	,result_status
	,test_result
	,result_notes
	,payment_method_skey
	)
SELECT pt.patient_test_id
	,dt.test_skey
	,dp.patient_skey
	,dd.doctor_skey
	,td.date_skey
	,rd.date_skey
	,pt.amount
	,pt.discount
	,pt.STATUS
	,pt.result
	,pt.result_notes
	,pm.payment_method_skey
FROM Silver.PatientTest pt
JOIN GOLD.Dim_Test dt ON pt.test_id = dt.test_id
JOIN GOLD.Dim_Patient dp ON pt.patient_id = dp.patient_id
JOIN GOLD.Dim_Doctor dd ON pt.doctor_id = dd.doctor_id
JOIN GOLD.Dim_Date td ON pt.test_date = td.full_date
JOIN GOLD.Dim_Date rd ON pt.result_date = rd.full_date
JOIN GOLD.Dim_PaymentMethod pm ON pt.payment_method = pm.method_name;

INSERT INTO GOLD.Dim_Medicine (
	medicine_id
	,name
	,category
	,cost_price
	,unit_price
	,expiry_date
	,manufacturing_date
	,batch_number
	,reorder_level
	)
SELECT ms.medicine_id
	,ms.name
	,ms.category
	,ms.cost_price
	,ms.unit_price
	,ms.expiry_date
	,ms.manufacturing_date
	,ms.batch_number
	,ms.reorder_level
FROM Silver.MedicalStock ms;

INSERT INTO GOLD.Dim_Supplier (
	supplier_id
	,name
	,contact_person
	,city
	,STATE
	,phone
	,email
	,address
	,landmark
	,pincode
	,contract_start
	,contract_end
	)
SELECT supplier_id
	,name
	,contact_person
	,city
	,STATE
	,phone
	,email
	,address
	,landmark
	,pincode
	,contract_start
	,contract_end
FROM Silver.Supplier;

INSERT INTO GOLD.Fact_MedicinePurchases (
	purchase_id
	,patient_skey
	,medicine_skey
	,supplier_skey
	,date_skey
	,quantity_purchased
	,total_cost
	,discount_applied
	)
SELECT CAST(mp.med_patient_id AS VARCHAR)
	,-- assuming INT PK in Silver, cast to match VARCHAR PK in Gold
	dp.patient_skey
	,dm.medicine_skey
	,ds.supplier_skey
	,dd.date_skey
	,mp.Quantity
	,dm.unit_price * mp.Quantity
	,0.00 -- or apply logic to calculate discount
FROM Silver.medicine_patient mp
JOIN GOLD.Dim_Patient dp ON mp.patient_id = dp.patient_id
JOIN GOLD.Dim_Medicine dm ON mp.medicine = dm.medicine_id
JOIN Silver.MedicalStock ms ON ms.medicine_id = dm.medicine_id
JOIN GOLD.Dim_Supplier ds ON ms.supplier_id = ds.supplier_id
JOIN GOLD.Dim_Date dd ON dd.full_date = mp.purchase_date;

INSERT INTO GOLD.Fact_MedicineInventorySnapshot (
	snapshot_date_skey
	,medicine_skey
	,stock_quantity
	,reorder_level
	)
SELECT dd.date_skey
	,dm.medicine_skey
	,ms.stock_quantity
	,ms.reorder_level
FROM Silver.MedicalStock ms
JOIN GOLD.Dim_Medicine dm ON ms.medicine_id = dm.medicine_id
JOIN GOLD.Dim_Date dd ON dd.full_date = CAST(GETDATE() AS DATE);-- or any chosen snapshot date

INSERT INTO GOLD.Fact_SatisfactionScore (
	satisfaction_id
	,patient_skey
	,doctor_skey
	,department_skey
	,date_skey
	,rating
	,feedback
	)
SELECT ss.satisfaction_id
	,dp.patient_skey
	,dd.doctor_skey
	,dpt.department_skey
	,dt.date_skey
	,ss.rating
	,ss.feedback
FROM Silver.SatisfactionScore ss
JOIN GOLD.Dim_Patient dp ON ss.patient_id = dp.patient_id
JOIN GOLD.Dim_Doctor dd ON ss.doctor_id = dd.doctor_id
JOIN GOLD.Dim_Department dpt ON ss.department_name = dpt.name
JOIN GOLD.Dim_Date dt ON ss.DATE = dt.full_date;

INSERT INTO GOLD.Dim_Staff (
	staff_id
	,name
	,department_skey
	,ROLE
	,salary
	,joining_date
	,shift
	,phone
	,email
	,address
	)
SELECT s.staff_id
	,s.name
	,d.department_skey
	,s.ROLE
	,s.salary
	,s.joining_date
	,s.shift
	,s.phone
	,s.email
	,s.address
FROM Silver.Staff s
JOIN GOLD.Dim_Department d ON s.department_id = d.department_id;

INSERT INTO GOLD.Agg_MonthlyRevenue (
    month_skey,
    department_skey,
    total_revenue,
    test_revenue,
    medicine_revenue,
    surgery_revenue,
    num_patients,
    num_bills
)
SELECT
    dt_month.date_skey AS month_skey,
    d.department_skey,
    SUM(b.total_amount),
    SUM(b.test_charges),
    SUM(b.medicine_charges),
    SUM(b.surgery_charges),
    COUNT(DISTINCT b.patient_skey),
    COUNT(b.bill_id)
FROM GOLD.Fact_Billing b
JOIN GOLD.Dim_Date dd ON dd.date_skey = b.admission_date_skey
JOIN GOLD.Dim_Date dt_month 
    ON MONTH(dt_month.full_date) = MONTH(dd.full_date)
   AND YEAR(dt_month.full_date) = YEAR(dd.full_date)
JOIN GOLD.Dim_Patient p ON b.patient_skey = p.patient_skey
JOIN GOLD.Fact_PatientStay s ON b.patient_skey = s.patient_skey
JOIN GOLD.Dim_Department d ON s.department_skey = d.department_skey
GROUP BY dt_month.date_skey, d.department_skey;

INSERT INTO GOLD.Agg_DoctorPerformance (
	month_skey
	,doctor_skey
	,total_appointments
	,avg_rating
	,rating_stddev
	,total_fees
	,num_feedbacks
	)
SELECT d.date_skey AS month_skey
	,a.doctor_skey
	,COUNT(*) AS total_appointments
	,ISNULL(AVG(s.rating), 0) AS avg_rating
	,STDEV(CAST(s.rating AS FLOAT)) AS rating_stddev
	,SUM(a.fees)
	,COUNT(s.rating) AS num_feedbacks
FROM GOLD.Fact_Appointments a
JOIN GOLD.Dim_Date d ON a.date_skey = d.date_skey
LEFT JOIN GOLD.Fact_SatisfactionScore s ON a.doctor_skey = s.doctor_skey
GROUP BY d.date_skey
	,a.doctor_skey;

INSERT INTO GOLD.Agg_BedOccupancy (
	date_skey
	,
	-- department_skey,
	total_beds
	,occupied_beds
	,occupancy_rate
	,avg_stay_duration
	,num_admissions
	,turnover_rate
	)
SELECT dd.date_skey
	,COUNT(db.bed_skey)
	,SUM(CASE 
			WHEN db.STATUS = 'Occupied'
				THEN 1
			ELSE 0
			END)
	,ROUND(100.0 * SUM(CASE 
				WHEN db.STATUS = 'Occupied'
					THEN 1
				ELSE 0
				END) / NULLIF(COUNT(db.bed_skey), 0), 2)
	,ISNULL(AVG(DATEDIFF(DAY, s.admission_date, s.discharge_date)), 0)
	,COUNT(DISTINCT s.stay_id)
	,ROUND(COUNT(DISTINCT s.stay_id) * 1.0 / NULLIF(COUNT(db.bed_skey), 0), 2)
FROM GOLD.Dim_Bed db
JOIN GOLD.Dim_Room dr ON db.room_skey = dr.room_skey
JOIN GOLD.Fact_PatientStay s ON db.bed_skey = s.bed_skey
JOIN GOLD.Dim_Date dd ON dd.full_date = CAST(GETDATE() AS DATE)
GROUP BY dd.date_skey

INSERT INTO GOLD.Agg_TestAnalytics (
	test_skey
	,month_skey
	,num_tests
	,abnormal_results
	,avg_test_cost
	)
SELECT ft.test_skey
	,d.date_skey
	,COUNT(ft.patient_test_id)
	,COUNT(CASE 
			WHEN ft.result_status = 'Abnormal'
				THEN 1
			END)
	,AVG(ft.test_cost)
FROM GOLD.Fact_Tests ft
JOIN GOLD.Dim_Date d ON ft.test_date_skey = d.date_skey
GROUP BY ft.test_skey
	,d.date_skey;

INSERT INTO GOLD.Agg_PatientDemographics (
	month_skey
	,gender
	,age_group
	,region
	,num_patients
	,avg_visits
	)
SELECT dd.date_skey
	,dp.gender
	,CASE 
		WHEN dp.age < 18
			THEN 'Under 18'
		WHEN dp.age BETWEEN 18
				AND 35
			THEN '18–35'
		WHEN dp.age BETWEEN 36
				AND 60
			THEN '36–60'
		ELSE '60+'
		END AS age_group
	,dp.STATE AS region
	,COUNT(DISTINCT fp.patient_skey)
	,COUNT(fp.patient_skey) * 1.0 / NULLIF(COUNT(DISTINCT fp.patient_skey), 0)
FROM GOLD.Fact_PatientStay fp
JOIN GOLD.Dim_Patient dp ON fp.patient_skey = dp.patient_skey
JOIN GOLD.Dim_Date dd ON dd.full_date = fp.admission_date
GROUP BY dd.date_skey
	,dp.gender
	,dp.STATE
	,CASE 
		WHEN dp.age < 18
			THEN 'Under 18'
		WHEN dp.age BETWEEN 18
				AND 35
			THEN '18–35'
		WHEN dp.age BETWEEN 36
				AND 60
			THEN '36–60'
		ELSE '60+'
		END;

INSERT INTO GOLD.Agg_SatisfactionTrend (
	month_skey
	,department_skey
	,avg_rating
	,rating_stddev
	,num_responses
	)
SELECT d.date_skey
	,dep.department_skey
	,AVG(s.rating)
	,STDEV(CAST(s.rating AS FLOAT))
	,COUNT(s.rating)
FROM GOLD.Fact_SatisfactionScore s
JOIN GOLD.Dim_Date d ON s.date_skey = d.date_skey
JOIN GOLD.Dim_Department dep ON s.department_skey = dep.department_skey
GROUP BY d.date_skey
	,dep.department_skey;


		SET @batch_end_time = GETDATE();
	
		PRINT 'Loading gold Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		


END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING insert into gold layer'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END