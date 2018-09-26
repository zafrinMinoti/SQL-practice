-- September 26, 2018

-- 1. Count the number of faculty in the CIS department
SELECT COUNT(DISTINCT instructor) FROM CIS.Section 
WHERE class_code LIKE "CIS%"
order by instructor;


-- 2. List the course number and the count of sections for each course that is offered
select class_code, count(section_id) as section_count
from CIS.Section
group by class_code


-- 3. List the name of all the instructors that are not faculty in CIS department but are teaching CIS100
select distinct Instructor.instructor
from CIS.Instructor left join CIS.Section
on Instructor.instructor = Section.instructor
where Section.class_code = "CIS100"
	and employee_type != "faculty";
    
    
-- 4. List name and office of each of the faculty member 
--    of the CIS department and the number of credits each one teaches.
select Instructor.instructor, sum(credit), office
from CIS.Section 
right join CIS.Course
	on Section.class_code = Course.class_code
right join CIS.Instructor
	on Instructor.instructor = Section.instructor
where Course.class_code like "CIS%"
	and Instructor.employee_type = "faculty"
group by instructor, office;


-- 5. List the instructor name(s) and number of sections 
--    of any instructor(s) who teach(es) the most number of sections.

CREATE VIEW CIS.instructor_section_count
    AS	SELECT class_code, instructor, COUNT(section_id) AS section_count
		FROM CIS.Section
		GROUP BY class_code, instructor
		ORDER BY class_code, section_count DESC;
        
CREATE VIEW CIS.max_section_count
    AS	SELECT DISTINCT class_code, MAX(section_count) AS max_section_count
		FROM CIS.instructor_section_count
        GROUP BY class_code;
        
SELECT max_section_count.class_code, instructor, max_section_count
FROM CIS.max_section_count
INNER JOIN CIS.instructor_section_count
ON max_section_count.class_code = instructor_section_count.class_code
	AND max_section_count.max_section_count = instructor_section_count.section_count;


-- 6. List the instructor name(s) and the number of courses 
--    of any instructor(s) who teach(es) most variety of courses.
SELECT instructor, COUNT(DISTINCT(class_code))
FROM CIS.Section
GROUP BY Instructor;