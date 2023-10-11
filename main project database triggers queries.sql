/*
*TRIGGER QUERIES for the database
*/

/*TRIGGER TO CHECK FACILITY CAPACITY*/
DELIMITER $$
CREATE TRIGGER check_capacity
BEFORE INSERT ON works_at
FOR EACH ROW
BEGIN
DECLARE total_employees INT;
SELECT COUNT(*) INTO total_employees
FROM works_at
WHERE facility_id = NEW.facility_id
AND (end_date IS NULL);
IF total_employees >= (SELECT capacity FROM facilities WHERE facility_id = NEW.facility_id)
THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Cannot add employee to facility, facility is at capacity.';
END IF;
END;$$

/*TRIGGER TO CHECK ONE GENERAL MANAGER*/
DELIMITER $$
CREATE TRIGGER check_general_manager
BEFORE INSERT ON works_at
FOR EACH ROW
BEGIN
DECLARE general_manager_count INT;
SELECT COUNT(*) INTO general_manager_count
FROM works_at
WHERE facility_id = NEW.facility_id
AND role = 'general manager'
AND end_date IS NULL;
IF general_manager_count > 0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Cannot add or update employee, facility already has a general manager.';
END IF;
END;$$

/*TRIGGER TO CHECK THE 1 HOUR WINDOW BETWEEN SHIFTS.*/
DELIMITER $$
CREATE TRIGGER check_employee_schedule
BEFORE INSERT ON schedule
FOR EACH ROW
BEGIN
-- Check if the employee is already scheduled to work at another facility during the same time
IF EXISTS (
SELECT * FROM schedule
WHERE medicare_number = NEW.medicare_number
AND day = NEW.day
AND start_time <= NEW.end_time
AND end_time > (NEW.start_time - INTERVAL 1 HOUR)
) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee cannot be scheduled due to a
time conflict.';
END IF;
END;$$

/*TRIGGER TO ASSURE THAT NO employee IS SCHEDULED BEFORE 14 DAYS AFTER INFECTION*/
DELIMITER $$
CREATE TRIGGER check_infected
BEFORE INSERT ON schedule
FOR EACH ROW
BEGIN
DECLARE infected BOOLEAN;
SELECT EXISTS (SELECT * FROM infected WHERE medicare_number =
NEW.medicare_number AND date >= DATE_SUB(NEW.day, INTERVAL 14 DAY) AND
inf_id = 'M3N4O5') INTO infected;
IF EXISTS (SELECT * FROM works_at WHERE medicare_number =
NEW.medicare_number AND end_date IS NULL) AND infected THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Cannot schedule employee, employee is infected with
COVID-19.';
END IF;
END;$$

/*TRIGGER TO NOT SCHEDULE EMPLOYEES IF THEY ARE NOT PROPERLY VACCINATED*/
DELIMITER $$
CREATE TRIGGER check_vaccinated
BEFORE INSERT ON schedule
FOR EACH ROW
BEGIN
IF NOT EXISTS (SELECT * FROM vaccinated WHERE medicare_number =
NEW.medicare_number AND date >= DATE_SUB(NEW.day, INTERVAL 6 MONTH) AND
vac_id = ' J0K1L2 ') THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Cannot schedule employee, employee is not vaccinated for
COVID-19.';
END IF;
END;$$

/*TRIGGER TO CANCEL SHIFTS OF CONTAMINATED EMPLOYEES AND NOTIFY OTHERS NURSES OR DOCTORS SCHEDULED AT THE SAME TIME*/
DELIMITER $$
CREATE TRIGGER cancel_assignments
AFTER INSERT ON infected
FOR EACH ROW
BEGIN
IF NEW.inf_id = 'M3N4O5' THEN
-- cancel the infected employee's assignments
DELETE FROM schedule
WHERE medicare_number = NEW.medicare_number
AND day >= NEW.date AND day <= DATE_ADD(NEW.date, INTERVAL 13 DAY);
INSERT INTO log(fromFacilityID, toMedicareNumber, subject, sentOn)
(SELECT DISTINCT s.facility_id, s.medicare_number, 'COVID-19 exposure', NEW.date
FROM schedule AS s
WHERE s.medicare_number != NEW.medicare_number
AND s.day >= DATE_SUB(NEW.date, INTERVAL 13 DAY) AND s.day <= NEW.date
AND s.day IN (SELECT day FROM schedule WHERE medicare_number =
NEW.medicare_number AND day >= DATE_SUB(NEW.date, INTERVAL 13 DAY) AND day
<= NEW.date)
AND s.facility_id IN (SELECT facility_id FROM schedule WHERE medicare_number =
NEW.medicare_number AND day >= DATE_SUB(NEW.date, INTERVAL 13 DAY) AND day
<= NEW.date)
);
END IF;
END;$$

/*EMAIL SCHEDULES EVERY SUNDAY FOR EMPLOYEES WITH SHIFTS*/
DELIMITER $$
CREATE EVENT schedule_mailer
ON SCHEDULE
EVERY 1 WEEK
STARTS '2023-01-01 00:00:00'
ON COMPLETION PRESERVE
DO
IF WEEKDAY(NOW()) = 6 THEN
INSERT INTO log(fromFacilityID, toMedicareNumber, subject, sendOn)
(SELECT DISTINCT facility_id, medicare_number, 'Weekly Schedule', CURDATE()
FROM schedule WHER E day BETWEEN DATE_ADD(CURDATE(), INTERVAL 1 DAY)
AND DATE_ADD(CURDATE(), INTERVAL 6 DAY));
END IF;$$

/*EMAIL SCHEDULES EVERY SUNDAY FOR EMPLOYEES WITHOUT SHIFTS*/
DELIMITER $$
CREATE EVENT noschedule_mailer
ON SCHEDULE
EVERY 1 WEEK
STARTS '2023-01-01 00:00:00'
ON COMPLETION PRESERVE
DO
IF WEEKDAY(NOW()) = 6 THEN
INSERT INTO log(fromFacilityID, toMedicareNumber, subject, sendOn)
(SELECT DISTINCT facility_id, medicare_number, ‘No ASSIGNMENT’, CURDATE()
FROM schedule WHER E NOT(day BETWEEN DATE_ADD(CURDATE(), INTERVAL 1
DAY) AND DATE_ADD(CURDATE(), INTERVAL 6 DAY)));
END IF;$$