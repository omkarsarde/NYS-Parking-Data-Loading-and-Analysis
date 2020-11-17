-- top 5 streets with most number of violations 

SELECT streetname, count(violationPrecinctId) as count 
FROM ParkingViolations.parkingViolation
GROUP BY streetname
order by count desc limit 5;