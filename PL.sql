/*

PROJECT GROUP 73
- Caleb Webster
- Jason Hudson

PL/SQL Procedures

*/

-- inserts memberclass row into MemberClasses entity
DROP PROCEDURE IF EXISTS sp_insert_member_class;
DELIMITER //
CREATE PROCEDURE sp_insert_member_class (
	IN p_memberID INT,
	IN p_classID INT,
	IN p_enrollmentDate DATE
)
BEGIN
	-- insert paramaters into MemberClasses
	INSERT INTO MemberClasses (memberID, classID, enrollmentDate)
	VALUES (p_memberID, p_classID, p_enrollmentDate);
END //

DELIMITER ;\

-- updates memberclass row inside of MemberClasses entity
DROP PROCEDURE IF EXISTS sp_update_member_class;
DELIMITER //
CREATE PROCEDURE sp_update_member_class (
	IN p_memberClassID INT,
	IN p_newMemberID INT,
	IN p_newClassID INT,
	IN p_enrollmentDate DATE
)
BEGIN
	-- update record in MemberClasses where id matches
	UPDATE MemberClasses
	SET memberID = p_newMemberID, classID = p_newClassID, enrollmentDate = p_enrollmentDate
	WHERE memberClassID = p_memberClassID;
END //

DELIMITER ;

-- deletes memberclass row from MemberClasses entity
DROP PROCEDURE IF EXISTS sp_delete_member_class;
DELIMITER //
CREATE PROCEDURE sp_delete_member_class (
	IN p_memberClassID INT
)
BEGIN
	-- delete record in MemberClasses where id matches
	DELETE FROM MemberClasses
	WHERE memberClassID = p_memberClassID;
END //

DELIMITER ;