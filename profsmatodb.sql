-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema profsmato
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `profsmato` ;

-- -----------------------------------------------------
-- Schema profsmato
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `profsmato` DEFAULT CHARACTER SET utf8 ;
USE `profsmato` ;

-- -----------------------------------------------------
-- Table `profsmato`.`Colleges`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `profsmato`.`Colleges` ;

CREATE TABLE IF NOT EXISTS `profsmato`.`Colleges` (
  `collegeID` VARCHAR(10) NOT NULL,
  `collegeName` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`collegeID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `profsmato`.`Departments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `profsmato`.`Departments` ;

CREATE TABLE IF NOT EXISTS `profsmato`.`Departments` (
  `departmentId` VARCHAR(10) NOT NULL,
  `attachedCollege` VARCHAR(10) NOT NULL,
  `departmentName` VARCHAR(80) NOT NULL,
  PRIMARY KEY (`departmentId`, `attachedCollege`),
  INDEX `fk_Departments_College_idx` (`attachedCollege` ASC),
  CONSTRAINT `fk_Departments_College`
    FOREIGN KEY (`attachedCollege`)
    REFERENCES `profsmato`.`Colleges` (`collegeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `profsmato`.`Degrees`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `profsmato`.`Degrees` ;

CREATE TABLE IF NOT EXISTS `profsmato`.`Degrees` (
  `degreeCode` VARCHAR(10) NOT NULL,
  `attachedCollege` VARCHAR(10) NOT NULL,
  `programName` VARCHAR(130) NOT NULL,
  PRIMARY KEY (`degreeCode`, `attachedCollege`),
  INDEX `fk_courses_College1_idx` (`attachedCollege` ASC),
  CONSTRAINT `fk_courses_College1`
    FOREIGN KEY (`attachedCollege`)
    REFERENCES `profsmato`.`Colleges` (`collegeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `profsmato`.`ref_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `profsmato`.`ref_status` ;

CREATE TABLE IF NOT EXISTS `profsmato`.`ref_status` (
  `statusId` INT(2) NOT NULL AUTO_INCREMENT,
  `status` VARCHAR(45) NULL,
  PRIMARY KEY (`statusId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `profsmato`.`Students`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `profsmato`.`Students` ;

CREATE TABLE IF NOT EXISTS `profsmato`.`Students` (
  `studentEmail` VARCHAR(50) NOT NULL,
  `username` VARCHAR(60) NOT NULL,
  `password` VARCHAR(50) NOT NULL,
  `lastname` VARCHAR(45) NOT NULL,
  `firstname` VARCHAR(45) NOT NULL,
  `program` VARCHAR(10) NULL,
  `status` INT(2) NOT NULL,
  `about` VARCHAR(70) NULL,
  `profilepic` TEXT NULL,
  `userType` ENUM('student', 'admin') NOT NULL,
  PRIMARY KEY (`studentEmail`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC),
  INDEX `fk_Students_Courses2_idx` (`program` ASC),
  INDEX `fk_Students_ref_status1_idx` (`status` ASC),
  CONSTRAINT `fk_Students_Courses2`
    FOREIGN KEY (`program`)
    REFERENCES `profsmato`.`Degrees` (`degreeCode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Students_ref_status1`
    FOREIGN KEY (`status`)
    REFERENCES `profsmato`.`ref_status` (`statusId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `profsmato`.`Professors`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `profsmato`.`Professors` ;

CREATE TABLE IF NOT EXISTS `profsmato`.`Professors` (
  `profEmail` VARCHAR(50) NOT NULL,
  `lastname` VARCHAR(45) NOT NULL,
  `firstname` VARCHAR(45) NOT NULL,
  `department` VARCHAR(10) NULL,
  `about` VARCHAR(70) NULL,
  `profPicture` TEXT NULL,
  `status` INT(2) NULL,
  INDEX `fk_Professors_Departments2_idx` (`department` ASC),
  INDEX `fk_Professors_ref_status1_idx` (`status` ASC),
  PRIMARY KEY (`profEmail`),
  CONSTRAINT `fk_Professors_Departments2`
    FOREIGN KEY (`department`)
    REFERENCES `profsmato`.`Departments` (`departmentId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Professors_ref_status1`
    FOREIGN KEY (`status`)
    REFERENCES `profsmato`.`ref_status` (`statusId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `profsmato`.`Courses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `profsmato`.`Courses` ;

CREATE TABLE IF NOT EXISTS `profsmato`.`Courses` (
  `courseCode` VARCHAR(7) NOT NULL,
  `courseName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`courseCode`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `profsmato`.`ref_contact`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `profsmato`.`ref_contact` ;

CREATE TABLE IF NOT EXISTS `profsmato`.`ref_contact` (
  `ref_contactId` INT(2) NOT NULL AUTO_INCREMENT,
  `contactType` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ref_contactId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `profsmato`.`Contacts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `profsmato`.`Contacts` ;

CREATE TABLE IF NOT EXISTS `profsmato`.`Contacts` (
  `personId` VARCHAR(50) NOT NULL,
  `contactDetail` VARCHAR(60) NOT NULL,
  `persontType` ENUM('student', 'prof') NOT NULL,
  `contactType` INT(2) NOT NULL,
  PRIMARY KEY (`personId`, `contactDetail`),
  INDEX `fk_Contacts_ref_contact1_idx` (`contactType` ASC),
  CONSTRAINT `fk_Contacts_ref_contact1`
    FOREIGN KEY (`contactType`)
    REFERENCES `profsmato`.`ref_contact` (`ref_contactId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Contacts_Students1`
    FOREIGN KEY (`personId`)
    REFERENCES `profsmato`.`Students` (`studentEmail`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Contacts_Professors1`
    FOREIGN KEY (`personId`)
    REFERENCES `profsmato`.`Professors` (`profEmail`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `profsmato`.`prof_courses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `profsmato`.`prof_courses` ;

CREATE TABLE IF NOT EXISTS `profsmato`.`prof_courses` (
  `profEmail` VARCHAR(50) NOT NULL,
  `coursesCode` VARCHAR(7) NOT NULL,
  PRIMARY KEY (`profEmail`, `coursesCode`),
  INDEX `fk_prof_subject_Subjects1_idx` (`coursesCode` ASC),
  CONSTRAINT `fk_prof_subject_Professors1`
    FOREIGN KEY (`profEmail`)
    REFERENCES `profsmato`.`Professors` (`profEmail`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_prof_subject_Subjects1`
    FOREIGN KEY (`coursesCode`)
    REFERENCES `profsmato`.`Courses` (`courseCode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `profsmato`.`ref_reviewComment_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `profsmato`.`ref_reviewComment_status` ;

CREATE TABLE IF NOT EXISTS `profsmato`.`ref_reviewComment_status` (
  `statusId` INT(2) NOT NULL AUTO_INCREMENT,
  `status` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`statusId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `profsmato`.`Reviews`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `profsmato`.`Reviews` ;

CREATE TABLE IF NOT EXISTS `profsmato`.`Reviews` (
  `reviewId` INT(11) NOT NULL AUTO_INCREMENT,
  `studentEmail` VARCHAR(50) NOT NULL,
  `profEmail` VARCHAR(50) NOT NULL,
  `rating` INT(1) NOT NULL,
  `title` VARCHAR(60) NOT NULL,
  `body` VARCHAR(245) NOT NULL,
  `timestamp` DATETIME NOT NULL,
  `status` INT(2) NOT NULL,
  PRIMARY KEY (`reviewId`),
  INDEX `fk_Reviews_Students1_idx` (`studentEmail` ASC),
  INDEX `fk_Reviews_Professors1_idx` (`profEmail` ASC),
  UNIQUE INDEX `studentEmail_UNIQUE` (`studentEmail` ASC),
  UNIQUE INDEX `profEmail_UNIQUE` (`profEmail` ASC),
  INDEX `fk_Reviews_ref_reviewComment_status1_idx` (`status` ASC),
  CONSTRAINT `fk_Reviews_Students1`
    FOREIGN KEY (`studentEmail`)
    REFERENCES `profsmato`.`Students` (`studentEmail`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Reviews_Professors1`
    FOREIGN KEY (`profEmail`)
    REFERENCES `profsmato`.`Professors` (`profEmail`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Reviews_ref_reviewComment_status1`
    FOREIGN KEY (`status`)
    REFERENCES `profsmato`.`ref_reviewComment_status` (`statusId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `profsmato`.`review_reacts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `profsmato`.`review_reacts` ;

CREATE TABLE IF NOT EXISTS `profsmato`.`review_reacts` (
  `reviewId` INT(11) NOT NULL,
  `student` VARCHAR(50) NOT NULL,
  `react` ENUM('Like', 'Dislike') NOT NULL,
  PRIMARY KEY (`reviewId`, `student`),
  INDEX `fk_review_reacts_Students1_idx` (`student` ASC),
  CONSTRAINT `fk_review_reacts_Reviews1`
    FOREIGN KEY (`reviewId`)
    REFERENCES `profsmato`.`Reviews` (`reviewId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_review_reacts_Students1`
    FOREIGN KEY (`student`)
    REFERENCES `profsmato`.`Students` (`studentEmail`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `profsmato`.`Comments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `profsmato`.`Comments` ;

CREATE TABLE IF NOT EXISTS `profsmato`.`Comments` (
  `commentId` INT(11) NOT NULL AUTO_INCREMENT,
  `reviewId` INT(11) NOT NULL,
  `studentEmail` VARCHAR(50) NOT NULL,
  `commentBody` VARCHAR(100) NOT NULL,
  `timestamp` DATETIME NOT NULL,
  `status` INT(2) NOT NULL,
  PRIMARY KEY (`commentId`, `reviewId`),
  INDEX `fk_Comments_Reviews1_idx` (`reviewId` ASC),
  INDEX `fk_Comments_ref_reviewComment_status1_idx` (`status` ASC),
  CONSTRAINT `fk_Comments_Reviews1`
    FOREIGN KEY (`reviewId`)
    REFERENCES `profsmato`.`Reviews` (`reviewId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Comments_ref_reviewComment_status1`
    FOREIGN KEY (`status`)
    REFERENCES `profsmato`.`ref_reviewComment_status` (`statusId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `profsmato`.`Reports`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `profsmato`.`Reports` ;

CREATE TABLE IF NOT EXISTS `profsmato`.`Reports` (
  `reportId` INT(11) NOT NULL AUTO_INCREMENT,
  `studentReported` VARCHAR(50) NOT NULL,
  `timestamp` DATETIME NOT NULL,
  `reason` VARCHAR(100) NOT NULL,
  `reviewId` INT(11) NULL,
  `commentId` INT(11) NULL,
  `isResolved` TINYINT(1) NOT NULL,
  `actionTaken` VARCHAR(100) NULL,
  PRIMARY KEY (`reportId`),
  INDEX `fk_Reports_Reviews1_idx` (`reviewId` ASC),
  INDEX `fk_Reports_Comments1_idx` (`commentId` ASC),
  CONSTRAINT `fk_Reports_Reviews1`
    FOREIGN KEY (`reviewId`)
    REFERENCES `profsmato`.`Reviews` (`reviewId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Reports_Comments1`
    FOREIGN KEY (`commentId`)
    REFERENCES `profsmato`.`Comments` (`reviewId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `profsmato`.`Colleges`
-- -----------------------------------------------------
START TRANSACTION;
USE `profsmato`;
INSERT INTO `profsmato`.`Colleges` (`collegeID`, `collegeName`) VALUES ('CCS', 'College of Computer Studies');
INSERT INTO `profsmato`.`Colleges` (`collegeID`, `collegeName`) VALUES ('BAGCED', 'College of Education');
INSERT INTO `profsmato`.`Colleges` (`collegeID`, `collegeName`) VALUES ('CLA', 'College of Liberal Arts');
INSERT INTO `profsmato`.`Colleges` (`collegeID`, `collegeName`) VALUES ('COS', 'College of Science');
INSERT INTO `profsmato`.`Colleges` (`collegeID`, `collegeName`) VALUES ('GCOE', 'Gokongwei College of Engineering');
INSERT INTO `profsmato`.`Colleges` (`collegeID`, `collegeName`) VALUES ('COB', 'College of Business');
INSERT INTO `profsmato`.`Colleges` (`collegeID`, `collegeName`) VALUES ('SOE', 'School of Economics');
INSERT INTO `profsmato`.`Colleges` (`collegeID`, `collegeName`) VALUES ('COL', 'College of Law');

COMMIT;


-- -----------------------------------------------------
-- Data for table `profsmato`.`Departments`
-- -----------------------------------------------------
START TRANSACTION;
USE `profsmato`;
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('CT', 'CCS', 'Computer Technology');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('ST', 'CCS', 'Information Technology');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('IT', 'CCS', 'Software Technology');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('CEPD', 'BAGCED', 'Counseling and Educational Psychology Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('ELMD', 'BAGCED', 'Educational Leadership and Management Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('DEAL', 'BAGCED', 'Department of English and Applied Linguistics');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('PED', 'BAGCED', 'Physical Education Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('SED', 'BAGCED', 'Science Education Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('COL', 'COL', 'College of Law');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('BHS', 'CLA', 'Behavioral Sciences Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('COM', 'CLA', 'Department of Communication');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('FIL', 'CLA', 'Filipino Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('HIS', 'CLA', 'History Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('INT', 'CLA', 'International Studies Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('LIT', 'CLA', 'Literature Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('PHILO', 'CLA', 'Philosophy Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('POLISCI', 'CLA', 'Political Science Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('PSYC', 'CLA', 'Psychology Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('THEO', 'CLA', 'Theology and Religious Studies Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('BIO', 'COS', 'Biology Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('CHEM', 'COS', 'Chemistry Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('MATH', 'COS', 'Mathematics Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('PHY', 'COS', 'Physics Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('CHEME', 'GCOE', 'Chemical Engineering Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('CIVIL', 'GCOE', 'Civil Engineering Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('ECED', 'GCOE', 'Electronics and Communications Engineering Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('IED', 'GCOE', 'Industrial Engineering Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('MEMD', 'GCOE', 'Manufacturing Engineering and Management Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('MED', 'GCOE', 'Mechanical Engineering Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('ACCT', 'COB', 'Accountancy Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('CLD', 'COB', 'Commercial Law Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('DSID', 'COB', 'Decision Sciences and Innovation Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('FMD', 'COB', 'Financial Management Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('MOD', 'COB', 'Management and Organization Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('MMD', 'COB', 'Marketing Management Department');
INSERT INTO `profsmato`.`Departments` (`departmentId`, `attachedCollege`, `departmentName`) VALUES ('ECO', 'SOE', 'Economics Department');

COMMIT;


-- -----------------------------------------------------
-- Data for table `profsmato`.`Degrees`
-- -----------------------------------------------------
START TRANSACTION;
USE `profsmato`;
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('CS-CSE', 'CCS', 'BS Computer Science Major in Computer Systems Engineering');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('CS-NE', 'CCS', 'BS Computer Science with Specialization in Network Engineering');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('CS-ST', 'CCS', 'BS Computer Science with Specialization in Software Technology');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('CS-IST', 'CCS', 'BS Computer Science with Specialization in Instructional Systems Technology');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BS-INSYS', 'CCS', 'BS Information Systems');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BSIT', 'CCS', 'BS Information Technology');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('JDCTR', 'COL', 'Juris Doctor');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BSAEC', 'SOE', 'Bachelor of Science in Applied Economics major in Industrial Economics ');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BSAE2', 'SOE', 'Bachelor of Science in Applied Economics major in Industrial Economics and Bachelor of Science in Accountancy');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BSA', 'COB', 'Bachelor of Science in Accountancy');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BSADV', 'COB', 'Bachelor of Science in Advertising Management');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BSMGT', 'COB', 'Bachelor of Science in Business Management');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BSAPC', 'COB', 'Bachelor of Science in Applied Corporate Management');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BSMKT', 'COB', 'Bachelor of Science in Marketing Management');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BSCHE', 'GCOE', 'Bachelor of Science in Chemical Engineering');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BSCPE', 'GCOE', 'Bachelor of Science in Computer Engineering');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BSECE', 'GCOE', 'Bachelor of Science in Electronics Engineering');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BSIE', 'GCOE', 'Bachelor of Science in Industrial Engineering');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BSBIO', 'COS', 'Bachelor of Science in Biology ');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BSCHY', 'COS', 'Bachelor of Science in Chemistry');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BHBIO', 'COS', 'Bachelor of Science in Human Biology ');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BSMTH', 'COS', 'Bachelor of Science in Mathematics ');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BSSTT', 'COS', 'Bachelor of Science in Statistics major in Actuarial Science');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('ABBHS', 'CLA', 'Bachelor of Arts in Behavioral Sciences major in Organizational and Social Systems Development ');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('AB-HIS', 'CLA', 'Bachelor of Arts in History');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('ABIS', 'CLA', 'Bachelor of Arts in International Studies');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('AB-LIT', 'CLA', 'Bachelor of Arts in Literature');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BEED', 'BAGCED', 'Bachelor of Science, Major in Early Childhood Education');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BSED-ENGL', 'BAGCED', 'Bachelor of Secondary Education, major in English');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BSED-BIO', 'BAGCED', 'Bachelor of Secondary Education Major in Biology');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BSED-CHY', 'BAGCED', 'Bachelor of Secondary Education Major in Chemistry');
INSERT INTO `profsmato`.`Degrees` (`degreeCode`, `attachedCollege`, `programName`) VALUES ('BSED-MTH', 'BAGCED', 'Bachelor of Secondary Education, major in Mathematics');

COMMIT;


-- -----------------------------------------------------
-- Data for table `profsmato`.`ref_status`
-- -----------------------------------------------------
START TRANSACTION;
USE `profsmato`;
INSERT INTO `profsmato`.`ref_status` (`statusId`, `status`) VALUES (1, 'active');
INSERT INTO `profsmato`.`ref_status` (`statusId`, `status`) VALUES (2, 'pending');
INSERT INTO `profsmato`.`ref_status` (`statusId`, `status`) VALUES (3, 'inactive');

COMMIT;


-- -----------------------------------------------------
-- Data for table `profsmato`.`Students`
-- -----------------------------------------------------
START TRANSACTION;
USE `profsmato`;
INSERT INTO `profsmato`.`Students` (`studentEmail`, `username`, `password`, `lastname`, `firstname`, `program`, `status`, `about`, `profilepic`, `userType`) VALUES ('yuta_inoue@dlsu.edu.ph', 'Tatachiblob', 'yutainoue', 'Inoue', 'Yuta', 'BSIT', 1, 'I am Yuta Inoue.', 'default.png', 'student');
INSERT INTO `profsmato`.`Students` (`studentEmail`, `username`, `password`, `lastname`, `firstname`, `program`, `status`, `about`, `profilepic`, `userType`) VALUES ('ivana_lim@dlsu.edu.ph', 'poisonivysaurbridge', 'ivylim', 'Lim', 'Ivy', 'BSIT', 1, 'I am Ivy Lim.', 'default.png', 'admin');
INSERT INTO `profsmato`.`Students` (`studentEmail`, `username`, `password`, `lastname`, `firstname`, `program`, `status`, `about`, `profilepic`, `userType`) VALUES ('nigel_tan@dlsu.edu.ph', 'nigeltan', 'nigeltan', 'Tan', 'Nigel', 'BSIT', 1, 'I am Nigel Tan.', 'default.png', 'student');
INSERT INTO `profsmato`.`Students` (`studentEmail`, `username`, `password`, `lastname`, `firstname`, `program`, `status`, `about`, `profilepic`, `userType`) VALUES ('john_andrew_santiago@dlsu.edu.ph', 'andrewsantiago', 'andrewsantiago', 'Santiago', 'John Andrew', 'BSIT', 1, 'I am Andrew Santiago.', 'default.png', 'student');

COMMIT;


-- -----------------------------------------------------
-- Data for table `profsmato`.`Professors`
-- -----------------------------------------------------
START TRANSACTION;
USE `profsmato`;
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('frederico_ang@dlsu.edu.ph', 'Ang', 'Frederico', 'CT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('judith_azcarraga@dlsu.edu.ph', 'Azcarraga', 'Judith', 'CT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('alexie_ballon@dlsu.edu.ph', 'Ballon', 'Alexie', 'CT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('macario_cordel@dlsu.edu.ph', 'Cordel II', 'Macario', 'CT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('fritz_flores@dlsu.edu.ph', 'Flores', 'Fritz Kevin', 'CT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('geanne_franco@dlsu.edu.ph', 'Franco', 'Geanne', 'CT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('joel_ilao@dlsu.edu.ph', 'Ilao', 'Joel', 'CT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('franchesca_laguna@dlsu.edu.ph', 'Laguna', 'Ann Franchesca', 'CT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('karen_nomorosa@dlsu.edu.ph', 'Nomorosa', 'Karen', 'CT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('arlyn_ong@dlsu.edu.ph', 'Ong', 'Arlyn', 'CT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('marnel_peradilla@dlsu.edu.ph', 'Peradilla', 'Marnel', 'CT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('katrina_solomon@dlsu.edu.ph', 'Solomon', 'Katrina Ysabel', 'CT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('roger_uy@dlsu.edu.ph', 'Uy', 'Roger Luis', 'CT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('pierre_abesamis@dlsu.edu.ph', 'Abesamis', 'Pierre', 'IT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('jane_arcilla@dlsu.edu.ph', 'Arcilla', 'Mary Jane', 'IT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('estefanie_bertumen@dlsu.edu.ph', 'Bertumen', 'Estefanie', 'IT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('danny_cheng@dlsu.edu.ph', 'Cheng', 'Danny', 'IT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('michelle_ching@dlsu.edu.ph', 'Ching', 'Michelle Renee', 'IT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('alain_encarnacion@dlsu.edu.ph', 'Encarnacion', 'Alain Lizardo', 'IT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('christine_lim@dlsu.edu.ph', 'Lim', 'Christine Diane', 'IT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('oliver_malabanan@dlsu.edu.ph', 'Malabanan', 'Oliver', 'IT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('renato_molano@dlsu.edu.ph', 'Molano', 'Renato Jose Maria', 'IT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('loreto_sibayan@dlsu.edu.ph', 'Sibayan', 'Loreto', 'IT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('glenn_sipin@dlsu.edu.ph', 'Sipin', 'Glenn', 'IT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('liandro_tabora@dlsu.edu.ph', 'Tabora', 'Liandro Antonio', 'IT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('marivic_tangkeko@dlsu.edu.ph', 'Tangkeko', 'Marivic', 'IT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('geneva_timonera@dlsu.edu.ph', 'Timonera', 'Geneva Mara', 'IT', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('emerico_auilar@dlsu.edu.ph', 'Aguilar', 'Emerico', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('arnulfo_azcarraga@dlsu.edu.ph', 'Arnulfo', 'Azcarraga', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('juan_balbin@dlsu.edu.ph', 'Balbin', 'Juan Paolo', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('allan_borra@dlsu.edu.ph', 'Borra', 'Allan', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('remedios_bulos@dlsu.edu.ph', 'Bulos', 'Remedios de Dios', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('refael_cabredo@dlsu.edu.ph', 'Carbredo', 'Rafael', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('arturo_caronongan@dlsu.edu.ph', 'Caronongan', 'Arturo III', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('natalie_cheng@dlsu.edu.ph', 'Cheng', 'Natalie Lim', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('shirley_chu@dlsu.edu.ph', 'Chu', 'Shirley', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('gregory_cu@dlsu.edu.ph', 'Cu', 'Gregory', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('jordan_deja@dlsu.edu.ph', 'Deja', 'Jordan Aiko', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('neil_delgallego@dlsu.edu.ph', 'Del Gallego', 'Neil Patrick', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('ryan_dimaunahan@dlsu.edu.ph', 'Dimaunahan', 'Ryan Samuael', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('christine_gendrano@dlsu.edu.ph', 'Gendrano', 'Christine', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('nathalie_lim@dlsu.edu.ph', 'Lim-Cheng', 'Nathalie', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('teresita_limoanco@dlsu.edu.ph', 'Limoanco', 'Tereita', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('patrice_lu@dlsu.edu.ph', 'Lu', 'Louis Patrice', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('nelson_marcos@dlsu.edu.ph', 'Marcos', 'Nelson', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('emilio_moghareh@dlsu.edu.ph', 'Moghareh', 'Emilio Ramin', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('courtney_ngo@dlsu.edu.ph', 'Ngo', 'Courtney Anne', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('ethel_ong@dlsu.edu.ph', 'Ong', 'Ethel Joy Chua', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('jemie_que@dlsu.edu.ph', 'Que', 'Jemie', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('ralph_regalado@dlsu.edu.ph', 'Regalado', 'Ralph Vincent', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('conrado_ruiz@dlsu.edu.ph', 'Ruiz', 'Conrado Jr.', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('florante_salvador@dlsu.edu.ph', 'Salvador', 'Forante Rofule', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('briannne_samson@dlsu.edu.ph', 'Samson', 'Brianne Paul', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('john_santillana@dlsu.edu.ph', 'Santillana', 'John Alexander', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('solomon_see@dlsu.edu.ph', 'See', 'Solomon', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('raymund_sison@dlsu.edu.ph', 'Sison', 'Raymund', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('daniel_tan@dlsu.edu.ph', 'Tan', 'Daniel Stanley', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('thomas_tiamlee@dlsu.edu.ph', 'Tiam-Lee', 'Thomas James', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('edward_tighe@dlsu.edu.ph', 'Tighe', 'Edward', 'ST', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('esperanza_agoo@dlsu.edu.ph', 'Agoo', 'Esperanza', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('zeba_alam@dlsu.edu.ph', 'Alam', 'Zeba Farooqi', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('noel_alfonso@dlsu.edu.ph', 'Alfonso', 'Noel', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('divina_amalin@dlsu.edu.ph', 'Amalin', 'Divina', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('doree_arzadon@dlsu.edu.ph', 'Arzadon', 'Doree Esmeralda', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('esperanza_cabrera@dlsu.edu.ph', 'Cabrera', 'Esperanza', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('pacifico_calderon@dlsu.edu.ph', 'Calderon', 'Pacifico Eric', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('patricio_cantilier@dlsu.edu.ph', 'Cantilier', 'Patricio', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('chona_cruz@dlsu.edu.ph', 'Cruz', 'Chona Camille', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('deocaris_custer@dlsu.edu.ph', 'Custer', 'Deocaris', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('elenita_decastro@dlsu.edu.ph', 'De Castro', 'Elenita', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('marie_reyes@dlsu.edu.ph', 'De Los Reyes', 'Marie', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('addah_deperalta@dlsu.edu.ph', 'De Peralta', 'Addah', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('christian_delarosa@dlsu.edu.ph', 'Dela Rosa', 'Christian Jordan', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('mariquit_delosreyes@dlsu.edu.ph', 'Delos Reyes', 'Mariquit', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('joy_esperanza@dlsu.edu.ph', 'Esperanza', 'Joy', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('mary_flores@dlsu.edu.ph', 'Flores', 'Mary Jane', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('jose_janairo@dlsu.edu.ph', 'Janairo', 'Jose', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('nadine_ledesma@dlsu.edu.ph', 'Ledesma', 'Nadine', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('virgilio_linis@dlsu.edu.ph', 'Linis', 'Virgilio', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('eligio_maghirang@dlsu.edu.ph', 'Maghirang', 'Eligio', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('ederlina_ocon@dlsu.edu.ph', 'Ocon', 'Ederlina', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('melissa_pecundo@dlsu.edu.ph', 'Pecundo', 'Melissa', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('micheal_ples@dlsu.edu.ph', 'Ples', 'Micheal', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('gliceria_ramos@dlsu.edu.ph', 'Ramos', 'Gliceria', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('dennis_raga@dlsu.edu.ph', 'Raga', 'Dennis', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('cecilia_reyes@dlsu.edu.ph', 'Reyes', 'Cecilia', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('jesus_sevilleja@dlsu.edu.ph', 'Sevilleja', 'Jesus Emmanuel', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('carlene_solidum@dlsu.edu.ph', 'Solidum', 'Carlene', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('derickerl_sumalapao@dlsu.edu.ph', 'Sumalapao', 'Derick Erl', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('chrisitan_supsup@dlsu.edu.ph', 'Supsup', 'Christian', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('marigold_uba@dlsu.edu.ph', 'Uba', 'Marigold', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('rodel_vitor@dlsu.edu.ph', 'Vitor II', 'Rodel Jonathan', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('lawrence_vitug@dlsu.edu.ph', 'Vitug', 'Lawrence', 'BIO', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('laurenzo_alba@dlsu.edu.ph', 'Alba', 'Laurenzo', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('glenn_alea@dlsu.edu.ph', 'Alea', 'Glenn', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('jonah_bondoc@dlsu.edu.ph', 'Jonah', 'Bondoc', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('janmicheal_cayme@dlsu.edu.ph', 'Cayme', 'Jan-Micheal', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('wilfred_chung@dlsu.edu.ph', 'Chung', 'Wilfred', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('rafael_espiritu@dlsu.edu.ph', 'Espiritu', 'Rafael', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('darcy_garza@dlsu.edu.ph', 'Garza', 'Darcy', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('lourdes_guidote@dlsu.edu.ph', 'Guidote', 'Lourdes', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('jaime_janairo@dlsu.edu.ph', 'Janairo', 'Jaime', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('faith_lagua@dlsu.edu.ph', 'Lagua', 'Faith', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('nancy_lazaro@dlsu.edu.ph', 'Lazaro-Llanos', 'Nancy', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('carlo_ng@dlsu.edu.ph', 'Ng', 'Carlo Antonio', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('vincent_ng@dlsu.edu.ph', 'Ng', 'Vincent Antonio', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('julius_nunez@dlsu.edu.ph', 'Nunez', 'Julius Andrew', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('candy_ondevilla@dlsu.edu.ph', 'Ondevilla', 'Candy', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('sarah_ong@dlsu.edu.ph', 'Ong', 'Sarah Diane', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('david_penaloza@dlsu.edu.ph', 'Penaloza', 'David', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('eric_punzalan@dlsu.edu.ph', 'Punzalan', 'Eric Camilo', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('nesse_ressureccion@dlsu.edu.ph', 'Resuureccion', 'Nesse', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('therese_rosbero@dlsu.edu.ph', 'Rosbero', 'Therese', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('regina_salmasan@dlsu.edu.ph', 'Salmasan', 'Regina', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('rodolfo_simayao@dlsu.edu.ph', 'Simayao', 'Rodolfo', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('ryan_sytu@dlsu.edu.ph', 'Sytu', 'Ryan', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('everlyn_tamayo@dlsu.edu.ph', 'Tamayo', 'Everlyn', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('roger_tan@dlsu.edu.ph', 'Tan', 'Roger', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('peter_tenido@dlsu.edu.ph', 'Tenido', 'Peter', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('phoebe_trio@dlsu.edu.ph', 'Trio', 'Phoebe Zapanta', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('joey_valinton@dlsu.edu.ph', 'Valinton', 'Joey', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('derrick_yu@dlsu.edu.ph', 'Yu', 'Derrick Ethelbhert', 'CHEM', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('maxima_acelajado@dlsu.edu.ph', 'Acelajado', 'Maxima', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('angelo_alberto@dlsu.edu.ph', 'Alberto', 'Angelo', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('john_alcantara@dlsu.edu.ph', 'Alcantara', 'John Harold', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('francis_campena@dlsu.edu.ph', 'Campena', 'Francis Joseph', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('luisette_candelaria@dlsu.edu.ph', 'Candelaria', 'Luisette', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('rafael_cantuba@dlsu.edu.ph', 'Cantuba', 'Rafael Reno', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('riza_carasig@dlsu.edu.ph', 'Carasig', 'Riza', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('avegail_carpio@dlsu.edu.ph', 'Carpio', 'Avegail', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('kristine_carpio@dlsu.edu.ph', 'Carpio', 'Kristine Joy', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('frumencio_co@dlsu.edu.ph', 'Co', 'Frumencio', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('harris_delacruz@dlsu.edu.ph', 'Dela Cruz', 'Harris', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('ronald_florendo@dlsu.edu.ph', 'Florendo', 'Ronald', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('mark_garcia@dlsu.edu.ph', 'Garcia', 'Mark Anthony', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('clarence_gatchalian@dlsu.edu.ph', 'Gatchalian', 'Clarence', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('alana_hernandez@dlsu.edu.ph', 'Hernandez', 'Alana Margarita', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('isagani_jos@dlsu.edu.ph', 'Jos', 'Isagani', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('angelyn_lao@dlsu.edu.ph', 'Lao', 'Angelyn', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('mong_llarenas@dlsu.edu.ph', 'Llarenas', 'Mong', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('brian_lopez@dlsu.edu.ph', 'Lopez', 'Brian', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('leah_martin@dlsu.edu.ph', 'Martin-Lundag', 'Leah', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('ederlina_nocon@dlsu.edu.ph', 'Nocon', 'Ederlina', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('shirlee_ocampo@dlsu.edu.ph', 'Ocampo', 'Shirlee', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('christine_octavo@dlsu.edu.ph', 'Octavo', 'Christine Joy', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('anita_ong@dlsu.edu.ph', 'Ong', 'Anita', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('arturo_pacificador@dlsu.edu.ph', 'Pacificador', 'Arturo', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('shera_pausang@dlsu.edu.ph', 'Pausang', 'Shera Marie', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('edmundo_perez@dlsu.edu.ph', 'Perez Jr', 'Edmundo', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('rigor_ponsones@dlsu.edu.ph', 'Ponsones', 'Rigor', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('jose_reyes@dlsu.edu.ph', 'Reyes', 'Jose Tristan', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('maria_reyes@dlsu.edu.ph', 'Reyes', 'Maria Angeli', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('leonor_ruividar@dlsu.edu.ph', 'Ruividar', 'Leonor', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('bernadette_santos@dlsu.edu.ph', 'Santos', 'Bernadette Louise', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('christopher_santos@dlsu.edu.ph', 'Santos', 'Christopher', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('diana_songsong@dlsu.edu.ph', 'Songsong', 'Diana Cerzo', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('derick_sumalapao@dlsu.edu.ph', 'Sumalapao', 'Derick Erl', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('michele_tan@dlsu.edu.ph', 'Tan', 'Michele', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('sonia_tan@dlsu.edu.ph', 'Tan', 'Sonia', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('deneisha_tieng@dlsu.edu.ph', 'Tieng', 'Deneisha Balictar', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('regina_tresvalles@dlsu.edu.ph', 'Tresvalles', 'Regina', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('melvin_vidar@dlsu.edu.ph', 'Vidar', 'Melvin', 'MATH', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('jasmine_albelda', 'Albelda', 'Jasmine Angelie', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('norberto_alcantara@dlsu.edu.ph', 'Alcantara', 'Norberto', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('ryan_arevalo@dlsu.edu.ph', 'Arevalo', 'Ryan', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('ermys_bornilla@dlsu.edu.ph', 'Bornilla', 'Ermys', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('melanie_david@dlsu.edu.ph', 'David', 'Melanie', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('micheal_delmo@dlsu.edu.ph', 'Delmo', 'Micheal', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('john_enriquez@dlsu.edu.ph', 'Enriquez', 'John Isaac', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('maria_galvez@dlsu.edu.ph', 'Galvez', 'Maria Cecilia', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('richard_hartmann@dlsu.edu.ph', 'Hartmann', 'Richard', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('klaud_haygood@dlsu.edu.ph', 'Haygood', 'Klaud', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('alfonso_jadie@dlsu.edu.ph', 'Jadie', 'Alfonso Vicente', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('kevin_kaw@dlsu.edu.ph', 'Kaw', 'Kevin Anthony', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('enrique_manzano@dlsu.edu.ph', 'Nazano', 'Enrique', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('maria_monzano@dlsu.edu.ph', 'Manzano', 'Maria Carla', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('joselito_muldera@dlsu.edu.ph', 'Muldera', 'Joselito', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('michelle_natividad@dlsu.edu.ph', 'Natividad', 'Michelle', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('shirley_palisoc@dlsu.edu.ph', 'Palisoc', 'Shirley', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('vanessa_perianes@dlsu.edu.ph', 'Perianes', 'Vanessa', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('romeric_pobre@dlsu.edu.ph', 'Pobre', 'Romeroc', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('christopher_que@dlsu.edu.ph', 'Que', 'Christopher', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('reuben_quiroga@dlsu.edu.ph', 'Quiroga', 'Reuben', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('ofelia_rempillo@dlsu.edu.ph', 'Rempillo', 'Ofelia', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('emmanuel_rodulfo@dlsu.edu.ph', 'Rodulfo', 'Emmanuel', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('joseph_scheiter@dlsu.edu.ph', 'Scheiter', 'Joseph', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('jade_trono@dlsu.edu.ph', 'Trono', 'Jade Dungao', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('edgar_vallar@dlsu.edu.ph', 'Vallar', 'Edgar', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('enrico_villacorta@dlsu.edu.ph', 'Villacorta', 'Enrico', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('al_villagracia@dlsu.edu.ph', 'Villagracia', 'Al Rey', 'PHY', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('miel_abdon@dlsu.edu.ph', 'Abdon', 'Miel', 'BHS', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('roberto_abello@dlsu.edu.ph', 'Abello', 'Roberto Prudencio', 'BHS', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('james_aranet@dlsu.edu.ph', 'Araneta', 'James', 'BHS', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('myla_arcinas@dlsu.edu.ph', 'Arcinas', 'Myla', 'BHS', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('annabelle_bonje@dlsu.edu.ph', 'Bonje', 'Annabelle', 'BHS', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('bernardo_bonoan@dlsu.edu.ph', 'Bonoan', 'Bernardo', 'BHS', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('omega_danganan@dlsu.edu.ph', 'Danganan', 'Omega Diadem', 'BHS', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('kennith_dillena@dlsu.edu.ph', 'Dillena', 'Kennith', 'BHS', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('yellowbelle_duaqui@dlsu.edu.ph', 'Duaqui', 'Yellowbelle', 'BHS', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('marlon_era@dlsu.edu.ph', 'Era', 'Marlon', 'BHS', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('dennis_erasga@dlsu.edu.ph', 'Erasga', 'Dennis', 'BHS', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('melvin_jabar@dlsu.edu.ph', 'Jabar', 'Melvin', 'BHS', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('romeo_lee@dlsu.edu.ph', 'Lee', 'Romeo', 'BHS', NULL, 'default.png', 1);
INSERT INTO `profsmato`.`Professors` (`profEmail`, `lastname`, `firstname`, `department`, `about`, `profPicture`, `status`) VALUES ('alicia_manlagnit@dlsu.edu.ph', 'Malagnnit', 'Alicia', NULL, NULL, NULL, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `profsmato`.`ref_contact`
-- -----------------------------------------------------
START TRANSACTION;
USE `profsmato`;
INSERT INTO `profsmato`.`ref_contact` (`ref_contactId`, `contactType`) VALUES (1, 'facebook');
INSERT INTO `profsmato`.`ref_contact` (`ref_contactId`, `contactType`) VALUES (2, 'youtube');
INSERT INTO `profsmato`.`ref_contact` (`ref_contactId`, `contactType`) VALUES (3, 'twitter');
INSERT INTO `profsmato`.`ref_contact` (`ref_contactId`, `contactType`) VALUES (4, 'instagram');

COMMIT;


-- -----------------------------------------------------
-- Data for table `profsmato`.`ref_reviewComment_status`
-- -----------------------------------------------------
START TRANSACTION;
USE `profsmato`;
INSERT INTO `profsmato`.`ref_reviewComment_status` (`statusId`, `status`) VALUES (1, 'active');
INSERT INTO `profsmato`.`ref_reviewComment_status` (`statusId`, `status`) VALUES (2, 'reported');
INSERT INTO `profsmato`.`ref_reviewComment_status` (`statusId`, `status`) VALUES (3, 'deleted');

COMMIT;

