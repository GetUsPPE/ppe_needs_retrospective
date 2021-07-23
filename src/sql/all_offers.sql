
select ed.donatorkey as donorKey, td.donationkey, le.enumcode as equipmentEnum, tde.qty, td.datecreated, lds.name as dataSource, ed.stateprovince
from gateway.donation td
inner join gateway.donator ed on ed.id = td.donatorid
inner join `getusppe.gateway.donationequipment` tde on tde.donationId = td.id
inner join `getusppe.gateway.equipment` le on le.id = tde.equipmentid
inner join gateway.datasource lds on lds.id = td.datasourceid