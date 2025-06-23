SELECT
    patient_skey,
    'Room Charges' AS charge_type,
    room_charges AS amount
	into gold.pivot_bill
FROM gold.Fact_Billing

UNION ALL

SELECT
    patient_skey,
    'Surgery Charges',
    surgery_charges
FROM gold.Fact_Billing

UNION ALL

SELECT
    patient_skey,
    'Medicine Charges',
    medicine_charges
FROM gold.Fact_Billing

UNION ALL

SELECT
    patient_skey,
    'Test Charges',
    test_charges
FROM gold.Fact_Billing

UNION ALL

SELECT
    patient_skey,
    'Doctor Fees',
    doctor_fees
FROM gold.Fact_Billing

UNION ALL

SELECT
    patient_skey,
    'Other Charges',
    other_charges
FROM gold.Fact_Billing;