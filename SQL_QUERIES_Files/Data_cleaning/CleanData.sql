-- This file is to clean county names because same county is referred with multiple names. 
SET SQL_SAFE_UPDATES = 0;
-- Manhattan / New York County. - NY
-- Bronx / Bronx County.  - BX
-- Brooklyn / Kings County - K
-- Queens / Queens County. - Q
-- Staten Island / Richmond County. _ ST

update ParkingViolations.parkingviolation
set violationCounty = 'K'
where violationCounty='KINGS';

update ParkingViolations.parkingviolation
set violationCounty = 'Q'
where violationCounty='QN';

update ParkingViolations.parkingviolation
set violationCounty = 'NY'
where violationCounty='MN' ;

update ParkingViolations.parkingviolation
set violationCounty = 'K'
where violationCounty='BK' ;

update ParkingViolations.parkingviolation
set violationCounty = 'ST'
where violationCounty='R' ;

update ParkingViolations.parkingviolation
set violationCounty = 'Q'
where violationCounty='QUEEN';


update ParkingViolations.parkingviolation
set violationCounty = 'BX'
where violationCounty='BRONX';

update ParkingViolations.parkingviolation
set violationCounty = 'Q'
where violationCounty='QNS';
