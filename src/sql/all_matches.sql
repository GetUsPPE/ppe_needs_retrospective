select  fm.matchkey, ed.donatorkey as donorkey, ef.facilitykey, fm.matchstatus, fm.matchsubstatus, fm.datecreated as matchCreated, fm.match_closed_date as closedOrDelivered, le.enumcode, fme.qty
from `getusppe.gateway.match` fm
inner join `getusppe.gateway.matchequipment` fme on fm.id = fme.matchid
inner join gateway.facility ef on ef.id = fm.facilityid
inner join `getusppe.gateway.donationequipment` tde on tde.id = fme.donationequipmentid
inner join gateway.equipment le on le.id = tde.equipmentid
inner join gateway.donator ed on ed.id = fm.donatorid
order by facilitykey, matchkey