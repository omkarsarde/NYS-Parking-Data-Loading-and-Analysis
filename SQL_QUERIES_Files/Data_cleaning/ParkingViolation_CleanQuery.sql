-- This file is to clean parkingviolation table of some mismatched data in columns
-- Execute this script before VehicleInfo_CleanQuery
select * from ParkingViolations.parkingviolation 
where length(vehicleRegistrationState)>2;

-- drop foreign key on parkingviolation table to update the columns 
alter table ParkingViolations.parkingviolation
drop foreign key FK_violation_vehicle_plate_state;

update ParkingViolations.parkingviolation
set vehicleRegistrationState='NY', vehiclePlateNumber=";;000;;"
where vehiclePlateNumber='"' and vehicleRegistrationState=';;000;;"';

update ParkingViolations.parkingviolation
set vehicleRegistrationState='MA', vehiclePlateNumber='1JM792"'
where vehiclePlateNumber='"1J' and vehicleRegistrationState='M792"';

update ParkingViolations.parkingviolation
set vehicleRegistrationState='NY', vehiclePlateNumber='23511MG'
where vehiclePlateNumber='"23511' and vehicleRegistrationState='MG"';

update ParkingViolations.parkingviolation
set vehicleRegistrationState='FL', vehiclePlateNumber='506CG'
where vehiclePlateNumber='"506' and vehicleRegistrationState='CG"';

update ParkingViolations.parkingviolation
set vehicleRegistrationState='NY', vehiclePlateNumber='53629MM'
where vehiclePlateNumber='"53629' and vehicleRegistrationState= 'MM"';

update ParkingViolations.parkingviolation
set vehicleRegistrationState='CA', vehiclePlateNumber='7FVD528'
where vehiclePlateNumber='"7F' and vehicleRegistrationState='VD528"';

update ParkingViolations.parkingviolation
set vehicleRegistrationState='FL', vehiclePlateNumber='BH1543'
where vehiclePlateNumber= '"B'and vehicleRegistrationState='H1543"';


update ParkingViolations.parkingviolation
set vehicleRegistrationState='', vehiclePlateNumber='CW7550"'
where vehiclePlateNumber= '"C'and vehicleRegistrationState='W7550"';

update ParkingViolations.parkingviolation
set vehicleRegistrationState='NY', vehiclePlateNumber='GZF7326'
where vehiclePlateNumber='"G' and vehicleRegistrationState='ZF7326"';

update ParkingViolations.parkingviolation
set vehicleRegistrationState='NY', vehiclePlateNumber='HA8286'
where vehiclePlateNumber='"H' and vehicleRegistrationState='A8286"';

update ParkingViolations.parkingviolation
set vehicleRegistrationState='NY', vehiclePlateNumber='HN2829'
where vehiclePlateNumber='"H' and vehicleRegistrationState='N2829"';

update ParkingViolations.parkingviolation
set vehicleRegistrationState='PA', vehiclePlateNumber='JA27581'
where vehiclePlateNumber='"J' and vehicleRegistrationState='A27581"';

update ParkingViolations.parkingviolation
set vehicleRegistrationState='PA', vehiclePlateNumber='JLG5305'
where vehiclePlateNumber='"J' and vehicleRegistrationState='LG5305"';

update ParkingViolations.parkingviolation
set vehicleRegistrationState='PA', vehiclePlateNumber='K3491'
where vehiclePlateNumber='"KH' and vehicleRegistrationState='K3491"';

update ParkingViolations.parkingviolation
set vehicleRegistrationState='RI', vehiclePlateNumber='L509'
where vehiclePlateNumber='"L' and vehicleRegistrationState='509"';

update ParkingViolations.parkingviolation
set vehicleRegistrationState='SC', vehiclePlateNumber='H12]'
where vehiclePlateNumber='"M' and vehicleRegistrationState='H12]"';

update ParkingViolations.parkingviolation
set vehicleRegistrationState='NY', vehiclePlateNumber='7IU'
where vehiclePlateNumber='"ML8' and vehicleRegistrationState='7IU"';

update ParkingViolations.parkingviolation
set vehicleRegistrationState='CT', vehiclePlateNumber='EM8'
where vehiclePlateNumber='"NE' and vehicleRegistrationState='EM8"';

update ParkingViolations.parkingviolation
set vehicleRegistrationState='CT', vehiclePlateNumber='OAVH1"'
where vehiclePlateNumber='"OAV' and vehicleRegistrationState='H1"';

update ParkingViolations.parkingviolation
set vehicleRegistrationState='NJ', vehiclePlateNumber='XM734U'
where vehiclePlateNumber='"X' and vehicleRegistrationState='M734U"';

update ParkingViolations.parkingviolation
set vehicleRegistrationState='NJ', vehiclePlateNumber='XCMA58'
where vehiclePlateNumber='"XC' and vehicleRegistrationState='MA58"';