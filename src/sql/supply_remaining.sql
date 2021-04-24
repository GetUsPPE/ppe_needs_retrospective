WITH remaining AS 
(
   SELECT
      r.id AS r_id,
      r.datecreated,
      f.stateprovince,
      f.postcode,
      e.name AS equipment_type,
      CASE
         WHEN
            re.supplyremaining = 'no' 
            AND re.supplyremaining IS NOT NULL 
         THEN
            '0 Days' 
         ELSE
            CASE
               WHEN
                  re.supplyremaining IN 
                  (
                     '< 1' 
                  )
               THEN
                  '<= 7 Days' 
               ELSE
                  '> 7 Days' 
            END
      END
      AS supply 
   FROM
      gateway.request r 
      LEFT JOIN
         `gateway.facility` f 
         ON f.id = r.facilityid 
      LEFT JOIN
         `gateway.requestequipment` re 
         ON r.id = re.requestid 
      LEFT JOIN
         `gateway.equipment` e 
         ON re.equipmentid = e.id 
   WHERE
      r.datecreated IS NOT NULL 
      AND r.datecreated >= '2020-04-01' 
      AND re.supplyremaining IS NOT NULL 
)
, total_requests_per_month AS 
(
   SELECT
      date_trunc(CAST(datecreated AS DATE), MONTH) MONTH,
      COUNT(id) total_requests 
   FROM
      gateway.request 
   WHERE
      datecreated IS NOT NULL 
   GROUP BY
      MONTH 
   ORDER BY
      MONTH 
)
,
supply_remaining_by_month AS 
(
   SELECT
      date_trunc(CAST(datecreated AS DATE), MONTH) AS MONTH,
      equipment_type,
      supply,
      COUNT(*) AS num_requested_types,
   FROM
      remaining 
   WHERE
      equipment_type != '' 
   GROUP BY
      1,
      2,
      3 
   ORDER BY
      1,
      2,
      3 
)
SELECT
   srbm.*,
   total_requests,
   100 * num_requested_types / total_requests AS pct_requests 
FROM
   supply_remaining_by_month AS srbm 
   JOIN
      total_requests_per_month AS trpm 
      ON srbm.MONTH = trpm.MONTH 
ORDER BY
   MONTH,
   equipment_type,
   supply