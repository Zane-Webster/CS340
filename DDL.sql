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

-- --------------------------------------------
-- DROP TABLES  -------------------------------
-- --------------------------------------------

DROP TABLE IF EXISTS MemberClasses;
DROP TABLE IF EXISTS Memberships;
DROP TABLE IF EXISTS Classes;
DROP TABLE IF EXISTS Members;
DROP TABLE IF EXISTS Trainers;

-- --------------------------------------------
-- CREATE TRAINERS TABLE  ---------------------
-- --------------------------------------------

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

-- --------------------------------------------
-- CREATE MEMBERS TABLE  ----------------------
-- --------------------------------------------

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
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- --------------------------------------------
-- CREATE CLASSES TABLE  ----------------------
-- --------------------------------------------

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
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- --------------------------------------------
-- CREATE MEMBERSHIPS TABLE  ------------------
-- --------------------------------------------

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
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- --------------------------------------------
-- CREATE MEMBERCLASSES TABLE  ----------------
-- --------------------------------------------

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
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_members_has_classes_classes1`
    FOREIGN KEY (`classID`)
    REFERENCES `Classes` (`classID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- --------------------------------------------
-- INSERT TRAINERS  ---------------------------
-- --------------------------------------------

INSERT INTO Trainers VALUES
(1, 'John', 'Smith', 'john@gym.com', 'Strength and conditioning specialist.'),
(2, 'Smith', 'John', 'smith@gym.com', 'Yoga and mobility specialist.'),
(3, 'Jane', 'Doe', 'jane@gym.com', 'Beginner specialist.');

-- --------------------------------------------
-- INSERT MEMBERS  ----------------------------
-- --------------------------------------------

INSERT INTO Members VALUES
(1, 'Alex', 'Alexson', 'alex@member.com', '5411234567', '2026-01-15', 1),
(2, 'Taylor', 'Smith', 'taylor@member.com', '5415415411', '2026-02-03', 2),
(3, 'Casey', 'Robinson', 'casey@member.com', NULL, '2026-03-20', 3),
(4, 'Jamie', 'Smith', 'jamie@member.com', '5115115111', '2026-04-01', NULL);

-- --------------------------------------------
-- INSERT CLASSES  ----------------------------
-- --------------------------------------------

INSERT INTO Classes VALUES
(1, 'Beginner Strength', 'Mondays at 6:00 PM', 20, 1),
(2, 'Morning Yoga', 'Wednesdays at 8:00 AM', 15, 2),
(3, 'Cardio Basics', 'Fridays at 5:30 PM', 25, 3);

-- --------------------------------------------
-- INSERT MEMBERSHIPS  ------------------------
-- --------------------------------------------

INSERT INTO Memberships VALUES
(1, 'Basic', 39.99, '2026-01-15', '2026-02-15', 1),
(2, 'Premium', 59.99, '2026-02-03', '2026-03-03', 2),
(3, 'Basic', 44.99, '2026-02-16', '2026-03-16', 1),
(4, 'Student', 29.99, '2026-03-20', '2026-04-20', 3);

-- --------------------------------------------
-- INSERT MEMBERCLASSES  ----------------------
-- --------------------------------------------

INSERT INTO MemberClasses VALUES
(1, 1, '2026-01-20'),
(1, 2, '2026-01-22'),
(2, 1, '2026-02-10'),
(3, 2, '2026-03-25'),
(4, 3, '2026-04-05');

SET FOREIGN_KEY_CHECKS=1;
COMMIT;