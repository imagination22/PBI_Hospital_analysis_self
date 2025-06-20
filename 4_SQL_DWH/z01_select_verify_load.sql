use My_Hospital
	Select count(*) from 	Bronze.Patient
	Select count(*) from    Bronze.Department
	Select count(*) from    Bronze.Doctor
	Select count(*) from    Bronze.Appointment
	Select count(*) from    Bronze.Surgery
	Select count(*) from    Bronze.Room
	Select count(*) from    Bronze.Bed 
	Select count(*) from    Bronze.Billing
	Select count(*) from    Bronze.MedicalStock
	Select count(*) from    Bronze.MedicalTest
	Select count(*) from    Bronze.PatientTest
	Select count(*) from    Bronze.SatisfactionScore
	Select count(*) from    Bronze.Staff
	Select count(*) from    Bronze.Supplier
	Select count(*) from    Bronze.medicine_patient


select count(*) from  Silver_error.Appointment
select count(*) from  Silver_error.Bed
select count(*) from  Silver_error.Billing
select count(*) from  Silver_error.Department
select count(*) from  Silver_error.Doctor
select count(*) from  Silver_error.MedicalStock
select count(*) from  Silver_error.MedicalTest
select count(*) from  Silver_error.medicine_patient
select count(*) from  Silver_error.Patient
select count(*) from  Silver_error.PatientTest
select count(*) from  Silver_error.Room
select count(*) from  Silver_error.SatisfactionScore
select count(*) from  Silver_error.Staff
select count(*) from  Silver_error.Supplier
select count(*) from  Silver_error.Surgery


select count(*) from  Silver.Appointment
select count(*) from  Silver.Bed
select count(*) from  Silver.Billing
select count(*) from  Silver.Department
select count(*) from  Silver.Doctor
select count(*) from  Silver.MedicalStock
select count(*) from  Silver.MedicalTest
select count(*) from  Silver.medicine_patient
select count(*) from  Silver.Patient
select count(*) from  Silver.PatientTest
select count(*) from  Silver.Room
select count(*) from  Silver.SatisfactionScore
select count(*) from  Silver.Staff
select count(*) from  Silver.Supplier
select count(*) from  Silver.Surgery

select count(*) from gold.Fact_Admissions
select count(*) from gold.Fact_Appointments
select count(*) from gold.Fact_Billing
select count(*) from gold.Fact_MedicineInventorySnapshot
select count(*) from gold.Fact_MedicinePurchases
select count(*) from gold.Fact_PatientStay
select count(*) from gold.Fact_PatientVitals
select count(*) from gold.Fact_SatisfactionScore
select count(*) from gold.Fact_Tests
select count(*) from gold.Agg_BedOccupancy
select count(*) from gold.Agg_DoctorPerformance
select count(*) from gold.Agg_MonthlyRevenue
select count(*) from gold.Agg_PatientDemographics
select count(*) from gold.Agg_SatisfactionTrend
select count(*) from gold.Agg_TestAnalytics
select count(*) from gold.Dim_Bed
select count(*) from gold.Dim_Date
select count(*) from gold.Dim_Department
select count(*) from gold.Dim_Doctor
select count(*) from gold.Dim_Medicine
select count(*) from gold.Dim_Patient
select count(*) from gold.Dim_PaymentMethod
select count(*) from gold.Dim_Room
select count(*) from gold.Dim_Staff
select count(*) from gold.Dim_Supplier
select count(*) from gold.Dim_Test
select count(*) from gold.Dim_Time

	Select * from 	Bronze.Patient
	Select * from    Bronze.Department
	Select * from    Bronze.Doctor
	Select * from    Bronze.Appointment
	Select * from    Bronze.Surgery
	Select * from    Bronze.Room
	Select * from    Bronze.Bed 
	Select * from    Bronze.Billing
	Select * from    Bronze.MedicalStock
	Select * from    Bronze.MedicalTest
	Select * from    Bronze.PatientTest
	Select * from    Bronze.SatisfactionScore
	Select * from    Bronze.Staff
	Select * from    Bronze.Supplier
	Select * from    Bronze.medicine_patient

	Select * from 	Silver.Patient
	Select * from    Silver.Department
	Select * from    Silver.Doctor
	Select * from    Silver.Appointment
	Select * from    Silver.Surgery
	Select * from    Silver.Room
	Select * from    Silver.Bed 
	Select * from    Silver.Billing
	Select * from    Silver.MedicalStock
	Select * from    Silver.MedicalTest
	Select * from    Silver.PatientTest
	Select * from    Silver.SatisfactionScore
	Select * from    Silver.Staff
	Select * from    Silver.Supplier
	Select * from    Silver.medicine_patient
	



	
select * from Gold.Agg_BedOccupancy
select * from Gold.Agg_DoctorPerformance
select * from Gold.Agg_MonthlyRevenue
select * from Gold.Dim_Bed
select * from Gold.Dim_Date
select * from Gold.Dim_Department
select * from Gold.Dim_Doctor
select * from Gold.Dim_Medicine
select * from Gold.Dim_Patient
select * from Gold.Dim_PaymentMethod
select * from Gold.Dim_Room
select * from Gold.Dim_Supplier
select * from Gold.Dim_Test
select * from Gold.Fact_Admissions
select * from Gold.Fact_Appointments
select * from Gold.Fact_Billing
select * from Gold.Fact_MedicinePurchases
select * from Gold.Fact_PatientStay
select * from Gold.Fact_PatientVitals
select * from Gold.Fact_Tests


select * from Gold.Dim_Date
select * from Gold.Dim_Patient
select * from Gold.Dim_Department
select * from Gold.Dim_Doctor
select * from Gold.Dim_PaymentMethod


select * from Gold.Fact_Appointments
select * from Gold.Fact_Admissions
select * from Gold.Fact_PatientVitals

select * from Gold.Dim_Bed
select * from Gold.Dim_Room
select * from Gold.Fact_PatientStay