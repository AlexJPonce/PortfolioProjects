--Insert into EmployeeDemographics VALUES
--(1011, 'Ryan', 'Howard', 26, 'Male'),
--(NULL, 'Holly','Flax', NULL, 'Male'),
--(1013, 'Darryl', 'Philbin', NULL, 'Male')

--Insert into EmployeeSalary VALUES
--(1010, NULL, 47000),
--(NULL, 'Salesman', 43000)

--UPDATE EmployeeDemographics
--SET Gender = NULL
--WHERE FirstName = 'Holly'

--Select *
--FROM EmployeeDemographics

--Select * 
--FROM EmployeeSalary

--Create Table WareHouseEmployeeDemographics 
--(EmployeeID int, 
--FirstName varchar(50), 
--LastName varchar(50), 
--Age int, 
--Gender varchar(50)
--)
--Insert into WareHouseEmployeeDemographics VALUES
--(1013, 'Darryl', 'Philbin', NULL, 'Male'),
--(1050, 'Roy', 'Anderson', 31, 'Male'),
--(1051, 'Hidetoshi', 'Hasagawa', 40, 'Male'),
--(1052, 'Val', 'Johnson', 31, 'Female')

--SELECT EmployeeID, FirstName, Age
--FROM [SQL Tutorial].dbo.EmployeeDemographics
--UNION
--SELECT EmployeeID, JobTitle, Salary
--FROM [SQL Tutorial].dbo.EmployeeSalary
--ORDER BY EmployeeID

--SELECT *
--FROM [SQL Tutorial].dbo.EmployeeDemographics
--Full Outer Join [SQL Tutorial].dbo.WareHouseEmployeeDemographics
--	ON EmployeeDemographics.EmployeeID = WareHouseEmployeeDemographics.EmployeeID

--SELECT FirstName, LastName, Age,
--CASE
--	WHEN Age = 38 THEN 'Stanley'
--	WHEN Age > 30 THEN 'OLD'
--	ELSE 'Baby'
--END
--FROM [SQL Tutorial].dbo.EmployeeDemographics
--WHERE Age is NOT NULL
--ORDER BY Age

--SELECT Demo.EmployeeID, Sal.Salary
--FROM [SQL Tutorial].dbo.EmployeeDemographics AS Demo
--Join [SQL Tutorial].dbo.EmployeeSalary AS Sal
--	ON Demo.EmployeeID = Sal.EmployeeID

SELECT FirstName, LastName, Gender, Salary, COUNT(Gender) OVER (PARTITION BY Gender) AS TotalGender
FROM [SQL Tutorial]..EmployeeDemographics dem
JOIN [SQL Tutorial]..EmployeeSalary sal
	ON dem.EmployeeID = sal.EmployeeID