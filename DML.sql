/*

PROJECT GROUP 73
- Caleb Webster
- Jason Hudson

Database Manipulation Queries for GYMS

Variables beginning with : represent values supplied by the backend from forms, dropdowns, or selected rows
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
SELECT MemberClasses.memberClassID, MemberClasses.memberID, MemberClasses.classID, CONCAT(Members.firstName, ' ', Members.lastName) AS memberName, Classes.className, MemberClasses.enrollmentDate
FROM MemberClasses
INNER JOIN Members ON MemberClasses.memberID = Members.memberID
INNER JOIN Classes ON MemberClasses.classID = Classes.classID;

-- -----------------------------------------------------
-- SELECT QUERIES FOR DROPDOWNS  -----------------------
-- -----------------------------------------------------

-- get all members to populate member dropdowns
SELECT memberID, firstName, lastName
FROM Members;

-- get all classes to populate class dropdowns
SELECT classID, className
FROM Classes;

-- -----------------------------------------------------
-- INSERT QUERIES  -------------------------------------
-- -----------------------------------------------------

-- enroll a member in a class
CALL sp_insert_member_class(
	:memberID_from_dropdown_Input,
	:classID_from_dropdown_Input,
	:enrollmentDateInput
);

-- -----------------------------------------------------
-- UPDATE QUERIES  -------------------------------------
-- -----------------------------------------------------

-- update a members class enrollment
CALL sp_update_member_class(
	:memberClassID_from_update_form,
	:memberID_from_dropdown_Input,
	:classID_from_dropdown_Input,
	:enrollmentDateInput
);

-- -----------------------------------------------------
-- DELETE QUERIES  -------------------------------------
-- -----------------------------------------------------

-- remove a member from a class
CALL sp_delete_member_class(
	:memberClassID_selected_from_member_class_list
);


-- -----------------------------------------------------
-- RESET DATABASE  -------------------------------------
-- -----------------------------------------------------

CALL ResetDatabase();