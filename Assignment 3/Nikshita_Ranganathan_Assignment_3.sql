-- Setting the specific database for executing queries
USE assignment3;

-- Checking the dataset
SELECT * FROM inspection;

-- Changing the date format
SELECT 
    PUBLIC_HOUSING_AGENCY_NAME AS PHA_NAME, 
    STR_TO_DATE(INSPECTION_DATE, '%m/%d/%Y') AS "Date", 
    COST_OF_INSPECTION_IN_DOLLARS AS MR_INSPECTION_COST
    FROM inspection;
    
-- Question 5
WITH CTE AS
(
   SELECT 
        PUBLIC_HOUSING_AGENCY_NAME AS PHA_NAME,
        STR_TO_DATE(INSPECTION_DATE, '%m/%d/%Y') AS MR_INSPECTION_DATE,
        COST_OF_INSPECTION_IN_DOLLARS AS MR_INSPECTION_COST,
        LAG(STR_TO_DATE(INSPECTION_DATE, '%m/%d/%Y'),1,NULL) OVER (PARTITION BY PUBLIC_HOUSING_AGENCY_NAME 
        ORDER BY STR_TO_DATE(INSPECTION_DATE, '%m/%d/%Y') DESC) AS SECOND_MR_INSPECTION_DATE,
        LAG(COST_OF_INSPECTION_IN_DOLLARS,1,NULL) OVER (PARTITION BY PUBLIC_HOUSING_AGENCY_NAME 
        ORDER BY STR_TO_DATE(INSPECTION_DATE, '%m/%d/%Y') DESC) AS SECOND_MR_INSPECTION_COST,
        COST_OF_INSPECTION_IN_DOLLARS - LAG(COST_OF_INSPECTION_IN_DOLLARS,1,NULL) OVER (PARTITION BY PUBLIC_HOUSING_AGENCY_NAME 
	    ORDER BY STR_TO_DATE(INSPECTION_DATE, '%m/%d/%Y') DESC) AS CHANGE_IN_COST,
        ROUND((COST_OF_INSPECTION_IN_DOLLARS - LAG(COST_OF_INSPECTION_IN_DOLLARS, 1,NULL) OVER (PARTITION BY PUBLIC_HOUSING_AGENCY_NAME 
        ORDER BY STR_TO_DATE(INSPECTION_DATE, '%m/%d/%Y') DESC)) / LAG(COST_OF_INSPECTION_IN_DOLLARS, 1,NULL) OVER (PARTITION BY PUBLIC_HOUSING_AGENCY_NAME 
        ORDER BY STR_TO_DATE(INSPECTION_DATE, '%m/%d/%Y') DESC) * 100, 2) AS PERCENT_CHANGE_IN_COST,
        COUNT(*) OVER(PARTITION BY PUBLIC_HOUSING_AGENCY_NAME) AS COUNT_INSPECTION,
        ROW_NUMBER() OVER (PARTITION BY PUBLIC_HOUSING_AGENCY_NAME ORDER BY PUBLIC_HOUSING_AGENCY_NAME, INSPECTION_DATE DESC) AS INSPECTION_ROW
FROM inspection
),
Filter AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY PHA_NAME 
            ORDER BY MR_INSPECTION_DATE DESC
        ) AS RN
    FROM CTE
    WHERE CHANGE_IN_COST > 0 AND COUNT_INSPECTION > 1
)
SELECT 
    PHA_NAME,
    MR_INSPECTION_DATE,
    MR_INSPECTION_COST,
    SECOND_MR_INSPECTION_DATE,
    SECOND_MR_INSPECTION_COST,
    CHANGE_IN_COST,
    PERCENT_CHANGE_IN_COST
FROM Filter
WHERE RN = 1;