WITH hospitals_map AS 
(
   SELECT
      f.id,
      CASE
         WHEN
            f.Facilitytypeid IN 
            (
               34,
               43,
               70
            )
         THEN
            'hospital' 
         ELSE
            'non-hospital' 
      END
      AS is_hospital 
   FROM
      gateway.request r 
      INNER JOIN
         `gateway.facility` f 
         ON f.id = r.facilityid 
        INNER JOIN
         `gateway.facilitytype` ft 
         ON f.facilitytypeid = ft.id 
   WHERE
      -- remove merged facilities - a new facility row was created on merge
      f.mergedintofacilityid is null
)
, requests_per_month AS 
(
   SELECT
      date_trunc(CAST(r.datecreated AS DATE), MONTH) MONTH,
      COUNT(r.id) total_requests 
   FROM
      gateway.request r 
      INNER JOIN
         gateway.facility f 
         ON r.facilityid = f.id 
   WHERE
      -- remove merged facilities - a new facility row was created on merge
      f.mergedintofacilityid is null
   GROUP BY
      MONTH 
   ORDER BY
      MONTH 
)
,
requests_by_facility_type AS 
(
   SELECT
      date_trunc(CAST(r.datecreated AS DATE), MONTH) MONTH,
      COUNT(DISTINCT(r.id)) AS request_count,
      hm.is_hospital,
   FROM
      gateway.request r 
      INNER JOIN
         gateway.facility f 
         ON r.facilityid = f.id 
      LEFT JOIN
         hospitals_map hm 
         ON hm.id = r.facilityid 

   WHERE
      -- remove merged facilities - a new facility row was created on merge
      f.mergedintofacilityid is null
   GROUP BY
      MONTH,
      hm.is_hospital 
   ORDER BY
      MONTH,
      hm.is_hospital 
)
SELECT
   requests_by_facility_type.*,
   requests_per_month.total_requests,
   (
      requests_by_facility_type.request_count / requests_per_month.total_requests
   )
   * 100 AS pct_requests 
FROM
   requests_by_facility_type 
   JOIN
      requests_per_month 
      ON requests_per_month.MONTH = requests_by_facility_type.MONTH 
ORDER BY
   MONTH,
   is_hospital;