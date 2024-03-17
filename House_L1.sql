Create Database HouseDB
use HouseDB

-- Create table EMPLOYEES
Create table Employees (
EmpID char(8) not null primary key,
Ename varchar (50) not null,
Email varchar (100) not null,
Salary int not null, 
Gender varchar not null)

-- Create table HOUSES
Create table Houses (
HouseID char(6) not null primary key,
Area_m2 int not null,
Bedroom int not null,
Housetype char (10) not null)

-- Create table CUSTOMERS
Create table Customers (
CustomerID char(8) not null primary key,
Gender varchar not null,
Cname varchar (100) not null,
Caddress text not null,
Email varchar (100) not null)

-- Create table CONTRACT
Create table Contracts (
ContractNo char(8) not null primary key,
HouseID char(6) not null,
EmpID char(8) not null,
CustomerID char(8) not null,
StartDate date not null,
EndDate date not null,
Duration int not null,
ContractValue varchar(50) not null,
Prepaid int,
OutstandingAmount int)

-- LK Contract table vs. Employees table
Alter table Contracts
Add Constraint LK_EmpID Foreign key(EmpID) references Employees(EmpID)

-- LK Contract table vs. Customer table
Alter table Contracts
Add Constraint LK_CustomerID Foreign key(CustomerID) references Customers(CustomerID

-- LK Contract table vs. Houses table
Alter table Contracts
Add Constraint LK_HouseID Foreign key(HouseID) references Houses(HouseID)