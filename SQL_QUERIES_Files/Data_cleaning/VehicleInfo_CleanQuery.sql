-- This file is to clean vehicleInfo table of some mismatched data in columns
-- Execute this script after ParkingViolation_CleanQuery because of primary key and foreign key contraints between the tables

select * from ParkingViolations.vehicleInfo
where length(registrationState)>2;

alter table ParkingViolations.vehicleInfo
drop primary key;

-- VehicleInfo cleaning

SET SQL_SAFE_UPDATES = 0;
--
-- 

update ParkingViolations.vehicleInfo
set registrationState='NY', plateId=";;000;;"
where plateId='"' and registrationState=';;000;;"';

update ParkingViolations.vehicleInfo
set registrationState='MA', plateId='1JM792"'
where plateId='"1J' and registrationState='M792"';

update ParkingViolations.vehicleInfo
set registrationState='NY', plateId='23511MG'
where plateId='"23511' and registrationState='MG"';

update ParkingViolations.vehicleInfo
set registrationState='FL', plateId='506CG'
where plateId='"506' and registrationState='CG"';

update ParkingViolations.vehicleInfo
set registrationState='NY', plateId='53629MM'
where plateId='"53629' and registrationState= 'MM"';

update ParkingViolations.vehicleInfo
set registrationState='CA', plateId='7FVD528'
where plateId='"7F' and registrationState='VD528"';

update ParkingViolations.vehicleInfo
set registrationState='FL', plateId='BH1543'
where plateId= '"B'and registrationState='H1543"';


update ParkingViolations.vehicleInfo
set registrationState='', plateId='CW7550"'
where plateId= '"C'and registrationState='W7550"';

update ParkingViolations.vehicleInfo
set registrationState='NY', plateId='GZF7326'
where plateId='"G' and registrationState='ZF7326"';

update ParkingViolations.vehicleInfo
set registrationState='NY', plateId='HA8286'
where plateId='"H' and registrationState='A8286"';

update ParkingViolations.vehicleInfo
set registrationState='NY', plateId='HN2829'
where plateId='"H' and registrationState='N2829"';

update ParkingViolations.vehicleInfo
set registrationState='PA', plateId='JA27581'
where plateId='"J' and registrationState='A27581"';

update ParkingViolations.vehicleInfo
set registrationState='PA', plateId='JLG5305'
where plateId='"J' and registrationState='LG5305"';

update ParkingViolations.vehicleInfo
set registrationState='PA', plateId='K3491'
where plateId='"KH' and registrationState='K3491"';

update ParkingViolations.vehicleInfo
set registrationState='RI', plateId='L509'
where plateId='"L' and registrationState='509"';

update ParkingViolations.vehicleInfo
set registrationState='SC', plateId='H12]'
where plateId='"M' and registrationState='H12]"';

update ParkingViolations.vehicleInfo
set registrationState='NY', plateId='7IU'
where plateId='"ML8' and registrationState='7IU"';

update ParkingViolations.vehicleInfo
set registrationState='CT', plateId='EM8'
where plateId='"NE' and registrationState='EM8"';

update ParkingViolations.vehicleInfo
set registrationState='CT', plateId='OAVH1"'
where plateId='"OAV' and registrationState='H1"';

update ParkingViolations.vehicleInfo
set registrationState='NJ', plateId='XM734U'
where plateId='"X' and registrationState='M734U"';

update ParkingViolations.vehicleInfo
set registrationState='NJ', plateId='XCMA58'
where plateId='"XC' and registrationState='MA58"';


delete from ParkingViolations.vehicleInfo
where plateId = '53629MM' and registrationState='NY' and plateType='NY';

delete from ParkingViolations.vehicleInfo
-- select * from ParkingViolations.vehicleInfo
where plateId = '23511MG' and registrationState='NY' and plateType='NY';

delete from ParkingViolations.vehicleInfo
-- select * from ParkingViolations.vehicleInfo
where plateId = 'GZF7326' and registrationState='NY' and plateType='NY';

delete from ParkingViolations.vehicleInfo
-- select * from ParkingViolations.vehicleInfo
where plateId = '7FVD528' and registrationState='CA' and plateType='CA';

delete from ParkingViolations.vehicleInfo
-- select * from ParkingViolations.vehicleInfo
where plateId = 'XCMA58' and registrationState='NJ' and plateType='NJ';

delete from ParkingViolations.vehicleInfo
-- select * from ParkingViolations.vehicleInfo
where plateId = 'XM734U' and registrationState='NJ' and plateType='NJ';


-- add primary key on plateId and registrationState
ALTER TABLE ParkingViolations.vehicleInfo
add primary key (plateId,registrationState);

-- add foreign key to parkingviolation table after adding primary key on vehicleInfo table
ALTER TABLE ParkingViolations.parkingviolation
add constraint FK_violation_vehicle_plate_state  
foreign key (vehiclePlateNumber, vehicleRegistrationState) references vehicleInfo(plateId,registrationState);









