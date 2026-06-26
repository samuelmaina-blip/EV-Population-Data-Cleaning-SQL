-- SQL PROJECT

-- STAGE 1: Create a staging Table


select *
from  electric_vehicle_population_data evpd ;

create table vehicle_population_staging
as
select *
from  electric_vehicle_population_data evpd;

select *
from vehicle_population_staging vps;

-- STAGE 2: Check and remove Duplicates

select *
from vehicle_population_staging vps ;

with cte_duplicates 
as 
(select county, row_number()over (partition by `VIN (1-10)`,county,city,state,`Postal Code`,`Model Year`,make,model,`Electric Vehicle Type`,`Clean Alternative Fuel Vehicle (CAFV) Eligibility`,`Electric Range`,`Base MSRP`,`Legislative District`,`DOL Vehicle ID`,`Vehicle Location`,`Electric Utility`,`2020 Census Tract`
order by `model year`)as row_num
from vehicle_population_staging vps )
select *
from cte_duplicates 
where row_num > 1
order by cte_duplicates.row_num desc;

-- no duplicates found

-- STAGE 3: Standrdize the Data

select *
from vehicle_population_staging vps ;

select distinct (county)
from vehicle_population_staging vps
order by county desc;

select distinct (city)
from vehicle_population_staging vps
order by city desc;

select distinct (state)
from vehicle_population_staging vps
order by state desc;

alter table vehicle_population_staging 
add column `State_Name` varchar(100) after state;

select `State_Name` 
from vehicle_population_staging vps;

update vehicle_population_staging 
SET `State_Name` = CASE state
    WHEN 'ak' THEN 'Alaska'
    WHEN 'al' THEN 'Alabama'
    WHEN 'ap' THEN 'Armed Forces Pacific'
    WHEN 'ar' THEN 'Arkansas'
    WHEN 'az' THEN 'Arizona'
    WHEN 'bc' THEN 'British Columbia'
    WHEN 'ca' THEN 'California'
    WHEN 'co' THEN 'Colorado'
    WHEN 'ct' THEN 'Connecticut'
    WHEN 'dc' THEN 'District of Columbia'
    WHEN 'de' THEN 'Delaware'
    WHEN 'fl' THEN 'Florida'
    WHEN 'ga' THEN 'Georgia'
    WHEN 'hi' THEN 'Hawaii'
    WHEN 'id' THEN 'Idaho'
    WHEN 'il' THEN 'Illinois'
    WHEN 'in' THEN 'Indiana'
    WHEN 'ks' THEN 'Kansas'
    WHEN 'ky' THEN 'Kentucky'
    WHEN 'la' THEN 'Louisiana'
    WHEN 'ma' THEN 'Massachusetts'
    WHEN 'md' THEN 'Maryland'
    WHEN 'mn' THEN 'Minnesota'
    WHEN 'mo' THEN 'Missouri'
    WHEN 'ms' THEN 'Mississippi'
    WHEN 'mt' THEN 'Montana'
    WHEN 'nc' THEN 'North Carolina'
    WHEN 'ne' THEN 'Nebraska'
    WHEN 'nh' THEN 'New Hampshire'
    WHEN 'nj' THEN 'New Jersey'
    WHEN 'nv' THEN 'Nevada'
    WHEN 'ny' THEN 'New York'
    WHEN 'oh' THEN 'Ohio'
    WHEN 'or' THEN 'Oregon'
    WHEN 'pa' THEN 'Pennsylvania'
    WHEN 'sc' THEN 'South Carolina'
    WHEN 'tx' THEN 'Texas'
    WHEN 'ut' THEN 'Utah'
    WHEN 'va' THEN 'Virginia'
    WHEN 'wa' THEN 'Washington'
    WHEN 'wy' THEN 'Wyoming'
    ELSE state 
END;

select distinct (`State_Name`)
from vehicle_population_staging vps; 

select distinct (`postal code`)
from vehicle_population_staging vps
order by `postal code` desc;

select distinct (`model year`)
from vehicle_population_staging vps
order by `model year` desc;

select distinct (make)
from vehicle_population_staging vps
order by make desc;


select distinct (model)
from vehicle_population_staging vps
order by model desc;

select distinct (vps.`Electric Vehicle Type` )
from vehicle_population_staging vps
order by vps.`Electric Vehicle Type`  desc;

select distinct (vps.`Clean Alternative Fuel Vehicle (CAFV) Eligibility` )
from vehicle_population_staging vps
order by vps.`Clean Alternative Fuel Vehicle (CAFV) Eligibility`  desc;

select distinct (`DOL Vehicle ID`  )
from vehicle_population_staging vps
order by vps.`DOL Vehicle ID`   desc;

SELECT `DOL Vehicle ID` 
FROM electric_vehicle_population_data 
WHERE `DOL Vehicle ID` LIKE '%,%';

select *
from vehicle_population_staging vps ; -- select the table to view the changes

-- STAGE 4: Check for Nulls and Blank Rows and Columns and Remove them

select  *
from electric_vehicle_population_data evpd ;

SELECT * FROM vehicle_population_staging vps 
WHERE (`DOL Vehicle ID` IS NULL OR `DOL Vehicle ID` = '')
  AND (county IS NULL OR county = '')
  AND (city IS NULL OR city = '')
  AND (state IS NULL OR state = '')
  AND (`Postal Code` IS NULL OR `Postal Code` = '')
  AND (make IS NULL OR make = '')
  AND (model IS NULL OR model = '')
  AND (`Electric Utility` IS NULL OR `Electric Utility` = ''); -- check for empty rows
 
 SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN `DOL Vehicle ID` IS NULL OR `DOL Vehicle ID` = '' THEN 1 ELSE 0 END) AS blank_ids,
    SUM(CASE WHEN county IS NULL OR county = '' THEN 1 ELSE 0 END) AS blank_counties,
    SUM(CASE WHEN city IS NULL OR city = '' THEN 1 ELSE 0 END) AS blank_cities,
    SUM(CASE WHEN state IS NULL OR state = '' THEN 1 ELSE 0 END) AS blank_states,
    SUM(CASE WHEN `Postal Code` IS NULL OR `Postal Code` = '' THEN 1 ELSE 0 END) AS blank_postal_codes,
    SUM(CASE WHEN make IS NULL OR make = '' THEN 1 ELSE 0 END) AS blank_makes,
    SUM(CASE WHEN model IS NULL OR model = '' THEN 1 ELSE 0 END) AS blank_models,
    SUM(CASE WHEN `Legislative District` IS NULL OR `Legislative District` = '' THEN 1 ELSE 0 END) AS blank_districts,
    SUM(CASE WHEN `Electric Utility` IS NULL OR `Electric Utility` = '' THEN 1 ELSE 0 END) AS blank_utilities
FROM vehicle_population_staging; -- check for nulls and blanks

UPDATE vehicle_population_staging
SET `Legislative District` = 0
WHERE `Legislative District` IS NULL;

ALTER TABLE vehicle_population_staging 
MODIFY COLUMN `Legislative District` VARCHAR(50);

SELECT `Legislative District`, COUNT(*) 
FROM vehicle_population_staging
GROUP BY `Legislative District`
ORDER BY COUNT(*) DESC;

SELECT `Legislative District`, COUNT(*)
FROM vehicle_population_staging
WHERE `Legislative District`  = 'Non-WA'
GROUP BY `Legislative District`;

select distinct `Legislative District`
from vehicle_population_staging vps;

UPDATE vehicle_population_staging
SET `Electric Utility` = 'Non-WA'
WHERE `Electric Utility` IS NULL OR `Electric Utility` = '';

select distinct `Electric Utility`
from vehicle_population_staging vps;


UPDATE vehicle_population_staging 
SET city = 'Unknown' 
WHERE city IS NULL OR city = '';

-- Clean up missing counties
UPDATE vehicle_population_staging 
SET county = 'Unknown' 
WHERE county IS NULL OR county = '';

UPDATE vehicle_population_staging 
SET `Postal Code` = 'Unknown' 
WHERE `Postal Code` IS NULL OR `Postal Code` = '';

select *
from vehicle_population_staging vps;



