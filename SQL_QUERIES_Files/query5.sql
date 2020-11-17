
-- continuation to query 4 .. which are the most occurring violation codes in the 5 streets

select streetname, violationCode, count(violationcode) as count from parkingviolation
where streetname in ('BROADWAY', '3 AVE', 'LEXINGTON AVE', 'MADISON AVE', '3RD AVE')
group by streetName;