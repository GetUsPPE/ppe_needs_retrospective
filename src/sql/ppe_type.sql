WITH requests_per_month AS 
(
   SELECT
      date_trunc(CAST(datecreated AS DATE), MONTH) TIME,
      COUNT(id) total_requests 
   FROM
      gateway.request 
   WHERE
      datecreated IS NOT NULL 
   GROUP BY
      TIME 
   ORDER BY
      TIME 
)
,
request_count_by_type AS 
(
   SELECT
      e.name,
      date_trunc(CAST(r.datecreated AS DATE), MONTH) AS TIME,
      COUNT(re.weeklyrequestqty) AS num_requests 
   FROM
      gateway.requestequipment AS re 
      JOIN
         gateway.equipment AS e 
         ON re.equipmentid = e.id 
      JOIN
         gateway.request AS r 
         ON re.requestid = r.id 
   WHERE
      re.weeklyrequestqty > 0 
      AND re.weeklyrequestqty <= 50000      -- filtering out requests that seem much too big
      AND r.datecreated IS NOT NULL 
   GROUP BY
      TIME,
      name 
   ORDER BY
      name,
      TIME 
)
SELECT
   request_count_by_type.*,
   requests_per_month.total_requests,
   round((num_requests / total_requests) * 100, 1) || '%' requests_normalized 
FROM
   requests_per_month 
   JOIN
      request_count_by_type 
      ON request_count_by_type.TIME = requests_per_month.TIME 
   UNION ALL
   SELECT
      "Total Requests" AS name,
      TIME,
      total_requests AS num_requests,
      total_requests,
      "100 % " AS requests_normalized 
   FROM
      requests_per_month 
   WHERE
      TIME > '2020-03-30' 
   ORDER BY
      name,
      TIME