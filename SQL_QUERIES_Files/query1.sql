-- count of violations per violation code

SELECT count(summonsID) as count, violationCode.violationCode, violationcode.violationDefinition FROM parkingviolation 
join violationcode on violationCode.violationCode = parkingviolation.violationCode 
GROUP BY violationCode.violationCode 
ORDER BY count desc;