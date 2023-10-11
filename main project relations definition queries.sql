/*
*SQL scripts to create relations
*/

CREATE TABLE facilities (
facility_id char(10) PRIMARY KEY,
name varchar(255) not null,
address varchar(255) not null,
postal_code char(7) not null,
phone_number char(10) not null,
web_address varchar(255),
type varchar(255) not null,
capacity int not null,
FOREIGN KEY (postal_code) references location(postal_code));

CREATE TABLE location (
postal_code char(7) PRIMARY KEY,
city varchar(35) not null,
province char(2) not null);

CREATE TABLE works_at (
facility_id char(10),
medicare_number char(10),
start_date date not null,
end_date varchar(20),
role varchar(255) not null,
PRIMARY KEY(medicare_number, start_date),
FOREIGN KEY (medicare_number) REFERENCES employees(medicare_number),
FOREIGN KEY (facility_id) REFERENCES facilities(facility_id));

CREATE TABLE employees(
medicare_number char(10) PRIMARY KEY,
first_name varchar(255) not null,
last_name varchar(255) not null,
date_of_birth date not null,
phone_number char(10) not null,
address varchar(255) not null,
postal_code char(7) not null,
citizenship varchar(255),
email_address varchar(255) not null,
FOREIGN KEY (postal_code) references location(postal_code));

CREATE TABLE vaccines(
vac_id char(10) PRIMARY KEY,
type char(10));

CREATE TABLE vaccinated(
vac_id char(10),
medicare_number char(10),
date date not null,
dose_number int not null,
PRIMARY KEY (medicare_number, vac_id, dose_number),
FOREIGN KEY (vac_id) references vaccines(vac_id));

CREATE TABLE infected(
inf_id char(10),
medicare_number char(10),
date date not null,
PRIMARY KEY (inf_id, medicare_number, date),
FOREIGN KEY (inf_id) references infections(inf_id),
FOREIGN KEY (medicare_number) references employees(medicare_number));

CREATE TABLE infections(
inf_id char(10) PRIMARY KEY,
type varchar(255));
CREATE TABLE schedule(
medicare_number char(10),
facility_id char(10),
day date,
start_time time,
end_time time,
CHECK(start_time < end_time),
FOREIGN KEY (medicare_number) REFERENCES employees(medicare_number),
FOREIGN KEY (medicate_number) references works_at(medicare_number),
FOREIGN KEY (facility_id) references works_at(facility_id),
FOREIGN KEY (facility_id) REFERENCES facilities(facility_id),
PRIMARY KEY(medicare_number, facility_id, day, start_time));

CREATE TABLE log(
fromFacilityID varchar(10),
toMedicareNumber varchar(10),
subject varchar(255),
sentOn date,
PRIMARY KEY(fromFacilityID, toMedicareNumber, subject, sentOn)
FOREIGN KEY (fromFacilityID) references facilities(facility_id)
FOREIGN KEY (toMedicateNumber) references employees(medicare_number)
FOREIGN KEY (subject) references emailSubjects(subject));

CREATE TABLE emailSubjects(
subject varchar(255) PRIMARY KEY,
body varchar(255));