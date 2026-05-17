/*

PROJECT GROUP 73
- Caleb Webster
- Jason Hudson

Project Step 4 Draft
Additional PL/SQL code

*/

DROP PROCEDURE IF EXISTS DeleteJamieEnrollment;

DELIMITER //

CREATE PROCEDURE DeleteJamieEnrollment()
BEGIN
	DELETE MemberClasses FROM MemberClasses
	INNER JOIN Members ON MemberClasses.memberID = Members.memberID
	INNER JOIN Classes ON MemberClasses.classID = Classes.classID
	WHERE Members.email = 'jamie@member.com'
	AND Classes.className = 'Cardio Basics';
END //

DELIMITER ;