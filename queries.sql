connect to cs3db3;
-- Mariana Mariles 

------------------------------------------------
--  SQL statement for query 1
------------------------------------------------
SELECT DISTINCT ID, FirstName, LastName, Sex, DateOfBirth 
FROM Person, (SELECT PassengerID 
	FROM Take 
	WHERE Date LIKE '____-01-20' AND FlightNumber = '11') P   
WHERE DateOfBirth < '2001-11-01' 
AND Occupation LIKE '%Student' 
AND ID = PassengerID ;

------------------------------------------------
--  SQL statement for query 2
------------------------------------------------
SELECT A1.Carrier, Name 
FROM Airline A1, (SELECT Carrier, SUM(FlightFare) AS TotalFare 
	FROM Operate INNER JOIN (SELECT FlightNumber, SUM(Fare) AS FlightFare 
		FROM Class 
		GROUP BY FlightNumber) M 
	ON Operate.FlightNumber = M.FlightNumber 
	GROUP BY Carrier) N  
WHERE A1.Carrier = N.Carrier 
AND TotalFare >= ALL(SELECT (SUM(FlightFare)) TotalFare 
	FROM Operate INNER JOIN (SELECT FlightNumber, (SUM(Fare)) FlightFare 
		FROM Class 
		GROUP BY FlightNumber) M 
	ON Operate.FlightNumber = M.FlightNumber 
	GROUP BY Carrier); 

------------------------------------------------
--  SQL statement for query 3 
------------------------------------------------
SELECT O1.Carrier, Name, COUNT(O1.FlightNumber) AS NumberOfDelays 
FROM Airline A1, Operate O1, Flight F1 
WHERE A1.Carrier = O1.Carrier 
AND (O1.Date, O1.FlightNumber, O1.SchedArrTime, O1.SchedDepTime) = (F1.Date, F1.FlightNumber, F1.SchedArrTime, F1.SchedDepTime) 
AND F1.SchedArrTime  <> ArrTime 
GROUP BY O1.carrier, Name 
ORDER BY NumberofDelays DESC ; 

------------------------------------------------
--  SQL statement for query 4
------------------------------------------------
SELECT Name 
FROM AirportInCity 
GROUP BY Name 
HAVING COUNT(Name) >= 3 
ORDER BY Name ; 

------------------------------------------------
--  SQL statement for query 5 
------------------------------------------------
-- [A] --
SELECT DISTINCT Origin, Dest 
FROM RouteServe 
GROUP BY Origin, Dest 
HAVING COUNT(*) <= ALL(SELECT COUNT(*) AS Count 
	FROM RouteServe
	GROUP BY Origin, Dest) ;

-- [B] -- 
SELECT A1.carrier, Name 
FROM Airline A1, (SELECT Carrier, COUNT(DISTINCT R1.FlightNumber) AS Count
	FROM Operate O1, RouteServe R1 
	WHERE (O1.Date, O1.FlightNumber, O1.SchedArrTime, O1.SchedDepTime) = (R1.Date, R1.FlightNumber, R1.SchedArrTime, R1.SchedDepTime) 
	GROUP BY Carrier 
	HAVING COUNT(DISTINCT R1.FlightNumber) = 1) Y 
WHERE A1.Carrier = Y.Carrier ; 

-- [C] --
CREATE VIEW ROUTES AS 
SELECT Carrier, Origin, Dest 
FROM Operate O1, RouteServe R1 
WHERE (O1.Date, O1.FlightNumber, O1.SchedArrTime, O1.SchedDepTime) = (R1.Date, R1.FlightNumber, R1.SchedArrTime, R1.SchedDepTime) ; 

SELECT Carrier, Name 
FROM Airline 
WHERE Carrier IN (SELECT Carrier 
	FROM ROUTES 
	WHERE Origin = 'EWR' OR Origin = 'JFK') 
AND Carrier NOT IN(SELECT Carrier 
	FROM (SELECT Carrier, Origin, Dest FROM ROUTES WHERE (Origin <> 'EWR')) X 
	WHERE X.Origin <> 'JFK') ; 

DROP VIEW ROUTES ;  

-- [D] --
SELECT A1.carrier, Name 
FROM Airline A1, (SELECT Carrier, COUNT(DISTINCT R1.FlightNumber) AS Count
	FROM Operate O1, RouteServe R1 
	WHERE (O1.Date, O1.FlightNumber, O1.SchedArrTime, O1.SchedDepTime) = (R1.Date, R1.FlightNumber, R1.SchedArrTime, R1.SchedDepTime) 
	GROUP BY Carrier 
	HAVING COUNT(DISTINCT R1.FlightNumber) <= 2) Y 
WHERE A1.Carrier = Y.Carrier ; 

------------------------------------------------
--  SQL statement for query 6
------------------------------------------------
-- [A] -- 
SELECT O1.Carrier, A1.name, COUNT(T1.PassengerID) AS "NumberOfPassenegers" 
FROM Take T1, Operate O1, Airline A1 
WHERE (T1.Date, T1.FlightNumber, T1.SchedArrTime, T1.SchedDepTime) = (O1.Date, O1.FlightNumber, O1.SchedArrTime, O1.SchedDepTime) 
AND O1.Carrier = A1.Carrier 
AND T1.Date BETWEEN '2013-01-01' AND '2013-01-03' 
GROUP BY O1.Carrier, A1.name ; 

-- [B] --
CREATE VIEW GREATERTHAN500 AS 
SELECT R1.Origin, R1.Dest 
FROM Take T1, RouteServe R1 
WHERE (T1.Date, T1.FlightNumber, T1.SchedArrTime, T1.SchedDepTime) = (R1.Date, R1.FlightNumber, R1.SchedArrTime, R1.SchedDepTime) 
GROUP BY R1.Origin, R1.Dest 
HAVING COUNT(PassengerID) > 500 ; 

SELECT DISTINCT Origin, Dest 
FROM GREATERTHAN500 GT1 
WHERE GT1.origin < GT1.dest OR NOT EXISTS (SELECT * FROM GREATERTHAN500 GT2 
	WHERE GT2.Origin = GT1.Dest AND GT2.Dest = GT1.Origin) ; 

DROP VIEW GREATERTHAN500 ; 

-- [C] --
SELECT Name 
FROM AirportInCity 
WHERE Code IN (SELECT Dest 
	FROM RouteServe 
	GROUP BY Dest 
	HAVING COUNT(Dest) >= ALL(SELECT COUNT(Dest) 
		FROM RouteServe 
		GROUP BY Dest)) ; 

------------------------------------------------
--  SQL statement for query 7
------------------------------------------------
SELECT DISTINCT P1.ID, P1.FirstName, P1.LastName
FROM Person P1, Take T1, Take T2, RouteServe R1, RouteServe R2
WHERE P1.ID = T1.PassengerID 
AND T1.PassengerID = T2.PassengerID 
AND R1.Origin = R2.Dest 
AND R1.Dest = R2.Origin 
AND (T1.Date, T1.FlightNumber, T1.SchedArrTime, T1.SchedDepTime) = (R1.Date, R1.FlightNumber, R1.SchedArrTime, R1.SchedDepTime) 
AND (T2.Date, T2.FlightNumber, T2.SchedArrTime, T2.SchedDepTime) = (R2.Date, R2.FlightNumber, R2.SchedArrTime, R2.SchedDepTime) 
AND T1.Date BETWEEN '2013-01-01' AND '2013-01-31' 
AND T2.Date BETWEEN '2013-01-01' AND '2013-01-31' ; 

------------------------------------------------
--  SQL statement for query 8
------------------------------------------------
CREATE VIEW FlightsForPassenger AS 
SELECT P1.PassengerID, Origin 
FROM Passenger P1, Take T1, RouteServe R1 
WHERE P1.PassengerID = T1.PassengerID 
AND (T1.Date, T1.FlightNumber, T1.SchedArrTime, T1.SchedDepTime) = (R1.Date, R1.FlightNumber, R1.SchedArrTime, R1.SchedDepTime) ; 

SELECT DISTINCT PassengerID, P1.FirstName, P1.LastName 
FROM Person P1, FlightsForPassenger 
WHERE Origin = ANY(SELECT Code 
	FROM AirportInCity 
	WHERE Name = 'Los Angeles') 
AND PassengerID = P1.ID 
GROUP BY PassengerID, P1.FirstName, P1.LastName 
HAVING COUNT(PassengerID) >= 3 ; 

DROP VIEW FlightsForPassenger ; 
------------------------------------------------
--  SQL statement for query 9
------------------------------------------------
SELECT A1.Code, A1.Name 
FROM Airport A1, RouteServe R1, Take T1 
WHERE T1.date BETWEEN '2013-01-01' AND '2013-01-07' 
AND (T1.Date, T1.FlightNumber, T1.SchedArrTime, T1.SchedDepTime) = (R1.Date, R1.FlightNumber, R1.SchedArrTime, R1.SchedDepTime) 
AND (A1.Code = R1.Origin OR A1.Code = r1.Dest) 
GROUP BY A1.Code, A1.Name 
HAVING COUNT(T1.PassengerID) > 1000 ; 

------------------------------------------------
--  SQL statement for query 10
------------------------------------------------
-- [A] --
SELECT R1.Origin, R1.Dest 
FROM RouteServe R1, Operate O1 
WHERE (R1.Date, R1.FlightNumber, R1.SchedArrTime, R1.SchedDepTime) = (O1.Date, O1.FlightNumber, O1.SchedArrTime, O1.SchedDepTime) 
GROUP BY R1.Origin, R1.Dest 
HAVING COUNT(DISTINCT O1.Carrier) >= 5 ; 

-- [B] -- 
CREATE VIEW TRC AS 
SELECT T1.PassengerID, Origin, Dest, Fare 
FROM Take T1, RouteServe R1, Class C1 
WHERE (T1.flightnumber, T1.SchedArrTime, T1.SchedDepTime) = (R1.flightnumber, R1.SchedArrTime, R1.SchedDepTime) 
AND (T1.flightnumber, T1.SchedDepTime, T1.SchedArrTime, T1.class, T1.type) = (C1.flightnumber, C1.SchedDepTime, C1.SchedArrTime, C1.class, C1.type) ; 

SELECT Origin, Dest 
FROM (SELECT Origin, Dest, SUM(FARE) AS FARESUM FROM TRC GROUP BY Origin, Dest) 
WHERE FARESUM >= ALL(SELECT SUM(FARE)
	FROM TRC 
	GROUP BY Origin, Dest) ; 

DROP VIEW TRC ; 

------------------------------------------------
--  SQL statement for query 11 
------------------------------------------------
CREATE VIEW NEWFARE AS 
SELECT O1.Carrier, A1.Name, R1.Origin, R1.Dest, C1.Type, C1.Class, C1.Fare 
FROM Airline A1, Class C1, RouteServe R1, Operate O1 
WHERE A1.Carrier = O1.Carrier 
AND (C1.Date, C1.FlightNumber, C1.SchedArrTime, C1.SchedDepTime) = (R1.Date, R1.FlightNumber, R1.SchedArrTime, R1.SchedDepTime) 
AND (R1.Date, R1.FlightNumber, R1.SchedArrTime, R1.SchedDepTime) = (O1.Date, O1.FlightNumber, O1.SchedArrTime, O1.SchedDepTime) ; 

SELECT DISTINCT F1.Carrier, F1.Name 
FROM NEWFARE F1, NEWFARE F2 
WHERE F1.Carrier <> F2.Carrier 
AND (F1.Origin, F1.Dest, F1.Fare) = (F2.Origin, F2.Dest, F2.Fare) ; 

DROP VIEW NEWFARE ; 

------------------------------------------------
--  SQL statement for query 12
------------------------------------------------
-- [A] --
SELECT DISTINCT ID, FirstName, LastName 
FROM Person, Passenger 
WHERE ID = PassengerID 
AND PassengerID NOT IN(SELECT DISTINCT T1.PassengerID 
	FROM Take T1, Passenger P1 
	WHERE T1.PassengerID = P1.PassengerID) ; 

-- [B] -- 
CREATE VIEW TakeRoute 
AS SELECT T1.PassengerID, T1.Date, T1.FlightNumber, T1.SchedArrTime, T1.SchedDepTime, Origin, Dest 
FROM Take T1, RouteServe R1 
WHERE (T1.flightnumber, T1.SchedArrTime, T1.SchedDepTime) = (R1.flightnumber, R1.SchedArrTime, R1.SchedDepTime) ; 

(Select DISTINCT ID, FirstName, LastName 
	FROM Person, (SELECT PassengerID, Name FROM TakeRoute TR, AirportInCity WHERE AirportInCity.Code = TR.Dest) W 
	WHERE W.PassengerID = ID and city <> W.name) 
EXCEPT 
(Select DISTINCT ID, FirstName, LastName 
	FROM Person, (SELECT PassengerID, Name FROM TakeRoute TR, AirportInCity WHERE AirportInCity.Code = TR.Dest) W 
	WHERE W.PassengerID = ID and city = W.name) ; 

DROP VIEW TakeRoute ; 

------------------------------------------------
--  SQL statement for query 13 
------------------------------------------------ 
SELECT DISTINCT A1.carrier, A2.Tailnum 
FROM AirlineOwnAirplane A1 RIGHT OUTER JOIN Airplane A2 ON A1.Tailnum = A2.Tailnum ;


