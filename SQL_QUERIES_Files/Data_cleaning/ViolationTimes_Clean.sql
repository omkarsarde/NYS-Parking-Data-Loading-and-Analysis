-- This file to synchronize all values of violation times to 12 hour format

-- select *
-- from ParkingViolations.parkingviolation
-- where violationTime > '13' and violationTime < '24' and violationTime not like '%P' and violationTime not like '%A';
SET SQL_SAFE_UPDATES = 0;
--
select *
from ParkingViolations.parkingviolation
where violationTime  like '00%'; 
-- and violationTime like '%P'


-- ADD P to the violationTime grater than 13
update ParkingViolations.parkingviolation
set violationTime = concat(violationTime,'P')
where violationTime > '13' and violationTime < '24' and violationTime not like '%P' and violationTime not like '%A';

update ParkingViolations.parkingviolation
set violationTime = replace(violationTime, '13','01')
where violationTime like '13%';

update ParkingViolations.parkingviolation
set violationTime = replace(violationTime, '14','02')
where violationTime like '14%';

update ParkingViolations.parkingviolation
set violationTime = replace(violationTime, '15','03')
where violationTime like '15%';

update ParkingViolations.parkingviolation
set violationTime = replace(violationTime, '16','04')
where violationTime like '16%';

update ParkingViolations.parkingviolation
set violationTime = replace(violationTime, '17','05')
where violationTime like '17%';

update ParkingViolations.parkingviolation
set violationTime = replace(violationTime, '18','06')
where violationTime like '18%';

update ParkingViolations.parkingviolation
set violationTime = replace(violationTime, '19','07')
where violationTime like '19%';

update ParkingViolations.parkingviolation
set violationTime = replace(violationTime, '20','08')
where violationTime like '20%';

update ParkingViolations.parkingviolation
set violationTime = replace(violationTime, '21','09')
where violationTime like '21%';

update ParkingViolations.parkingviolation
set violationTime = replace(violationTime, '22','10')
where violationTime like '22%';

update ParkingViolations.parkingviolation
set violationTime = replace(violationTime, '23','11')
where violationTime like '23%';

select *
from ParkingViolations.parkingviolation
where violationTime > '13';

-- select violationTime , concat(MOD(substring(violationTime,1,2),12), substring(violationTime,3,3))
-- from ParkingViolations.parkingviolation
-- where violationTime >'24' and MOD(substring(violationTime,1,2),12) >= 10 ;

-- select violationTime , concat('0',MOD(substring(violationTime,1,2),12), substring(violationTime,3,3))
-- from ParkingViolations.parkingviolation
-- where violationTime >'24' and MOD(substring(violationTime,1,2),12) < 10 ;


update ParkingViolations.parkingviolation
set violationTime = concat(MOD(substring(violationTime,1,2),12),substring(violationTime,3,3))
where violationTime >'24' and MOD(substring(violationTime,1,2),12) >= 10 ;

update ParkingViolations.parkingviolation
set violationTime = concat('0',MOD(substring(violationTime,1,2),12), substring(violationTime,3,3))
where violationTime >'24' and MOD(substring(violationTime,1,2),12) < 10 ;

update ParkingViolations.parkingviolation
set violationTime = replace(violationTime, '00','12')
where violationTime like '00%'




