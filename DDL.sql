/*

PROJECT GROUP 73
- Caleb Webster
- Jason Hudson

Project Step 2 Draft
DDL with Sample Data 

CREATE statements generated using MySQL Forward Engineer

*/

SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT=0;

DROP TABLE IF EXISTS MemberClasses;
DROP TABLE IF EXISTS Memberships;
DROP TABLE IF EXISTS Classes;
DROP TABLE IF EXISTS Members;
DROP TABLE IF EXISTS Trainers;

CREATE TABLE Trainers (
  `trainerID` INT NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(50) NOT NULL,
  `lastName` VARCHAR(50) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `bio` VARCHAR(255) NULL,
  PRIMARY KEY (`trainerID`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `idtrainer_UNIQUE` (`trainerID` ASC) VISIBLE)
ENGINE = InnoDB;

CREATE TABLE Members (
  `memberID` INT NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(50) NOT NULL,
  `lastName` VARCHAR(50) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `phoneNumber` VARCHAR(15) NULL,
  `joinDate` DATE NOT NULL,
  `trainerID` INT NULL,
  PRIMARY KEY (`memberID`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  INDEX `fk_members_trainers1_idx` (`trainerID` ASC) VISIBLE,
  UNIQUE INDEX `idmember_UNIQUE` (`memberID` ASC) VISIBLE,
  CONSTRAINT `fk_members_trainers1`
    FOREIGN KEY (`trainerID`)
    REFERENCES `Trainers` (`trainerID`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE TABLE Classes (
  `classID` INT NOT NULL AUTO_INCREMENT,
  `className` VARCHAR(255) NOT NULL,
  `schedule` VARCHAR(255) NOT NULL,
  `capacity` INT NOT NULL,
  `trainerID` INT NOT NULL,
  PRIMARY KEY (`classID`),
  INDEX `fk_classes_trainers_idx` (`trainerID` ASC) VISIBLE,
  UNIQUE INDEX `idclass_UNIQUE` (`classID` ASC) VISIBLE,
  CONSTRAINT `fk_classes_trainers`
    FOREIGN KEY (`trainerID`)
    REFERENCES `Trainers` (`trainerID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE TABLE Memberships (
  `membershipID` INT NOT NULL AUTO_INCREMENT,
  `membershipName` VARCHAR(255) NOT NULL,
  `price` DECIMAL(6,2) NOT NULL,
  `startDate` DATE NOT NULL,
  `endDate` DATE NOT NULL,
  `memberID` INT NOT NULL,
  PRIMARY KEY (`membershipID`),
  INDEX `fk_memberships_members1_idx` (`memberID` ASC) VISIBLE,
  UNIQUE INDEX `idmembership_UNIQUE` (`membershipID` ASC) VISIBLE,
  CONSTRAINT `fk_memberships_members1`
    FOREIGN KEY (`memberID`)
    REFERENCES `Members` (`memberID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE TABLE MemberClasses (
  `memberID` INT NOT NULL,
  `classID` INT NOT NULL,
  `enrollmentDate` DATE NOT NULL,
  INDEX `fk_members_has_classes_classes1_idx` (`classID` ASC) VISIBLE,
  INDEX `fk_members_has_classes_members1_idx` (`memberID` ASC) VISIBLE,
  PRIMARY KEY (`classID`, `memberID`),
  CONSTRAINT `fk_members_has_classes_members1`
    FOREIGN KEY (`memberID`)
    REFERENCES `Members` (`memberID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_members_has_classes_classes1`
    FOREIGN KEY (`classID`)
    REFERENCES `Classes` (`classID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

INSERT INTO Trainers
(firstName, lastName, email, bio)
VALUES
('John', 'Smith', 'john@gym.com', 'Strength and conditioning specialist.'),
('Smith', 'John', 'smith@gym.com', 'Yoga and mobility specialist.'),
('Jane', 'Doe', 'jane@gym.com', 'Beginner specialist.');

INSERT INTO Members
(firstName, lastName, email, phoneNumber, joinDate, trainerID)
VALUES
('Alex', 'Alexson', 'alex@member.com', '5411234567', '2026-01-15',
  (SELECT trainerID FROM Trainers WHERE email = 'john@gym.com')),
('Taylor', 'Smith', 'taylor@member.com', '5415415411', '2026-02-03',
  (SELECT trainerID FROM Trainers WHERE email = 'smith@gym.com')),
('Casey', 'Robinson', 'casey@member.com', NULL, '2026-03-20',
  (SELECT trainerID FROM Trainers WHERE email = 'jane@gym.com')),
('Jamie', 'Smith', 'jamie@member.com', '5115115111', '2026-04-01', NULL);

INSERT INTO Classes
(className, schedule, capacity, trainerID)
VALUES
('Beginner Strength', 'Mondays at 6:00 PM', 20,
  (SELECT trainerID FROM Trainers WHERE email = 'john@gym.com')),
('Morning Yoga', 'Wednesdays at 8:00 AM', 15,
  (SELECT trainerID FROM Trainers WHERE email = 'smith@gym.com')),
('Cardio Basics', 'Fridays at 5:30 PM', 25,
  (SELECT trainerID FROM Trainers WHERE email = 'jane@gym.com'));

INSERT INTO Memberships
(membershipName, price, startDate, endDate, memberID)
VALUES
('Basic', 39.99, '2026-01-15', '2026-02-15',
  (SELECT memberID FROM Members WHERE email = 'alex@member.com')),
('Premium', 59.99, '2026-02-03', '2026-03-03',
  (SELECT memberID FROM Members WHERE email = 'taylor@member.com')),
('Basic', 44.99, '2026-02-16', '2026-03-16',
  (SELECT memberID FROM Members WHERE email = 'alex@member.com')),
('Student', 29.99, '2026-03-20', '2026-04-20',
  (SELECT memberID FROM Members WHERE email = 'casey@member.com'));

INSERT INTO MemberClasses
(memberID, classID, enrollmentDate)
VALUES
((SELECT memberID FROM Members WHERE email = 'alex@member.com'),
 (SELECT classID FROM Classes WHERE className = 'Beginner Strength'),
 '2026-01-20'),
((SELECT memberID FROM Members WHERE email = 'alex@member.com'),
 (SELECT classID FROM Classes WHERE className = 'Morning Yoga'),
 '2026-01-22'),
((SELECT memberID FROM Members WHERE email = 'taylor@member.com'),
 (SELECT classID FROM Classes WHERE className = 'Beginner Strength'),
 '2026-02-10'),
((SELECT memberID FROM Members WHERE email = 'casey@member.com'),
 (SELECT classID FROM Classes WHERE className = 'Morning Yoga'),
 '2026-03-25'),
((SELECT memberID FROM Members WHERE email = 'jamie@member.com'),
 (SELECT classID FROM Classes WHERE className = 'Cardio Basics'),
 '2026-04-05');

SET FOREIGN_KEY_CHECKS=1;
COMMIT;