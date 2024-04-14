# Database - Project

## About 

Designed a data management system for the US Federal Aviation Administration (FAA) which includes people, airlines, airplanes, airports, etc. The primary objective is to perform data analytics over flights data for 2013 by writing SQL statements for various queries.

## Goals 
- Successfully designed a RDMS using ER diagram, relational schemes, and DDL implementation
- executed SQL statements for various queries to analyze data of flights, useful for the FFA.
- Improved the performance of the system's workload by evaluating and implementing the most beneficial indexes

## File Content

- ER Diagram for visualizing relationships (er.pdf)
- DDL for CREATE TABLE statements (createTables.ddl)
- INSERT statements (loadData.ddl)
- Multiple queries (queries.pdf)
- SQL statements for queries (queries.sql)
- SQL query results (queriesResults.txt)
- Relational algebra expressions (ra.pdf) 
- Suggested indexes (index.pdf)

## Entities and Attributes

Phone 
- Number 
- Type 

Person 
- ID
- First name 
- Last name
- Sex
- Address
- Date of Birth
- Occupation 
- City 

City
- Name
- Country 
- Population 
- Area

Airport 
- Code 
- Latitude
- Longitude
- Name

Route
- Origin Airport 
- Destination Airport 
Passenger 
- Flayer Status

Pilot
- Years of Service 
- Salary 

Flight Attendant 
- Rank
- Salary
- Years of Service 

Airline 
- Carrier 
- Name

Airplane: 
- Tail Number 
- Year
- Manufacture
- Model
- Seats 

Flight 
- Flight Number 
- Distance 
- Date
- Scheduled Departure Time 
- Departure Time
- Arrival Time
- Scheduled Arrival Time

Ticket 
- Fare 
- Type 
- Class 