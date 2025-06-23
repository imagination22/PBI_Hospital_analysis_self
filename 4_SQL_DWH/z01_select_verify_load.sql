USE My_Hospital

/******************************************************************************/
SELECT count(*)
FROM Bronze.Patient

SELECT count(*)
FROM Bronze.Department

SELECT count(*)
FROM Bronze.Doctor

SELECT count(*)
FROM Bronze.Appointment

SELECT count(*)
FROM Bronze.Surgery

SELECT count(*)
FROM Bronze.Room

SELECT count(*)
FROM Bronze.Bed

SELECT count(*)
FROM Bronze.Billing

SELECT count(*)
FROM Bronze.MedicalStock

SELECT count(*)
FROM Bronze.MedicalTest

SELECT count(*)
FROM Bronze.PatientTest

SELECT count(*)
FROM Bronze.SatisfactionScore

SELECT count(*)
FROM Bronze.Staff

SELECT count(*)
FROM Bronze.Supplier

SELECT count(*)
FROM Bronze.medicine_patient

/******************************************************************************/
SELECT count(*)
FROM Silver_error.Appointment

SELECT count(*)
FROM Silver_error.Bed

SELECT count(*)
FROM Silver_error.Billing

SELECT count(*)
FROM Silver_error.Department

SELECT count(*)
FROM Silver_error.Doctor

SELECT count(*)
FROM Silver_error.MedicalStock

SELECT count(*)
FROM Silver_error.MedicalTest

SELECT count(*)
FROM Silver_error.medicine_patient

SELECT count(*)
FROM Silver_error.Patient

SELECT count(*)
FROM Silver_error.PatientTest

SELECT count(*)
FROM Silver_error.Room

SELECT count(*)
FROM Silver_error.SatisfactionScore

SELECT count(*)
FROM Silver_error.Staff

SELECT count(*)
FROM Silver_error.Supplier

SELECT count(*)
FROM Silver_error.Surgery

/******************************************************************************/
SELECT count(*)
FROM Silver.Appointment

SELECT count(*)
FROM Silver.Bed

SELECT count(*)
FROM Silver.Billing

SELECT count(*)
FROM Silver.Department

SELECT count(*)
FROM Silver.Doctor

SELECT count(*)
FROM Silver.MedicalStock

SELECT count(*)
FROM Silver.MedicalTest

SELECT count(*)
FROM Silver.medicine_patient

SELECT count(*)
FROM Silver.Patient

SELECT count(*)
FROM Silver.PatientTest

SELECT count(*)
FROM Silver.Room

SELECT count(*)
FROM Silver.SatisfactionScore

SELECT count(*)
FROM Silver.Staff

SELECT count(*)
FROM Silver.Supplier

SELECT count(*)
FROM Silver.Surgery

/******************************************************************************/
SELECT count(*)
FROM gold.Fact_Admissions

SELECT count(*)
FROM gold.Fact_Appointments

SELECT count(*)
FROM gold.Fact_Billing

SELECT count(*)
FROM gold.Fact_MedicineInventorySnapshot

SELECT count(*)
FROM gold.Fact_MedicinePurchases

SELECT count(*)
FROM gold.Fact_PatientStay

SELECT count(*)
FROM gold.Fact_PatientVitals

SELECT count(*)
FROM gold.Fact_SatisfactionScore

SELECT count(*)
FROM gold.Fact_Tests

SELECT count(*)
FROM gold.Agg_BedOccupancy

SELECT count(*)
FROM gold.Agg_DoctorPerformance

SELECT count(*)
FROM gold.Agg_MonthlyRevenue

SELECT count(*)
FROM gold.Agg_PatientDemographics

SELECT count(*)
FROM gold.Agg_SatisfactionTrend

SELECT count(*)
FROM gold.Agg_TestAnalytics

SELECT count(*)
FROM gold.Dim_Bed

SELECT count(*)
FROM gold.Dim_Date

SELECT count(*)
FROM gold.Dim_Department

SELECT count(*)
FROM gold.Dim_Doctor

SELECT count(*)
FROM gold.Dim_Medicine

SELECT count(*)
FROM gold.Dim_Patient

SELECT count(*)
FROM gold.Dim_PaymentMethod

SELECT count(*)
FROM gold.Dim_Room

SELECT count(*)
FROM gold.Dim_Staff

SELECT count(*)
FROM gold.Dim_Supplier

SELECT count(*)
FROM gold.Dim_Test

SELECT count(*)
FROM gold.Dim_Time

/******************************************************************************/
SELECT *
FROM Bronze.Patient

SELECT *
FROM Bronze.Department

SELECT *
FROM Bronze.Doctor

SELECT *
FROM Bronze.Appointment

SELECT *
FROM Bronze.Surgery

SELECT *
FROM Bronze.Room

SELECT *
FROM Bronze.Bed

SELECT *
FROM Bronze.Billing

SELECT *
FROM Bronze.MedicalStock

SELECT *
FROM Bronze.MedicalTest

SELECT *
FROM Bronze.PatientTest

SELECT *
FROM Bronze.SatisfactionScore

SELECT *
FROM Bronze.Staff

SELECT *
FROM Bronze.Supplier

SELECT *
FROM Bronze.medicine_patient

/******************************************************************************/
SELECT *
FROM Silver.Patient

SELECT *
FROM Silver.Department

SELECT *
FROM Silver.Doctor

SELECT *
FROM Silver.Appointment

SELECT *
FROM Silver.Surgery

SELECT *
FROM Silver.Room

SELECT *
FROM Silver.Bed

SELECT *
FROM Silver.Billing

SELECT *
FROM Silver.MedicalStock

SELECT *
FROM Silver.MedicalTest

SELECT *
FROM Silver.PatientTest

SELECT *
FROM Silver.SatisfactionScore

SELECT *
FROM Silver.Staff

SELECT *
FROM Silver.Supplier

SELECT *
FROM Silver.medicine_patient

/******************************************************************************/
SELECT *
FROM Gold.Agg_BedOccupancy

SELECT *
FROM Gold.Agg_DoctorPerformance

SELECT *
FROM Gold.Agg_MonthlyRevenue

SELECT *
FROM Gold.Dim_Bed

SELECT *
FROM Gold.Dim_Date

SELECT *
FROM Gold.Dim_Department

SELECT *
FROM Gold.Dim_Doctor

SELECT *
FROM Gold.Dim_Medicine

SELECT *
FROM Gold.Dim_Patient

SELECT *
FROM Gold.Dim_PaymentMethod

SELECT *
FROM Gold.Dim_Room

SELECT *
FROM Gold.Dim_Supplier

SELECT *
FROM Gold.Dim_Test

SELECT *
FROM Gold.Fact_Admissions

SELECT *
FROM Gold.Fact_Appointments

SELECT *
FROM Gold.Fact_Billing

SELECT *
FROM Gold.Fact_MedicinePurchases

SELECT *
FROM Gold.Fact_PatientStay

SELECT *
FROM Gold.Fact_PatientVitals

SELECT *
FROM Gold.Fact_Tests

/******************************************************************************/
SELECT *
FROM Gold.Dim_Date

SELECT *
FROM Gold.Dim_Patient

SELECT *
FROM Gold.Dim_Department

SELECT *
FROM Gold.Dim_Doctor

SELECT *
FROM Gold.Dim_PaymentMethod

/******************************************************************************/
SELECT *
FROM Gold.Fact_Appointments

SELECT *
FROM Gold.Fact_Admissions

SELECT *
FROM Gold.Fact_PatientVitals

/******************************************************************************/
SELECT *
FROM Gold.Dim_Bed

SELECT *
FROM Gold.Dim_Room

SELECT *
FROM Gold.Fact_PatientStay


select * from gold.dim_surgery
select * from gold.pbi_appointment

SELECT *
FROM gold.pbi_tests

/*   only eRror table data   */
SELECT *
FROM silver_error.PatientTest
WHERE patient_id NOT IN (
		SELECT patient_id
		FROM silver.Patient
		)

SELECT *
FROM silver_error.PatientTest
WHERE doctor_id NOT IN (
		SELECT doctor_id
		FROM silver.Doctor
		)

SELECT *
FROM silver_error.PatientTest
WHERE test_id NOT IN (
		SELECT test_id
		FROM silver.MedicalTest
		)
