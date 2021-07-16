select name, cast(totalRequested as int64) , month
from (
    select name, sum(qty) totalRequested, mo as month, row_number()  over (partition by mo order by sum(qty) desc) rnk
    from (
        select le.name, tre.weeklyRequestQty qty, date_trunc(tr.datecreated, MONTH) mo
        from gateway.request tr
        inner join gateway.requestequipment tre on tre.requestId = tr.id and case when tre.equipmentID = 7 then tre.weeklyRequestQty <= 5000 else tre.weeklyRequestQty <= 50000 end
        inner join gateway.equipment le on le.id = tre.equipmentid
        where tr.dateCreated > '2020-07-01'
    ) dat
group by name, mo
) dat2
where rnk = 1
order by month