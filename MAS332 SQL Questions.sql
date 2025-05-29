





USE chicago;
with allcrimes as (
    select * from crime1
    union
    select * from crime2
    union
    select * from crime3
    union
    select * from crime4
    union
    select * from crime5
    union
    select * from crime6
    union
    select * from crime7
    union
    select * from crime8
    union
    select * from crime9)
select *
from allcrimes;
select *
from crime_type ct;

/* Question 1: Report each crime in March and the number of times each occurred. Order the results high to low based on frequency. */

select ct.crime, count(*) as 'Number of Occurences'
from crime3 c
join crime_type ct on ct.crime_type_id = c.crime_type_id
group by 1
order by count(*) desc;

/* Question 2: How many BURGLARY crimes committed in March resulted in an arrest? */

select ct.crime, count(c.id) as 'Number of Arrests'
from crime3 c
join crime_type ct on ct.crime_type_id = c.crime_type_id
where c.arrest = 'true' and ct.crime = 'BURGLARY'
group by 1;

/* Question 3: How many BURGLARY crimes committed in the first quarter of the year (January, February, March) resulted in an arrest? */

select count(*) as 'Total Burglary Crimes Resulting in Arrest'
from (
    select * from crime1
    union
    select * from crime2
    union
    select * from crime3
) as fqcrimes
join crime_type ct on ct.crime_type_id = fqcrimes.crime_type_id
where fqcrimes.arrest = 'true' and crime = 'BURGLARY';

/* Question 4: What percent of BURGLARY crimes committed in the first Quarter of the year resulted in an arrest? Return a table that includes the number of BURGLARY crimes and the % resulting in an arrest */

with fqcrimes as (
    select * from crime1
    union
    select * from crime2
    union
    select * from crime3)
select count(*) as 'Total Burglary Crimes', concat(format(100*(select count(*) from fqcrimes where crime_type_id = '4' and arrest = 'true')/count(*), 2), '%') as 'Percentage Resulting in Arrests'
from fqcrimes a
join crime_type ct on ct.crime_type_id = a.crime_type_id
where ct.crime = 'BURGLARY';

/* Question 5: Return crime, date, address, and arrest columns for all BURGLARY, THEFT, and ASSAULT crimes that resulted in an arrest in March. Order results by crime type and date. */

select ct.crime, c.date, c.address, c.arrest
from crime3 c
join crime_type ct on ct.crime_type_id = c.crime_type_id
where ct.crime in ('BURGLARY', 'THEFT', 'ASSAULT') and arrest = 'true'
order by ct.crime, c.date asc;

/* Question 6: What are the most common crimes committed on Michigan Ave? Return a table that lists the crime and frequency for all crimes that have occurred on Michigan Ave, ordered high to low by frequency*/

with allcrimes as (
    select * from crime1
    union
    select * from crime2
    union
    select * from crime3
    union
    select * from crime4
    union
    select * from crime5
    union
    select * from crime6
    union
    select * from crime7
    union
    select * from crime8
    union
    select * from crime9)
select ct.crime, concat(format(100*count(*)/(select count(*) from allcrimes where address like '%MICHIGAN AVE'), 2), '%') as 'Percentage of Crimes Occurred on Michigan Avenue'
from allcrimes a
join crime_type ct on ct.crime_type_id = a.crime_type_id
where a.address like '%MICHIGAN AVE'
group by 1
order by 100*count(*)/(select count(*) from allcrimes where address like '%MICHIGAN AVE') desc;

/* Question 7: Do more crimes occur on North (N) or South (S) Michigan Ave? Return a table that shows the number of crimes separately for North and South Michigan Ave. */

with allcrimes as (
    select * from crime1
    union
    select * from crime2
    union
    select * from crime3
    union
    select * from crime4
    union
    select * from crime5
    union
    select * from crime6
    union
    select * from crime7
    union
    select * from crime8
    union
    select * from crime9)
select
   case 
   	  when address like '%N MICHIGAN AVE' then 'North Michigan'
   	  when address like '%S MICHIGAN AVE' then 'South Michigan'
   end as 'North or South Michigan',
count(*) as 'Number of Crimes'
from allcrimes
where address like '%N MICHIGAN AVE' or address like '%S MICHIGAN AVE'
group by 1
	
/* Question 8: Report the most common crime in 2024 for each location */

with allcrimes as (
    select * from crime1
    union
    select * from crime2
    union
    select * from crime3
    union
    select * from crime4
    union
    select * from crime5
    union
    select * from crime6
    union
    select * from crime7
    union
    select * from crime8
    union
    select * from crime9),
crime_counts as 
    (select l.location, ct.crime, count(*) as NumberofCrimeOccurrences
    from allcrimes a
    join location l on l.location_id = a.location_id
    join crime_type ct on ct.crime_type_id = a.crime_type_id
    group by 1, 2)
select cc.location, cc.crime, cc.NumberofCrimeOccurrences as 'Number of Crime Occurrences'
from crime_counts cc
join 
    (select location, max(NumberofCrimeOccurrences) as max_count  
     from crime_counts
     group by location) as max_counts 
on cc.location = max_counts.location 
and cc.NumberofCrimeOccurrences = max_counts.max_count;

/* Question 9: Report the arrest rate by month for January, February, and March. Please format this rate as a percentage rounded to 1 or 2 decimals. */

with fqcrimes as
(select * from crime1
union
select * from crime2 
union
select * from crime3),
arrestcount as (
select 
    case 
    	when date like '2024-01-%' then 'January'
    	when date like '2024-02-%' then 'February'
    	when date like '2024-03-%' then 'March'
    end as month,
count(*) as 'NumberofArrests'
from fqcrimes
where arrest = 'true'
group by 1),
totalcrimecount as (select 
    case 
    	when date like '2024-01-%' then 'January'
    	when date like '2024-02-%' then 'February'
    	when date like '2024-03-%' then 'March'
    end as month,
count(*) as 'Numberofcrimes'
from fqcrimes
group by 1)
select ac.month as 'Month', concat(format(100*ac.NumberofArrests/tc.NumberofCrimes, 2), '%') as 'Arrest Percentage'
from arrestcount ac
join totalcrimecount tc on ac.month = tc.`month` 
group by 1;






























