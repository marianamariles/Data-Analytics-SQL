connect to CS3DB3;
------------------------------------------------
--  DDL Statements for Person
------------------------------------------------
create table Person(
	ID integer not null,
	fname varchar(60),
	lname varchar(60),
	sex varchar(60),
	DOB date,
	address varchar(60),
	ocupation varchar(60),
	Number bigint not null, --at least one
	primary key (ID)
);

------------------------------------------------
--  DDL Statements for table Passenger
------------------------------------------------
create table Passenger( 
	ID integer not null,
	status varchar(60) CHECK (status = 'silver' OR status = 'gold' OR status = 'dimond'), --silver, gold, or dimond
	PRIMARY KEY (Id),
	FOREIGN KEY (Id) REFERENCES Person --ISA relationship
); 

------------------------------------------------
--  DDL Statements for table Pilot
------------------------------------------------
create table Pilot(
	ID integer not null,
	years_of_service integer,
	salary integer,
	PRIMARY KEY (Id),
	FOREIGN KEY (Id) REFERENCES Person --ISA relationship
);

------------------------------------------------
--  DDL Statements for Flight Attendant
------------------------------------------------
create table Flight_Attendant(
	ID integer not null,
	rank varchar(60) CHECK (rank = 'junior' OR rank = 'senior' OR rank = 'manager' OR rank = 'director'), --junior, senior, manager, director
	years_of_service integer,
	salary integer,
	PRIMARY KEY (Id),
	FOREIGN KEY (Id) REFERENCES Person--ISA relationship
);

------------------------------------------------
--  DDL Statements for Airports
------------------------------------------------
create table Airports(
	airport_code CHAR(3) not null,
	airport_name varchar(60),
	airport_location real,
	-- Residing_city: city_name, country, total_area, population 
	city_name varchar(60),
	country varchar(60),
	total_area real,
	population integer,
	primary key (airport_code)
);

------------------------------------------------
--  DDL Statements for Airlines
------------------------------------------------
create table Airlines(
	CarrierID CHAR(2)  not null,
	name varchar(60),
	primary key (CarrierID)
);

------------------------------------------------
--  DDL Statements for Airplanes
------------------------------------------------
create table Airplanes(
	tail_number integer not null,
	number_of_seats integer,
	years_in_operation integer,
	manuf varchar(60),
	model_number integer,
	primary key (tail_number)
);

------------------------------------------------
--  DDL Statements for Weak Entity Flights
------------------------------------------------
 create table Flights_route(
 	flight_num integer not null,
	flight_date date,
	scheduales_depart_time time,
	scheduales_arrive_time time,
	actual_depart_time time,
	actual_arrive_time time,
	distance_travelled integer,
	-- Tickets: classes (economy, premium economy, business), type (infant, child, adult), price
	ticketClass varchar(60) CHECK (ticketClass = 'economy' OR ticketClass = 'premium economy' OR ticketClass = 'business'), 
	ticketType varchar(60) CHECK (ticketType = 'infant' OR ticketType = 'child' OR ticketType = 'adult'), 
	ticketPrice real,
	airport_code CHAR(3) not null, --from airports table 
	depart_airport varchar(60), 
	arrive_airport varchar(60), 
	PRIMARY KEY (airport_code, flight_num), 
	FOREIGN KEY (airport_code) REFERENCES Airports(airport_code) on delete cascade 
);

------------------------------------------------
--  DDL Statements for Works_for Relationship 
------------------------------------------------
 create table works_for(
	ID integer not null,
	CarrierID CHAR(2) not null,
	PRIMARY KEY (ID,CarrierID),
	FOREIGN KEY (ID) REFERENCES Flight_Attendant(ID) on delete cascade ,
	FOREIGN KEY (ID) REFERENCES Pilot(ID) on delete cascade ,
	FOREIGN KEY (CarrierID) REFERENCES Airlines(CarrierID) on delete cascade  
);
------------------------------------------------
--  DDL Statements for owns Relationship 
------------------------------------------------
 create table owns(
	tail_number integer not null,
	CarrierID CHAR(2)  not null,
	PRIMARY KEY (tail_number,CarrierID), 
	FOREIGN KEY (tail_number) REFERENCES Airplanes(tail_number) on delete cascade,
	FOREIGN KEY (CarrierID) REFERENCES Airlines(CarrierID) on delete cascade 
);
------------------------------------------------
--  DDL Statements for uses Relationship 
------------------------------------------------
 create table uses(
	flight_num integer not null,
	airport_code CHAR(3) not null,
	tail_number integer not null, 
	PRIMARY KEY (flight_num,tail_number), 
	FOREIGN KEY (airport_code, flight_num) REFERENCES Flights_route(airport_code, flight_num) on delete cascade,
	FOREIGN KEY (tail_number) REFERENCES Airplanes(tail_number) on delete cascade 
);

------------------------------------------------
--  DDL Statements for serves Relationship 
------------------------------------------------
create table serves(
	flight_num integer not null,
	airport_code CHAR(3) not null,
	CarrierID CHAR(2) not null,
	PRIMARY KEY (flight_num,CarrierID), 
	FOREIGN KEY (airport_code, flight_num) REFERENCES Flights_route(airport_code, flight_num) on delete cascade,
	FOREIGN KEY (CarrierID) REFERENCES Airlines(CarrierID) on delete cascade 
);