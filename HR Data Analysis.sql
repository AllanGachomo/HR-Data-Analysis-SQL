UPDATE [General Data]
SET JobRole = REPLACE(JobRole, 'Mager', 'Manager')

--1. Retrieve the total number of employees in the dataset.--

SELECT 
    COUNT(DISTINCT(EmployeeID)) AS 'Total NUmber of Employees'
FROM [General Data]

--2. List all unique job roles in the dataset.--

SELECT 
    DISTINCT(JobRole)
FROM [General Data]
ORDER BY JobRole ASC

--3. Find the average age of employees.--

SELECT 
    AVG(Age) AS 'Average Age of Employees'
FROM [General Data]

--4. Retrieve the names and ages of employees who have worked at the company for more than 5 years.--

SELECT 
    EmpName,
    Age,
    YearsAtCompany 
FROM [General Data]
WHERE YearsAtCompany > 5
ORDER BY YearsAtCompany DESC, EmpName ASC

--5. Get a count of employees grouped by their department.--

SELECT 
    Department,
    COUNT(EmployeeID) AS 'Number of Employees'
FROM [General Data]
GROUP BY Department
ORDER BY [Number of Employees] DESC

--6. List employees who have 'High' Job Satisfaction. Scale is as follows: 1-'Low' 2-'Medium' 3-'High' 4-'Very High'--

SELECT
    gd.EmpName
FROM [General Data] AS gd
INNER JOIN [HR Data Analysis].[dbo].[employee_survey_data] AS esd
ON gd.EmployeeID = esd.EmployeeID
WHERE esd.JobSatisfaction = '3'
ORDER BY gd.EmpName ASC

--7. Find the highest Monthly Income in the dataset.--

SELECT 
    MAX(MonthlyIncome) AS 'Highest Monthly Income'
FROM [General Data]

--8. List employees who have 'Travel_Rarely' as their BusinessTravel type.--

SELECT 
    EmpName
FROM [General Data]
WHERE BusinessTravel = 'Travel_Rarely'
ORDER BY EmpName ASC

--9. Retrieve the distinct MaritalStatus categories in the dataset.--

SELECT 
    DISTINCT(MaritalStatus)
from [General Data]

--10. Get a list of employees with more than 2 years of work experience but less than 4 years in their current role.--

SELECT 
    EmpName
FROM [General Data]
WHERE TotalWorkingYears > 2 AND YearsSinceLastPromotion < 4
ORDER BY EmpName ASC

--11. List employees who have changed their job roles within the company (JobLevel and JobRole differ from their previous job).--
--12. Find the average distance from home for employees in each department.--

SELECT 
    Department,
    AVG(CAST(DistanceFromHome AS decimal(10,2))) AS 'Avg. Distance From Home'
FROM [General Data]
GROUP BY Department

--13. Retrieve the top 5 employees with the highest MonthlyIncome.--

SELECT 
    TOP 5 EmpName,
    MonthlyIncome
FROM [General Data]
ORDER BY MonthlyIncome DESC

--14. Calculate the percentage of employees who have had a promotion in the last year.--

SELECT  
    CONCAT(
    CAST(((SELECT COUNT(EmpName) FROM [General Data] WHERE YearsSinceLastPromotion <= 1) * 100.0 / 
    (SELECT COUNT(EmpName) FROM [General Data])) AS decimal (10,2)), '%'  
    )AS 'Promotion Percentage in the Lat Year'

--15. List the employees with the highest and lowest EnvironmentSatisfaction. Scale is as follows: 1-'Low' 2-'Medium' 3-'High' 4-'Very High'--

SELECT 
    gd.EmpName,
    esd.EnvironmentSatisfaction
FROM [General Data] AS gd
INNER JOIN employee_survey_data AS esd
ON esd.EmployeeID = gd.EmployeeID
WHERE esd.EnvironmentSatisfaction IN (1,4)
ORDER BY esd.EnvironmentSatisfaction DESC

--16. Find the employees who have the same JobRole and MaritalStatus.--

SELECT 
    gd1.EmpName,
    gd1.JobRole,
    gd1.MaritalStatus
FROM [General Data] AS gd1
INNER JOIN (SELECT JobRole, MaritalStatus
            FROM [General Data]
            GROUP BY JobRole, MaritalStatus
            HAVING COUNT(*) > 1 
)AS grouped
    ON gd1.JobRole = grouped.JobRole
    AND gd1.MaritalStatus = grouped.MaritalStatus
ORDER BY gd1.JobRole DESC, gd1.MaritalStatus ASC
 
--17. List the employees with the highest TotalWorkingYears who also have a PerformanceRating of 4.--

SElECT
    gd.EmpName,
    gd.TotalWorkingYears,
    msd.PerformanceRating
FROM [General Data] AS gd
INNER JOIN manager_survey_data AS msd
ON msd.EmployeeID = gd.EmployeeID
WHERE msd.PerformanceRating = 4
AND GD.TotalWorkingYears = (SELECT MAX(TotalWorkingYears)
                            FROM [General Data] AS gd
                            INNER JOIN manager_survey_data AS msd
                            ON msd.EmployeeID = gd.EmployeeID
                            WHERE msd.PerformanceRating = 4)

--18. Calculate the average Age and JobSatisfaction for each BusinessTravel type.--

SELECT 
    gd.BusinessTravel,
    AVG(gd.Age) AS 'Average Age',
    AVG(esd.JobSatisfaction) AS 'Average Satisfaction'
FROM [General Data] AS gd
INNER JOIN employee_survey_data AS esd
ON esd.EmployeeID = gd.EmployeeID
GROUP BY gd.BusinessTravel

--19. Retrieve the most common EducationField among employees.--

SELECT TOP 1
    EducationField,
    COUNT(EducationField) AS 'Number of Employees'
FROM [General Data]
GROUP BY EducationField
ORDER BY [Number of Employees] DESC

--20. List the employees who have worked for the company the longest but haven't had a promotion.--

SELECT 
    EmpName, 
    TotalWorkingYears, 
    YearsSinceLastPromotion
FROM [General Data]
WHERE YearsSinceLastPromotion >= TotalWorkingYears
AND TotalWorkingYears = (
                         SELECT MAX(TotalWorkingYears)
                         FROM [General Data]
                         WHERE YearsSinceLastPromotion >= TotalWorkingYears
                        )