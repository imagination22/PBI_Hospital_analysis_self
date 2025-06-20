CREATE VIEW vw_beds_info
AS
SELECT count(be.bed_id) AS beds
	,ro.room_type AS room_type
	,be.current_status AS status
	,ro.room_id AS room_id
FROM (
	bronze.bed be LEFT JOIN bronze.room ro ON ((ro.room_id = be.room_id))
	)
GROUP BY ro.room_type
	,be.current_status
	,ro.room_id;
