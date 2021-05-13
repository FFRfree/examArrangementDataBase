-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema basic_info
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema basic_info
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `basic_info` DEFAULT CHARACTER SET utf8 ;
USE `basic_info` ;

-- -----------------------------------------------------
-- Table `basic_info`.`curriculum`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `basic_info`.`curriculum` (
  `curriculum_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `comments` VARCHAR(200) NULL,
  PRIMARY KEY (`curriculum_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `basic_info`.`faculty`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `basic_info`.`faculty` (
  `faculty_id` INT NOT NULL AUTO_INCREMENT,
  `faculty_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`faculty_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `basic_info`.`teacher`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `basic_info`.`teacher` (
  `teacher_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `job_title` VARCHAR(45) NULL,
  `comments` VARCHAR(200) NULL,
  `faculty_id` INT NOT NULL,
  PRIMARY KEY (`teacher_id`),
  INDEX `fk_teacher_faculty1_idx` (`faculty_id` ASC),
  CONSTRAINT `fk_teacher_faculty1`
    FOREIGN KEY (`faculty_id`)
    REFERENCES `basic_info`.`faculty` (`faculty_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `basic_info`.`student`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `basic_info`.`student` (
  `student_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `gender` ENUM('M', 'F') NOT NULL,
  `faculty_id` INT NOT NULL,
  PRIMARY KEY (`student_id`),
  INDEX `fk_student_faculty1_idx` (`faculty_id` ASC),
  CONSTRAINT `fk_student_faculty1`
    FOREIGN KEY (`faculty_id`)
    REFERENCES `basic_info`.`faculty` (`faculty_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `basic_info`.`classroom`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `basic_info`.`classroom` (
  `classroom_id` INT NOT NULL AUTO_INCREMENT,
  `location` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`classroom_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `basic_info`.`time_slice_weekly`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `basic_info`.`time_slice_weekly` (
  `time_slice_id` INT NOT NULL AUTO_INCREMENT,
  `start_time` TIME NOT NULL,
  `end_time` TIME NOT NULL,
  `week_day` ENUM('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY') NOT NULL,
  PRIMARY KEY (`time_slice_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `basic_info`.`course`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `basic_info`.`course` (
  `course_id` INT NOT NULL AUTO_INCREMENT,
  `classroom_id` INT NOT NULL,
  `time_slice_id` INT NOT NULL,
  `curriculum_id` INT NOT NULL,
  `teacher_id` INT NOT NULL,
  PRIMARY KEY (`course_id`),
  INDEX `fk_course_classroom1_idx` (`classroom_id` ASC),
  INDEX `fk_course_time_slice_weekly1_idx` (`time_slice_id` ASC),
  INDEX `fk_course_curriculum1_idx` (`curriculum_id` ASC),
  INDEX `fk_course_teacher1_idx` (`teacher_id` ASC),
  CONSTRAINT `fk_course_classroom1`
    FOREIGN KEY (`classroom_id`)
    REFERENCES `basic_info`.`classroom` (`classroom_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_course_time_slice_weekly1`
    FOREIGN KEY (`time_slice_id`)
    REFERENCES `basic_info`.`time_slice_weekly` (`time_slice_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_course_curriculum1`
    FOREIGN KEY (`curriculum_id`)
    REFERENCES `basic_info`.`curriculum` (`curriculum_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_course_teacher1`
    FOREIGN KEY (`teacher_id`)
    REFERENCES `basic_info`.`teacher` (`teacher_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `basic_info`.`student_has_course`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `basic_info`.`student_has_course` (
  `student_id` INT NOT NULL,
  `course_id` INT NOT NULL,
  PRIMARY KEY (`student_id`, `course_id`),
  INDEX `fk_student_has_course_course1_idx` (`course_id` ASC),
  INDEX `fk_student_has_course_student1_idx` (`student_id` ASC),
  CONSTRAINT `fk_student_has_course_student1`
    FOREIGN KEY (`student_id`)
    REFERENCES `basic_info`.`student` (`student_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_student_has_course_course1`
    FOREIGN KEY (`course_id`)
    REFERENCES `basic_info`.`course` (`course_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `basic_info`.`exam`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `basic_info`.`exam` (
  `exam_id` INT NOT NULL AUTO_INCREMENT,
  `course_id` INT NOT NULL,
  `classroom_id` INT NOT NULL,
  `teacher_id` INT NOT NULL,
  `time_slice_id` INT NOT NULL,
  PRIMARY KEY (`exam_id`),
  INDEX `fk_exam_course1_idx` (`course_id` ASC),
  INDEX `fk_exam_classroom1_idx` (`classroom_id` ASC),
  INDEX `fk_exam_teacher1_idx` (`teacher_id` ASC),
  INDEX `fk_exam_time_slice_weekly1_idx` (`time_slice_id` ASC),
  CONSTRAINT `fk_exam_course1`
    FOREIGN KEY (`course_id`)
    REFERENCES `basic_info`.`course` (`course_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_exam_classroom1`
    FOREIGN KEY (`classroom_id`)
    REFERENCES `basic_info`.`classroom` (`classroom_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_exam_teacher1`
    FOREIGN KEY (`teacher_id`)
    REFERENCES `basic_info`.`teacher` (`teacher_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_exam_time_slice_weekly1`
    FOREIGN KEY (`time_slice_id`)
    REFERENCES `basic_info`.`time_slice_weekly` (`time_slice_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `basic_info` ;

-- -----------------------------------------------------
-- Placeholder table for view `basic_info`.`curriculumn_detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `basic_info`.`curriculumn_detail` (`id` INT, `name` INT, `location` INT, `start_time` INT, `end_time` INT, `week_day` INT, `teacher` INT);

-- -----------------------------------------------------
-- Placeholder table for view `basic_info`.`student_course_detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `basic_info`.`student_course_detail` (`student_id` INT, `name` INT, `course_name` INT, `location` INT, `start_time` INT, `end_time` INT, `teacher_id` INT);

-- -----------------------------------------------------
-- Placeholder table for view `basic_info`.`exam_detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `basic_info`.`exam_detail` (`exam_id` INT, `course_name` INT, `teacher_name` INT, `location` INT, `start_time` INT, `end_time` INT);

-- -----------------------------------------------------
-- View `basic_info`.`curriculumn_detail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `basic_info`.`curriculumn_detail`;
USE `basic_info`;
CREATE  OR REPLACE VIEW curriculumn_detail AS
	SELECT course.course_id as id, curriculum.name, classroom.location, start_time, end_time, week_day, teacher.name as teacher
    FROM course
    JOIN curriculum USING(curriculum_id)
    JOIN classroom USING(classroom_id)
    JOIN time_slice_weekly USING(time_slice_id)
    JOIN teacher USING(teacher_id);

-- -----------------------------------------------------
-- View `basic_info`.`student_course_detail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `basic_info`.`student_course_detail`;
USE `basic_info`;
CREATE  OR REPLACE VIEW student_course_detail AS
	SELECT student.student_id ,student.name, curriculum.name as course_name , classroom.location, time_slice_weekly.start_time, time_slice_weekly.end_time,teacher_id
    FROM student_has_course
    JOIN student USING (student_id)
    JOIN course USING (course_id)
    JOIN classroom USING (classroom_id)
    JOIN time_slice_weekly USING (time_slice_id)
    JOIN curriculum USING (curriculum_id);

-- -----------------------------------------------------
-- View `basic_info`.`exam_detail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `basic_info`.`exam_detail`;
USE `basic_info`;
CREATE  OR REPLACE VIEW `exam_detail` AS
    SELECT 
        exam_id,
        curriculum.name AS course_name,
        teacher.name AS teacher_name,
        location,
        start_time,
        end_time
    FROM
        exam
            JOIN
        teacher USING (teacher_id)
            JOIN
        classroom USING (classroom_id)
            JOIN
        time_slice_weekly USING (time_slice_id)
            JOIN
        course ON course.course_id = exam.course_id
            JOIN
        curriculum ON curriculum.curriculum_id = course.curriculum_id;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
