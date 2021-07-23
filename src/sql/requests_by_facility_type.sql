select ef.facilityKey, tr.requestKey, le.enumcode as equipmentEnum, tre.weeklyrequestqty, lsl.name as practicesAnyPolicies, tre.supplyremaining, tr.datecreated, ld.name as dataSource, ef.stateprovince, lft.enumcode as facilityTypeEnum
from gateway.request tr 
inner join gateway.requestequipment tre on tr.id = tre.requestId and case when tre.equipmentID = 7 then tre.weeklyRequestQty <= 5000 else tre.weeklyRequestQty <= 50000 end
inner join gateway.equipment le on le.id = tre.equipmentid
inner join gateway.facility ef on ef.id = tr.facilityId and ef.mergedintofacilityid is null
inner join `getusppe.gateway.facilitytype` lft on lft.id = ef.facilityTypeId
left outer join `getusppe.gateway.surgelevel` lsl on lsl.id = tre.surgelevelid
left outer join `getusppe.gateway.datasource` ld on ld.id = tr.datasourceid
