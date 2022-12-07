# Checking duplicates in the data
SELECT EmployeeID, COUNT(EmployeeID) AS EmployeeIDCount
FROM hr.employee
GROUP BY EmployeeID
HAVING EmployeeIDCount > 1;

# Attrition Ratios and Reasons
# What is the attrition % of the employees?
SELECT 	
(SELECT COUNT(Attrition) FROM hr.employee WHERE Attrition="Yes") / COUNT(Attrition) *100  AS Attrition_Rate
FROM hr.employee;

# What is the Gender Count?
SELECT gender, COUNT(Gender) As Gender_Count 
FROM hr.employee 
GROUP BY Gender
ORDER BY 2 DESC; 

# Gender Ratio in %
SELECT 
((SELECT COUNT(Gender) FROM hr.employee WHERE Gender='Female') / COUNT(Gender) *100) AS Female_Employee_perc, 
((SELECT COUNT(Gender) FROM hr.employee WHERE Gender='Male') / COUNT(Gender) * 100) AS Male_Employee_perc 
FROM hr.employee;

# Age Group Analysis
WITH CTE AS (SELECT 
CASE WHEN Age bETWEEN 0 AND 20 THEN '<20'
        WHEN Age BETWEEN 20 AND 29 THEN '20-29'
        WHEN Age BETWEEN 30 AND 39 THEN '30-40'
        WHEN Age BETWEEN 40 AND 49 THEN '40-50'
        WHEN Age BETWEEN 50 AND 100 THEN 'Greater than 50'
        ELSE 'not specified'
    END AS agegroup, COUNT(Attrition) AS Attrition
 FROM hr.employee WHERE Attrition = 'Yes' GROUP BY agegroup ORDER BY 1)
SELECT  agegroup, Attrition /(SELECT COUNT(Attrition) FROM hr.employee) *100 AS Attrition_Rate
FROM CTE  GROUP BY agegroup;
 
# Distance and Attrition Rate
WITH CTE AS (SELECT 
CASE when DistanceFromHome_KM < 10 then '0-10'
   when DistanceFromHome_KM between 10 and 19 then '10-18'
   when DistanceFromHome_KM between 20 and 28 then '20-27'
   when DistanceFromHome_KM between 29 and 37 then '28-36'
   when DistanceFromHome_KM between 38 and 45 then '37-45'
   END as Distance_range
, COUNT(Attrition) AS Attrition
 FROM hr.employee WHERE Attrition = 'Yes' GROUP BY Distance_range ORDER BY 1)
SELECT  Distance_range, Attrition /(SELECT COUNT(Attrition) FROM hr.employee) *100 AS Attrition_Rate
FROM CTE  GROUP BY Distance_range;
 
# Attrition Rate (State Wise)
SELECT 
IF(GROUPING(State),'Total',State)State,
Count(Attrition) AS Attrition_Employees, Count(Attrition) / (SELECT Count(Attrition) FROM hr.employee) * 100 AS Attrition_Rate, 
Count(Attrition) / (SELECT Count(Attrition) FROM hr.employee WHERE Attrition ='Yes') * 100 as Attrition_rate_StateWise
FROM hr.Employee
Where Attrition = 'Yes' Group by State WITH ROLLUP;

# Ethnicity
SELECT 
IF(GROUPING(Ethnicity),'Total',Ethnicity)Ethnicity,
Count(Attrition) AS Attrition_Employees, Count(Attrition) / (SELECT Count(Attrition) FROM hr.employee) * 100 AS Attrition_Rate, 
Count(Attrition) / (SELECT Count(Attrition) FROM hr.employee WHERE Attrition ='Yes') * 100 as Attrition_rate_EthnicityWise
FROM hr.Employee
Where Attrition = 'Yes' Group by Ethnicity WITH ROLLUP;
 

# State, Ethnicity Analysis along with their Average Salary and Attrition Rate
SELECT 	
IF(GROUPING(State),'Total',State)State, IF(GROUPING(Ethnicity),'Total',Ethnicity)Ethnicity, ROUND(AVG(Salary),2) As AVG_Salary,
Count(Attrition) AS Attrition_Employees, Count(Attrition) / (SELECT Count(Attrition) FROM hr.employee) * 100 AS Attrition_Rate, 
Count(Attrition) / (SELECT Count(Attrition) FROM hr.employee WHERE Attrition ='Yes') * 100 as Attrition_rate_EthnicityWise
FROM hr.Employee
Where Attrition = 'Yes' Group by State, Ethnicity WITH ROLLUP;
 
# Marital Status and Attrtion  Analysis
SELECT 
	IF(GROUPING(MaritalStatus),'Total',MaritalStatus)MaritalStatus,
Count(Attrition) AS Attrition_Employees, Count(Attrition) / (SELECT Count(Attrition) FROM hr.employee) * 100 AS Attrition_Rate, 
Count(Attrition) / (SELECT Count(Attrition) FROM hr.employee WHERE Attrition ='Yes') * 100 as Attrition_rate_MaritalStatus
FROM hr.Employee
Where Attrition = 'Yes'
Group by MaritalStatus WITH ROLLUP;
 
# How business travel affects the attrition of employees?
SELECT 
	IF(GROUPING(BusinessTravel),'Total',BusinessTravel)BusinessTravel,
	Count(Attrition) AS Attrition_Employees, Count(Attrition) / (SELECT Count(Attrition) FROM hr.employee) * 100 AS Attrition_Rate, 
	Count(Attrition) / (SELECT Count(Attrition) FROM hr.employee WHERE Attrition ='Yes') * 100 as Attrition_rate_BusinessTravel
FROM hr.Employee
Where Attrition = 'Yes'
Group by BusinessTravel WITH ROLLUP; 

# Which department is facing the highest Attrition?
SELECT 
IF(GROUPING(Department),'Total',Department)Department,
Count(Attrition) AS Attrition_Employees, Count(Attrition) / (SELECT Count(Attrition) FROM hr.employee) * 100 AS Attrition_Rate, 
Count(Attrition) / (SELECT Count(Attrition) FROM hr.employee WHERE Attrition ='Yes') * 100 as Attrition_rate_Departmentwise
FROM hr.Employee
Where Attrition = 'Yes'
Group by Department WITH ROLLUP;
 
# Which job role has the highest Attrition?
SELECT 
IF(GROUPING(JobRole),'Total',JobRole)Department,
Count(Attrition) AS Attrition_Employees, Count(Attrition) / (SELECT Count(Attrition) FROM hr.employee) * 100 AS Attrition_Rate, 
Count(Attrition) / (SELECT Count(Attrition) FROM hr.employee WHERE Attrition ='Yes') * 100 as Attrition_rate_JobRoleWise
FROM hr.Employee
Where Attrition = 'Yes'
Group by JobRole WITH ROLLUP;


# Average Salary of Employees along with their Attrition Rate rates
SELECT 
IF(GROUPING(Department),'Total',Department)Department, 
IF(GROUPING(JobRole),'Total',JobRole)JobRole, 
ROUND(Avg(Salary),2) AS Average_Salary,
Count(Attrition) AS Attrition_Employees, Count(Attrition) / (SELECT Count(Attrition) FROM hr.employee) * 100 AS Attrition_Rate, 
Count(Attrition) / (SELECT Count(Attrition) FROM hr.employee WHERE Attrition ='Yes') * 100 as Attrition_rate_JobRoleWise
FROM hr.Employee
Where Attrition = 'Yes'
Group by Department, JobRole WITH ROLLUP;

# Does overtime lead to attrition?
SELECT 
IF(GROUPING(OverTime),'Total',OverTime)OverTime, 
ROUND(Avg(Salary),2) AS Average_Salary,
Count(Attrition) AS Attrition_Employees, 
Count(Attrition) / (SELECT Count(Attrition) FROM hr.employee) * 100 AS Attrition_Rate, 
Count(Attrition) / (SELECT Count(Attrition) FROM hr.employee WHERE Attrition ='Yes') * 100 as Attrition_rate_OverTime
FROM hr.Employee
Where Attrition = 'Yes'
Group by OverTime WITH ROLLUP;

# Tenure Wise Analysis and Attrition Rate
SELECT 
	IF(GROUPING(YearsAtCompany),'Total',YearsAtCompany)YearsAtCompany, 
    	ROUND(AVG(YearsSinceLastPromotion),2) AS AVG_YearsSinceLastPromotion, 	
    	ROUND(AVG(YearsWithCurrManager),2) AS AVG_YearsWithCurrManager,
    	AVG(Salary) AS Average_Salary,
Count(Attrition) AS Attrition_Employees, Count(Attrition) / (SELECT Count(Attrition) FROM hr.employee) * 100 AS AttritionRate, 
Count(Attrition) / (SELECT Count(Attrition) FROM hr.employee WHERE Attrition ='Yes') * 100 as Attrition_rate_Tenurewise
FROM hr.Employee
Where Attrition = 'Yes'
Group by YearsAtCompany WITH ROLLUP;

# Does Unavailability of stock level cause Attrition?
SELECT 
	IF(GROUPING(StockOptionLevel),'Total',StockOptionLevel)StockOptionLevel, 
	Count(Attrition) AS Attrition_Employees, Count(Attrition) / (SELECT Count(Attrition) FROM hr.employee) * 100 AS AttritionRate, 
	Count(Attrition) / (SELECT Count(Attrition) FROM hr.employee WHERE Attrition ='Yes') * 100 as Attrition_rate_Stockoptionwise
FROM hr.Employee
Where Attrition = 'Yes'
Group by StockOptionLevel WITH ROLLUP;

# Organization’s Performance Indicators according to job Role
SELECT e.JobRole ,
ROUND(AVG(p.JobSatisfaction),2) AS Avg_JobSatisfaction,
ROUND(AVG(p.EnvironmentSatisfaction),2) AS Avg_EnvironmentSatisfaction,
ROUND(AVG(p.RelationshipSatisfaction),2) AS Avg_RelationshipSatisfaction,
ROUND(AVG(p.WorkLifeBalance),2) AS Avg_WorkLifeBalance
FROM hr.performancerating  as p
Inner join hr.employee as e ON e.EmployeeID = p.EmployeeID  
Group By e.JobRole
HAVING COUNT(DISTINCT p.EmployeeID) 
ORDER BY  1;
 
# Performation Rating 
# Organization’s Performance Indicators according to Over Time
SELECT e.OverTime ,
ROUND(AVG(p.JobSatisfaction),2) AS Avg_JobSatisfaction,
ROUND(AVG(p.EnvironmentSatisfaction),2) AS Avg_EnvironmentSatisfaction,
ROUND(AVG(p.RelationshipSatisfaction),2) AS Avg_RelationshipSatisfaction,
ROUND(AVG(p.WorkLifeBalance),2) AS Avg_WorkLifeBalance
FROM hr.performancerating  as p
Inner join hr.employee as e ON e.EmployeeID = p.EmployeeID  
Group By e.OverTime
HAVING COUNT(DISTINCT p.EmployeeID) 
ORDER BY  1;
 
# Organization’s Performance Indicators according to Marital Status
SELECT e.MaritalStatus ,
ROUND(AVG(p.JobSatisfaction),2) AS Avg_JobSatisfaction,
ROUND(AVG(p.EnvironmentSatisfaction),2) AS Avg_EnvironmentSatisfaction,
ROUND(AVG(p.RelationshipSatisfaction),2) AS Avg_RelationshipSatisfaction,
ROUND(AVG(p.WorkLifeBalance),2) AS Avg_WorkLifeBalance
FROM hr.performancerating  as p
Inner join hr.employee as e ON e.EmployeeID = p.EmployeeID  
Group By 1
HAVING COUNT(DISTINCT p.EmployeeID) 
ORDER BY  1 DESC;

 

# Manager and Self Rating according to Job Role
SELECT e.JobRole ,
ROUND(AVG(p.SelfRating),2) AS Avg_Self_Rating,
ROUND(AVG(p.ManagerRating),2) AS Avg_Manager_Rating
FROM hr.performancerating  as p
Inner join hr.employee as e ON e.EmployeeID = p.EmployeeID  
Group By e.JobRole
HAVING COUNT(DISTINCT p.EmployeeID) 
ORDER BY  1;
 

# Average Availability of Training Opportunities and Avg Training Opportunities Taken Chart
SELECT  
Employee.Department, ROUND(avg(TrainingOpportunitiesWithinYear),2) AS AVG_Training_Opportunities , 
ROUND(avg(TrainingOpportunitiesTaken),2) AS AVG_Training_Opportunities_Taken 
FROM hr.performancerating 
Inner join hr.employee  ON Employee.EmployeeID = PerformanceRating.EmployeeID Group By 1 ORDER BY 2 DESC;
