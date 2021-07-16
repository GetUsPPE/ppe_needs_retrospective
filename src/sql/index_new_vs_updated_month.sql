select dat.month, count(*) as total, count(case when rnk = 1 then 1 else null end) as newRequests, count(case when rnk > 1 then 1 else null end) as updatedRequests 
from (
    select tr.facilityid,  row_number () over (partition by tr.facilityId order by tr.dateCreated) as rnk,
    date_trunc(cast(tr.datecreated AS date), MONTH) AS month
    from gateway.request tr
) dat
group by dat.month
order by dat.month
