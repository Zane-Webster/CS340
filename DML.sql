/*

PROJECT GROUP 73
- Caleb Webster
- Jason Hudson

Project Step 3 Draft 

Database Manipulation Queries for GYMS

Variables beginning with : represent values supplied by the backend from forms, dropdowns, or selected rows.
*/

-- -----------------------------------------------------
-- SELECT QUERIES FOR BROWSE PAGES  --------------------
-- -----------------------------------------------------

-- get all trainers for the Trainers page
SELECT trainerID, firstName, lastName, email, bio
FROM Trainers;

-- get all members and their assigned trainer (concat full name) for the Members page
SELECT Members.memberID, Members.firstName, Members.lastName, Members.email, Members.phoneNumber, Members.joinDate, Members.trainerID, CONCAT(Trainers.firstName, ' ', Trainers.lastName) AS trainerName
FROM Members
LEFT JOIN Trainers ON Members.trainerID = Trainers.trainerID;

-- get all classes and their assigned trainer (concat full name) for the Classes page
SELECT Classes.classID, Classes.className, Classes.schedule, Classes.capacity, Classes.trainerID, CONCAT(Trainers.firstName, ' ', Trainers.lastName) AS trainerName
FROM Classes
INNER JOIN Trainers ON Classes.trainerID = Trainers.trainerID;

-- get all memberships and their assigned member (concat full name) for the Memberships page
SELECT Memberships.membershipID, Memberships.membershipName, Memberships.price, Memberships.startDate, Memberships.endDate, Memberships.memberID, CONCAT(Members.firstName, ' ', Members.lastName) AS memberName
FROM Memberships
INNER JOIN Members ON Memberships.memberID = Members.memberID;

-- get all member class enrollments for the MemberClasses page
SELECT MemberClasses.memberID, MemberClasses.classID, CONCAT(Members.firstName, ' ', Members.lastName) AS memberName, Classes.className, MemberClasses.enrollmentDate
FROM MemberClasses
INNER JOIN Members ON MemberClasses.memberID = Members.memberID
INNER JOIN Classes ON MemberClasses.classID = Classes.classID;

-- -----------------------------------------------------
-- SELECT QUERIES FOR DROPDOWNS  -----------------------
-- -----------------------------------------------------

-- get all trainers to populate trainer dropdowns
SELECT trainerID, firstName, lastName
FROM Trainers;

-- get all members to populate member dropdowns
SELECT memberID, firstName, lastName
FROM Members;

-- get all classes to populate class dropdowns
SELECT classID, className
FROM Classes;

-- -----------------------------------------------------
-- SELECT QUERIES FOR UPDATE FORMS  --------------------
-- -----------------------------------------------------

-- get one trainer for the edit trainer form
SELECT trainerID, firstName, lastName, email, bio
FROM Trainers
WHERE trainerID = :trainerID_selected_from_browse_trainers_page;

-- get one member for the edit member form
SELECT memberID, firstName, lastName, email, phoneNumber, joinDate, trainerID
FROM Members
WHERE memberID = :memberID_selected_from_browse_members_page;

-- get one class for the edit class form
SELECT classID, className, schedule, capacity, trainerID
FROM Classes
WHERE classID = :classID_selected_from_browse_classes_page;

-- get one membership for the edit membership form
SELECT membershipID, membershipName, price, startDate, endDate, memberID
FROM Memberships
WHERE membershipID = :membershipID_selected_from_browse_memberships_page;

-- get one member-class enrollment for the edit enrollment form
SELECT memberID, classID, enrollmentDate
FROM MemberClasses
WHERE memberID = :memberID_selected_from_member_class_list AND classID = :classID_selected_from_member_class_list;

-- -----------------------------------------------------
-- INSERT QUERIES  -------------------------------------
-- -----------------------------------------------------

-- add a new trainer
INSERT INTO Trainers (firstName, lastName, email, bio)
VALUES (:firstNameInput, :lastNameInput, :emailInput, :bioInput);

-- add a new member
INSERT INTO Members (firstName, lastName, email, phoneNumber, joinDate, trainerID)
VALUES (:firstNameInput, :lastNameInput, :emailInput, :phoneNumberInput, :joinDateInput, :trainerID_from_dropdown_Input);

-- add a new member without an assigned trainer
INSERT INTO Members (firstName, lastName, email, phoneNumber, joinDate, trainerID)
VALUES (:firstNameInput, :lastNameInput, :emailInput, :phoneNumberInput, :joinDateInput, NULL);

-- add a new class
INSERT INTO Classes (className, schedule, capacity, trainerID)
VALUES (:classNameInput, :scheduleInput, :capacityInput, :trainerID_from_dropdown_Input);

-- add a new membership
INSERT INTO Memberships (membershipName, price, startDate, endDate, memberID)
VALUES (:membershipNameInput, :priceInput, :startDateInput, :endDateInput, :memberID_from_dropdown_Input);

-- enroll a member in a class
INSERT INTO MemberClasses (memberID, classID, enrollmentDate)
VALUES (:memberID_from_dropdown_Input, :classID_from_dropdown_Input, :enrollmentDateInput);

-- -----------------------------------------------------
-- UPDATE QUERIES  -------------------------------------
-- -----------------------------------------------------

-- update a trainer
UPDATE Trainers
SET firstName = :firstNameInput,
	lastName = :lastNameInput,
	email = :emailInput,
	bio = :bioInput
WHERE trainerID = :trainerID_from_update_form;

-- update a member
UPDATE Members
SET firstName = :firstNameInput,
	lastName = :lastNameInput,
	email = :emailInput,
	phoneNumber = :phoneNumberInput,
	joinDate = :joinDateInput,
	trainerID = :trainerID_from_dropdown_Input
WHERE memberID = :memberID_from_update_form;

-- update a member to have no assigned trainer
UPDATE Members
SET firstName = :firstNameInput,
	lastName = :lastNameInput,
	email = :emailInput,
	phoneNumber = :phoneNumberInput,
	joinDate = :joinDateInput,
	trainerID = NULL
WHERE memberID = :memberID_from_update_form;

-- update a class
UPDATE Classes
SET className = :classNameInput,
	schedule = :scheduleInput,
	capacity = :capacityInput,
	trainerID = :trainerID_from_dropdown_Input
WHERE classID = :classID_from_update_form;

-- update a membership
UPDATE Memberships
SET membershipName = :membershipNameInput,
	price = :priceInput,
	startDate = :startDateInput,
	endDate = :endDateInput,
	memberID = :memberID_from_dropdown_Input
WHERE membershipID = :membershipID_from_update_form;

-- update a member's class enrollment
UPDATE MemberClasses
SET memberID = :new_memberID_from_dropdown_Input,
	classID = :new_classID_from_dropdown_Input,
	enrollmentDate = :enrollmentDateInput
WHERE memberID = :old_memberID_from_update_form AND classID = :old_classID_from_update_form;

-- -----------------------------------------------------
-- DELETE QUERIES  -------------------------------------
-- -----------------------------------------------------

-- delete a trainer
DELETE FROM Trainers
WHERE trainerID = :trainerID_selected_from_browse_trainers_page;

-- delete a member
DELETE FROM Members
WHERE memberID = :memberID_selected_from_browse_members_page;

-- delete a class
DELETE FROM Classes
WHERE classID = :classID_selected_from_browse_classes_page;

-- delete a membership
DELETE FROM Memberships
WHERE membershipID = :membershipID_selected_from_browse_memberships_page;

-- remove a member from a class without deleting the member or class
DELETE FROM MemberClasses
WHERE memberID = :memberID_selected_from_member_class_list AND classID = :classID_selected_from_member_class_list;


-- -----------------------------------------------------
-- RESET DATABASE  -------------------------------------
-- -----------------------------------------------------

-- reset database by rerunning the submitted DDL.sql file
-- the DDL.sql file drops, recreates, and repopulates all tables with sample data