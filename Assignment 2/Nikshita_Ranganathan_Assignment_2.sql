-- Setting the specific database for executing queries
USE assignment;

-- Checking the dataset
SELECT * FROM bed_type;
SELECT * FROM bed_fact;
SELECT * FROM business;

-- 4a. 1) Top 10 Hospitals by Total Licensed Beds for ICU or SICU
SELECT b.business_name AS hospital_name, SUM(f.license_beds) AS total_license_beds
FROM bed_fact f
INNER JOIN business b ON f.ims_org_id = b.ims_org_id
WHERE f.bed_id IN (4, 15)
GROUP BY b.business_name
ORDER BY SUM(f.license_beds) DESC
LIMIT 10;

-- 4a. 2) Top 10 Hospitals by Total census Beds for ICU or SICU
SELECT b.business_name  AS hospital_name, SUM(f.census_beds) AS total_census_beds
FROM bed_fact f
INNER JOIN business b ON f.ims_org_id = b.ims_org_id
WHERE f.bed_id IN (4, 15)
GROUP BY b.business_name
ORDER BY SUM(f.census_beds) DESC
LIMIT 10;

-- 4a. 3) Top 10 Hospitals by Total staffed Beds for ICU or SICU
SELECT b.business_name AS hospital_name, SUM(f.staffed_beds) AS total_staffed_beds
FROM bed_fact f
INNER JOIN business b ON f.ims_org_id = b.ims_org_id
WHERE f.bed_id IN (4, 15)
GROUP BY b.business_name
ORDER BY SUM(f.staffed_beds) DESC
LIMIT 10;

-- 4b. Top one or two hospitals per list based on bed volume
(SELECT b.business_name AS hospital_name, SUM(f.license_beds) AS total_beds, rank() over (order by SUM(f.license_beds) DESC) as rank_, 'Licensed' as type
FROM bed_fact f
INNER JOIN business b ON f.ims_org_id = b.ims_org_id
WHERE f.bed_id IN (4, 15)
GROUP BY b.business_name
ORDER BY SUM(f.license_beds) DESC
LIMIT 2)
UNION ALL
(SELECT b.business_name AS hospital_name, SUM(f.census_beds) AS total_beds, rank() over (order by SUM(f.census_beds) DESC) as rank_, 'Census' as type
FROM bed_fact f
INNER JOIN business b ON f.ims_org_id = b.ims_org_id
WHERE f.bed_id IN (4, 15)
GROUP BY b.business_name
ORDER BY SUM(f.census_beds) DESC
LIMIT 2)
UNION ALL
(SELECT b.business_name AS hospital_name, SUM(f.staffed_beds) AS total_beds, rank() over (order by SUM(f.staffed_beds) DESC) as rank_, 'Staffed' as type
FROM bed_fact f
INNER JOIN business b ON f.ims_org_id = b.ims_org_id
WHERE f.bed_id IN (4, 15)
GROUP BY b.business_name
ORDER BY SUM(f.staffed_beds) DESC
LIMIT 2);

-- 4b. Hospitals that appear on multiple lists
SELECT hospital_name, 
       COUNT(*) AS count
FROM (
    (SELECT b.business_name AS hospital_name
    FROM bed_fact f
    INNER JOIN business b ON f.ims_org_id = b.ims_org_id
    WHERE f.bed_id IN (4, 15)
    GROUP BY b.business_name
    ORDER BY SUM(f.license_beds) DESC
    LIMIT 10)
    UNION ALL 
    (SELECT b.business_name AS hospital_name
    FROM bed_fact f
    INNER JOIN business b ON f.ims_org_id = b.ims_org_id
    WHERE f.bed_id IN (4, 15)
    GROUP BY b.business_name
    ORDER BY SUM(f.census_beds) DESC
    LIMIT 10)
    UNION ALL 
    (SELECT b.business_name AS hospital_name
    FROM bed_fact f
    INNER JOIN business b ON f.ims_org_id = b.ims_org_id
    WHERE f.bed_id IN (4, 15)
    GROUP BY b.business_name
    ORDER BY SUM(f.staffed_beds) DESC
    LIMIT 10)
) AS combined
GROUP BY hospital_name 
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;

-- 5a. 1) Top 10 Hospitals with both ICU and SICU Licensed Beds
SELECT b.business_name AS hospital_name, SUM(f.license_beds) AS total_license_beds
FROM bed_fact f
INNER JOIN business b ON f.ims_org_id = b.ims_org_id
WHERE f.bed_id IN (4, 15)
GROUP BY b.business_name
HAVING COUNT(b.business_name) > 1
ORDER BY SUM(f.license_beds) DESC
LIMIT 10;

-- 5a. 2) Top 10 Hospitals with both ICU and SICU census Beds
SELECT b.business_name AS hospital_name, SUM(f.census_beds) AS total_census_beds
FROM bed_fact f
INNER JOIN business b ON f.ims_org_id = b.ims_org_id
WHERE f.bed_id IN (4, 15)
GROUP BY b.business_name
HAVING COUNT(b.business_name) > 1
ORDER BY SUM(f.census_beds) DESC
LIMIT 10;

-- 5a. 3) Top 10 Hospitals with both ICU and SICU staffed Beds
SELECT b.business_name AS hospital_name, SUM(f.staffed_beds) AS total_staffed_beds
FROM bed_fact f
INNER JOIN business b ON f.ims_org_id = b.ims_org_id
WHERE f.bed_id IN (4, 15)
GROUP BY b.business_name
HAVING COUNT(b.business_name) > 1
ORDER BY SUM(f.staffed_beds) DESC
LIMIT 10;