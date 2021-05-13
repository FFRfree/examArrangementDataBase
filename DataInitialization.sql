-- test data initializing...
use basic_info;


INSERT INTO faculty (faculty_name)
VALUES ("physics"),
	   ("engineering"),
       ("math"),
       ("chemistry");
       
INSERT INTO student(name , gender, faculty_id)
VALUES("Lili", 'f', 1),
	  ("Lucy", 'f', 2),
      ('Mary', 'f', 3),
      ('Andy', 'f', 4),
      ('Tony', 'm', 1),
      ('Tom', 'm' , 2),
      ('Sam', 'm' , 3),
      ('Steven', 'm',4),
      ('Eric', 'm', 1),
      ('James', 'm', 2),
      ('Jack', 'm', 3),
      ('Ken', 'm', 4);
      
INSERT INTO teacher(name,job_title,faculty_id)
VALUES('teacher1','professor',1),
	  ('teacher2','professor',2),
      ('teacher3','professor',3),
      ('teacher4','professor',4),
      ('teacher5','lecturer',1),
      ('teacher6','lecturer',2),
      ('teacher7','lecturer',3),
      ('teacher8','lecturer',4),
      ('teacher9','instructor',1);
   
INSERT INTO classroom(location)
VALUES("4教101"),
	  ("4教102"),
      ("4教103"),
      ("4教104"),
      ("4教105"),
      ("4教106"),
      ("4教107");
      
INSERT INTO curriculum(name)
VALUES("calculas"),
	  ("statics"),
      ("physics"),
      ("OOP"),
      ("operating system"),
      ("digital signal processing"),
      ('c programing language');
      
INSERT INTO time_slice_weekly(start_time,end_time,week_day)
VALUES("9:0:0","10:0:0","MONDAY"),
	  ("9:0:0","10:0:0","TUESDAY"),
      ("9:0:0","10:0:0","WEDNESDAY"),
      ("9:0:0","10:0:0","THURSDAY"),
      ("10:0:0","11:0:0","MONDAY"),
	  ("10:0:0","11:0:0","TUESDAY"),
      ("10:0:0","11:0:0","WEDNESDAY"),
      ("10:0:0","11:0:0","THURSDAY"),
      ("13:0:0","14:0:0","WEDNESDAY"),
      ("14:0:0","15:0:0","THURSDAY");
      
      
      
INSERT INTO course(course_id,classroom_id,time_slice_id,curriculum_id,teacher_id)
VALUES(default, 1,1,1,1),
	  (default, 1,2,2,2),
      (default, 2,2,3,3),
      (default, 3,3,3,4),
      (default, 4,4,4,4),
      (default,5,5,5,5),
      (default,6,6,6,6),
      (default,7,7,7,7);
      

INSERT INTO weeks
VALUES (1),(2),(3),(4),(5),(6),(7);



-- exam_id, course_id, classroom_id,teacher_id

DROP PROCEDURE IF EXISTS select_course;     
DROP PROCEDURE IF EXISTS teach_course; 
DELIMITER $$
    CREATE PROCEDURE select_course(student_id int , course_id int)  
		-- 真的很神奇耶
        BEGIN
            INSERT INTO student_has_course (student_id, course_id)
            SELECT * FROM  (SELECT student_id, course_id) AS tmp
            WHERE NOT EXISTS (
				SELECT student_id, course_id 
                FROM student_has_course as shc
                WHERE shc.student_id = student_id and shc.course_id = course_id
            ) LIMIT 1;
        END$$
-- 	CREATE PROCEDURE teach_course(teacher_id int , course_id int)  
--         BEGIN
--             INSERT INTO teacher_teach_course
--             SELECT * FROM (SELECT teacher_id, course_id) AS tmp
--             WHERE NOT EXISTS(
-- 				SELECT teacher_id ,course_id
--                 FROM teacher_teach_course as ttc
--                 WHERE ttc.teacher_id = teacher_id and ttc.course_id = course_id
--             ) LIMIT 1;
--         END$$
	CREATE PROCEDURE logout_student(id int, faculty varchar(45))
		BEGIN
			DELETE FROM basic_info.student
			WHERE name = 'Ken' and faculty_id=(
				SELECT faculty_id
				FROM basic_info.faculty
				WHERE faculty_name = 'chemistry'
			);
	END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS logout_student; 
DELIMITER $$
	CREATE PROCEDURE logout_student(student varchar(45), faculty varchar(45))
		BEGIN
			DELETE FROM basic_info.student
			WHERE name = student and faculty_id=(
				SELECT faculty_id
				FROM basic_info.faculty
				WHERE faculty_name = faculty
			);
		END$$
DELIMITER ;

CALL basic_info.logout_student("ffr","engineering");

 CALL select_course(1,1);
 CALL select_course(1,2);
 CALL select_course(1,3);
 CALL select_course(1,4);
 CALL select_course(2,1);
 CALL select_course(2,4);
 CALL select_course(3,4);
 CALL select_course(4,4);
 CALL select_course(4,2);
 CALL select_course(5,8);
 CALL select_course(5,7);
 CALL select_course(5,6);
 CALL select_course(6,1);
 CALL select_course(6,5);
 CALL select_course(6,4);
 CALL select_course(7,6);
 CALL select_course(7,7);
 CALL select_course(8,2);
 CALL select_course(8,4);
 CALL select_course(9,5);
 CALL select_course(9,6);
 CALL select_course(10,8);
 CALL select_course(10,7);
 CALL select_course(11,4);
 CALL select_course(11,6);
 CALL select_course(12,6);
 CALL select_course(12,5);
 

-- CREATE OR REPLACE VIEW curriculumn_detail AS
-- 	SELECT course.course_id as id, curriculum.name, classroom.location, start_time, end_time, week_day, teacher.name as teacher
--     FROM course
--     JOIN curriculum USING(curriculum_id)
--     JOIN classroom USING(classroom_id)
--     JOIN time_slice_weekly USING(time_slice_id)
--     JOIN teacher USING(teacher_id);

-- CREATE OR REPLACE VIEW student_course_detail AS
-- 	SELECT student.student_id ,student.name, curriculum.name as course_name , classroom.location, time_slice_weekly.start_time, time_slice_weekly.end_time,teacher_id
--     FROM student_has_course
--     JOIN student USING (student_id)
--     JOIN course USING (course_id)
--     JOIN classroom USING (classroom_id)
--     JOIN time_slice_weekly USING (time_slice_id)
--     JOIN curriculum USING (curriculum_id);
-- 	
-- CREATE OR REPLACE VIEW student_detail AS
-- 	SELECT student_id, name ,gender, faculty_name FROM basic_info.student
-- 	JOIN basic_info.faculty USING(faculty_id)
-- 	ORDER BY student_id; 

-- CREATE OR REPLACE VIEW exam_detail AS
-- 	SELECT curriculum.name as course_name ,teacher.name as teacher_name, location, start_time, end_time
-- 	FROM exam
-- 	JOIN teacher USING (teacher_id)
-- 	JOIN classroom USING (classroom_id)
-- 	JOIN time_slice_weekly USING (time_slice_id)
-- 	JOIN course 
-- 		ON course.course_id = exam.course_id
-- 	JOIN curriculum
-- 		ON curriculum.curriculum_id = course.curriculum_id;


INSERT INTO exam(course_id,classroom_id,time_slice_id,weeks_id,invigilation)
VALUES(1,1,1,5,8),
	  (2,2,2,5,7),
      (3,3,4,5,6),
      (4,4,2,5,5),
      (6,6,6,5,4),
      (7,7,7,5,3),
      (8,1,8,5,2);


DROP PROCEDURE IF EXISTS find_exam_by_student; 
DELIMITER $$
	CREATE PROCEDURE find_exam_by_student(student varchar(45))
		BEGIN
			SELECT * FROM basic_info.exam_detail
			WHERE exam_detail.course_id in (
				SELECT course_id
				FROM student_has_course
				WHERE student_id = (
					SELECT student_id
					FROM student
					where name = student
                    )
			);
		END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS delete_exam; 
DELIMITER $$
	CREATE PROCEDURE delete_exam(roomlocation varchar(45),starttime time,weekday ENUM('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'),weekid int)
		BEGIN
			DELETE FROM basic_info.exam WHERE
			classroom_id = (SELECT classroom_id FROM basic_info.classroom WHERE location = roomlocation)  
            AND 
            time_slice_id = (SELECT time_slice_id FROM basic_info.time_slice_weekly WHERE start_time = starttime and week_day = weekday) 
            AND 
            weeks_id = (SELECT id FROM basic_info.weeks WHERE id = weekid); 
		END$$
DELIMITER ;