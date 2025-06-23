Select p.name as patient, d.name  as doctor , a.schedule as appointment, A.STATUS ,p.patient_id , d.doctor_id , a.doctor_skey , a.patient_skey,
CASE 
WHEN A.STATUS = 'completed' THEN 'https://i.ibb.co/21TdtTgh/check.png'
WHEN A.STATUS = 'scheduled' tHEN 'https://i.ibb.co/Lz2KHf4Q/calendar.png'
END AS IMAGE_PATH
into gold.pbi_appointment
from gold.Fact_Appointments a
inner join gold.Dim_Doctor d on d.doctor_skey = a.doctor_skey
inner join gold.Dim_Patient p on a.patient_skey = p.patient_skey

sELECT a.rating , a.feedback , d.doctor_skey ,p.patient_skey ,d.doctor_id , p.patient_id ,d.name as doctor , p.name as patient 
--into gold.pbi_rating
FROM GOLD.Fact_SatisfactionScore A 
right join gold.Dim_Doctor d on d.doctor_skey = a.doctor_skey
right join gold.Dim_Patient p on a.patient_skey = p.patient_skey

Select * from silver.Doctor

Select  d.doctor_skey  ,d.doctor_id , p.patient_id ,d.name as doctor , p.name as patient ,P.image_path as image,B.*
INTO GOLD.PBI_BILL
from gold.FACT_BILLING b

JOIN GOLD.Fact_Appointments A ON A.patient_skey = B.patient_skey
 join gold.Dim_Doctor d on d.doctor_skey = a.doctor_skey
 join gold.Dim_Patient p on a.patient_skey = p.patient_skey
