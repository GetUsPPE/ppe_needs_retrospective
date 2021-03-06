SELECT
   date_trunc(CAST(r.datecreated AS DATE), MONTH) AS TIME,
   f.county,
   f.stateprovince,
   COUNT(r.id) AS num_requests 
FROM
   gateway.request r 
   JOIN
      gateway.facility f 
      ON r.facilityid = f.id 
WHERE
   r.datecreated IS NOT NULL 
   AND f.county IS NOT NULL 
   -- remove facilities that were 'merged' as they are not unique facilities and a new facility row was created on merge
   AND f.mergedintofacilityid is null
GROUP BY
   f.stateprovince,
   f.county,
   TIME 
ORDER BY
   TIME ASC,
   f.stateprovince,
   f.county ASC