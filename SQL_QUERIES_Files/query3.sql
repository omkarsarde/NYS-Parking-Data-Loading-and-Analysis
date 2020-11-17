-- count no of violations per car(plateId, registrationState) and the plate Type
-- Cannot do this analysis -- ETHICAL ISSUES

-- SELECT count(summonsId) as count, vehicleinfo.plateID, vehicleinfo.registrationState, vehicleinfo.plateType FROM parkingviolation
-- join vehicleinfo on vehicleinfo.plateID = parkingviolation.vehiclePlateNumber
-- and vehicleinfo.registrationState = parkingviolation.vehicleRegistrationState
-- GROUP BY vehicleinfo.plateType
-- ORDER BY count desc;