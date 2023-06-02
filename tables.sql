--Create 6 Tables.
DROP TABLE IF EXISTS faculties;
DROP TABLE IF EXISTS programs;
DROP TABLE IF EXISTS courses_programs;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS pre_requisites;
DROP TABLE IF EXISTS instructors;

--Create table faculties.
CREATE TABLE faculties(
    faculty_id varchar(4) NOT NULL PRIMARY KEY,
    faculty_name varchar(100) NOT NULL,
    faculty_description varchar()
    --campus varchar(10) NOT NULL
);

-- Create table programs.
CREATE TABLE programs(
    program_id char(4) NOT NULL PRIMARY KEY,
    faculty_id varchar(4) NOT NULL,
    program_name varchar(50) NOT NULL,
    program_location varchar(50),
    program_description text
);

--Create table courses_programs.
CREATE TABLE courses_programs(
    course_id int NOT NULL PRIMARY KEY,
    program_id char(4) NOT NULL
);

--Create table courses.
CREATE TABLE courses(
    course_id int NOT NULL,
    code varchar NOT NULL,
    year int NOT NULL,
    semester int NOT NULL,
    section varchar(10) NOT NULL,
    title varchar(100) NOT NULL,
    credits int NOT NULL,
    modality varchar(50) NOT NULL,
    modality_type varchar(20),
    instructor_id int NOT NULL,
    class_venue varchar(100),
    communication_tool varchar(25),
    course_platform varchar(25),
    field_trips varchar(3),
    resources_required text,
    resources_recommended text,
    resources_other text,
    course_description text,
    course_outline_url text
);

--Create table instructors.
CREATE TABLE instructors(
    instructor_id int NOT NULL,
    instructor_email varchar(50) UNIQUE NOT NULL,
    instructor_name varchar(50) NOT NULL,
    office_location varchar(50),
    telephone char(20),
    degree varchar(50)
);

--Create table pre_requisites.
CREATE TABLE pre_requisites(
    course_code varchar,
    pre_requisites varchar(8)
);

--Copying csv files.
COPY faculties
FROM '/home/zhenitsu/Downloads/faculties.csv'
DELIMITER ','
CSV HEADER;

COPY programs
FROM '/home/zhenitsu/Downloads/programs.csv'
DELIMITER ','
CSV HEADER;

COPY courses_programs
FROM '/home/zhenitsu/Downloads/courses_programs.csv'
DELIMITER ','
CSV HEADER;

COPY courses
FROM '/home/zhenitsu/Downloads/courses.csv'
DELIMITER ','
CSV HEADER;

COPY instructors
FROM '/home/zhenitsu/Downloads/instructors.csv'
DELIMITER ','
CSV HEADER;

COPY pre_requisites
FROM '/home/zhenitsu/Downloads/pre_reqs.csv'
DELIMITER ','
CSV HEADER;

--Query time.
--What faculty id's at UB ends in 's'?
SELECT faculty_id
FROM faculties
WHERE faculty_id
LIKE '%S';

--What programs are offered in Belize City?
SELECT program_name, program_location
FROM programs AS P
JOIN faculties AS F
ON P.faculty_id = F.faculty_id
WHERE program_location = 'Belize City';

--What courses does Mrs. Vernelle Sylvester teach?
SELECT courses.title AS Course, instructors.instructor_name AS Instructor
FROM courses
LEFT JOIN instructors
ON courses.instructor_id = instructors.instructor_id
WHERE instructor_name = 'Vernelle Sylvester';

--Which instructors have a Masters Degree?
SELECT instructor_name 
FROM instructors 
WHERE degree 
LIKE 'M%';

--What are the prequisites for Programming 2?
SELECT C.code AS course_name, PR.pre_requisites AS prerequisite 
FROM courses AS C 
JOIN pre_requisites AS PR
ON C.course_id = PR.course_code
WHERE C.code = 'CMPS1132';

--List the code, year, semester, section and title for all courses.
SELECT code, year, semester, section, title
FROM courses;

--List the program_name and code, year semester section and title for all AINT programs.
SELECT C.title, C.code, C.year, C.semester, CP.program_id, P.program_id 
FROM courses_programs AS CP
JOIN courses AS C ON CP.course_id = C.course_id
JOIN programs AS P ON CP.program_id = P.program_id
WHERE CP.program_id = 'AINT'
AND P.program_id = 'AINT';

--List the faculty_name and code, year, semester section and title for all offered by FST.
SELECT F.faculty_id, F.faculty_name, C.code, C.year, C.semester, C.section, C.title, CP.program_id
FROM faculties AS F
JOIN programs AS P
ON F.faculty_id = P.faculty_id
JOIN courses_programs AS CP
ON CP.program_id = P.program_id
JOIN courses AS C
ON C.course_id = CP.course_id
WHERE F.faculty_id = 'FST'
AND P.faculty_id = 'FST';