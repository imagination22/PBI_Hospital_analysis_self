/*************************************************************************************************************/
select count(*) from Silver.Patient  -- 30 
select * from GOLD.Dim_Patient			--30

/*************************************************************************************************************/

select count(*) from Silver.Department  -- 15
select * from GOLD.Dim_Department			--15
/*************************************************************************************************************/

select DISTINCT payment_method method from Silver.Appointment  --4
select * from GOLD.Dim_PaymentMethod		
/*************************************************************************************************************/

select * from Silver.Doctor d  --15
JOIN GOLD.Dim_Department dd ON d.department_name = dd.name; -- 15

select * from  GOLD.Dim_Doctor				--15
/*************************************************************************************************************/

select *  FROM Silver.Patient sp								--30
JOIN GOLD.Dim_Patient dp ON sp.patient_id = dp.patient_id		--30
WHERE sp.weight IS NOT NULL;									--30

select * from GOLD.Fact_PatientVitals --30

/*************************************************************************************************************/
select * from  GOLD.Fact_Admissions  --30

select * 
FROM Silver.Patient sp												--30
JOIN GOLD.Dim_Patient dp ON sp.patient_id = dp.patient_id			--30
WHERE sp.admission_date IS NOT NULL;								--30

/*************************************************************************************************************/
select * from 
GOLD.Fact_Appointments		--35

select * 
FROM Silver.Appointment a
JOIN GOLD.Dim_Patient dp ON a.patient_id = dp.patient_id						--35
JOIN GOLD.Dim_Doctor dd ON a.doctor_id = dd.doctor_id							--35			
JOIN GOLD.Dim_Department dep ON dd.department_skey = dep.department_skey		--35
JOIN GOLD.Dim_Date dt ON a.appointment_date = dt.full_date						--35
JOIN GOLD.Dim_PaymentMethod pm ON a.payment_method = pm.method_name;			--35

/*************************************************************************************************************/
select * from 
GOLD.Dim_Room		--27

select *  
FROM Silver.Room;		--27

/*************************************************************************************************************/
select * from 
 GOLD.Dim_Bed 

 select * from 
 Silver.Bed b
JOIN GOLD.Dim_Room r ON b.room_id = r.room_id;



/*************************************************************************************************************/

Select * from  GOLD.Fact_PatientStay --4

Select * 
FROM Silver.Patient p
JOIN Silver.Bed sb ON sb.patient_id = p.patient_id
JOIN GOLD.Dim_Patient dp ON dp.patient_id = p.patient_id
JOIN GOLD.Dim_Bed db ON sb.bed_id = db.bed_id
JOIN GOLD.Dim_Room dr ON sb.room_id = dr.room_id
JOIN Silver.Room sr ON sr.room_id = sb.room_id
JOIN GOLD.Dim_Department dd ON sr.department_id = dd.department_id;  --4

/*************************************************************************************************************/
Select * from  GOLD.Fact_Billing --22
select * from  Silver.Billing b   --30
JOIN GOLD.Dim_Patient dp ON b.patient_id = dp.patient_id
JOIN GOLD.Dim_Date ad ON ad.full_date = b.admission_date
left JOIN GOLD.Dim_Date dd ON dd.full_date = b.discharge_date
JOIN GOLD.Dim_PaymentMethod pm ON pm.method_name = b.payment_method;
/*************************************************************************************************************/
select 
test_id
,test_name
,category
,department_id
,cost
,duration
,fasting_required
from silver.MedicalTest

select * from  GOLD.Dim_Test


select * from silver.PatientTest

Select * from 
GOLD.Fact_Tests 

select * from  Silver.PatientTest pt  --24
JOIN GOLD.Dim_Test dt ON pt.test_id = dt.test_id
JOIN GOLD.Dim_Patient dp ON pt.patient_id = dp.patient_id
JOIN GOLD.Dim_Doctor dd ON pt.doctor_id = dd.doctor_id
JOIN GOLD.Dim_Date td ON pt.test_date = td.full_date
JOIN GOLD.Dim_Date rd ON pt.result_date = rd.full_date
JOIN GOLD.Dim_PaymentMethod pm ON pt.payment_method = pm.method_name;

Select * from 
GOLD.Fact_Tests


/*************************************************************************************************************/
select * from  GOLD.Fact_Billing --30

select * 
FROM Silver.Billing b														--30
JOIN GOLD.Dim_Patient dp ON b.patient_id = dp.patient_id					--30
JOIN GOLD.Dim_Date ad ON ad.full_date = b.admission_date					--30
left JOIN GOLD.Dim_Date dd ON dd.full_date = b.discharge_date				--30
JOIN GOLD.Dim_PaymentMethod pm ON pm.method_name = b.payment_method;		--30


/*************************************************************************************************************/
select * from GOLD.Dim_Medicine      --15
select * FROM Silver.MedicalStock ms;--15

/*************************************************************************************************************/
select * from  GOLD.Dim_Supplier --5
select * from    Silver.Supplier; --5
/*************************************************************************************************************/
select * from 
GOLD.Fact_MedicinePurchases --517

select *
FROM Silver.medicine_patient mp
JOIN GOLD.Dim_Patient dp ON mp.patient_id = dp.patient_id
JOIN GOLD.Dim_Medicine dm ON mp.medicine = dm.medicine_id
JOIN Silver.MedicalStock ms ON ms.medicine_id = dm.medicine_id
JOIN GOLD.Dim_Supplier ds ON ms.supplier_id = ds.supplier_id
JOIN GOLD.Dim_Date dd ON dd.full_date = mp.purchase_date;
--517
/*************************************************************************************************************/
select * from 
GOLD.Fact_MedicineInventorySnapshot								--15

select * 
FROM Silver.MedicalStock ms											--15
JOIN GOLD.Dim_Medicine dm ON ms.medicine_id = dm.medicine_id		--15
JOIN GOLD.Dim_Date dd ON dd.full_date = CAST(GETDATE() AS DATE);		--15

/*************************************************************************************************************/
select * from 
GOLD.Fact_SatisfactionScore														--18
																			
select * 																	
FROM Silver.SatisfactionScore ss												--18
JOIN GOLD.Dim_Patient dp ON ss.patient_id = dp.patient_id						--18
JOIN GOLD.Dim_Doctor dd ON ss.doctor_id = dd.doctor_id							--18
JOIN GOLD.Dim_Department dpt ON ss.department_name = dpt.name					--18
JOIN GOLD.Dim_Date dt ON ss.DATE = dt.full_date;								--18

/*************************************************************************************************************/
select * from 
GOLD.Dim_Staff																								--20

select *
FROM Silver.Staff s																			--20
JOIN GOLD.Dim_Department d ON s.department_id = d.department_id; --20

/*************************************************************************************************************/

