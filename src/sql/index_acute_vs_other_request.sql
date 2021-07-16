select sum(case when enumcode = 'acute_care' then 1 else 0 end) as acuteRequest, sum(case when enumcode = 'acute_care' then 0 else 1 end) as otherRequest, count(*) as totalRequests
from gateway.facility ef
inner join gateway.facilitytype eft on ef.facilityTYpeId = eft.id
where ef.id in (
	select distinct ef.id
	from gateway.request tr
	inner join gateway.facility ef on tr.facilityId = ef.id
	inner join gateway.facilitytype eft on eft.id = ef.facilityTypeId
	where tr.dateCreated > '2020-07-01'
	)
