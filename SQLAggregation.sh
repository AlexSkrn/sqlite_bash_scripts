#!/bin/bash

# Source run_query()
. ./helper_functions.sh


echo "/**************************************************************
  AGGREGATION
  Works for SQLite, MySQL
  Postgres doesn't allow ambiguous Select columns in Group-by queries
**************************************************************/"

echo "/**************************************************************
  Average GPA of all students
**************************************************************/"

q="select avg(GPA)
from Student;"

run_query "$q"

"/**************************************************************
  Lowest GPA of students applying to CS
**************************************************************/"

select min(GPA)
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

echo "/*** Average GPA of students applying to CS ***/"

select avg(GPA)
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

echo "/*** Fix incorrect counting of GPAs ***/"

select avg(GPA)
from Student
where sID in (select sID from Apply where major = 'CS');

echo "/**************************************************************
  Number of colleges bigger than 15,000
**************************************************************/"

select count(*)
from College
where enrollment > 15000;

echo "/**************************************************************
  Number of students applying to Cornell
**************************************************************/"

select count(*)
from Apply
where cName = 'Cornell';

echo "/*** Show why incorrect result, fix using Count Distinct ***/"

select *
from Apply
where cName = 'Cornell';

select Count(Distinct sID)
from Apply
where cName = 'Cornell';

echo "/**************************************************************
  Students such that number of other students with same GPA is
  equal to number of other students with same sizeHS
**************************************************************/"

select *
from Student S1
where (select count(*) from Student S2
       where S2.sID <> S1.sID and S2.GPA = S1.GPA) =
      (select count(*) from Student S2
       where S2.sID <> S1.sID and S2.sizeHS = S1.sizeHS);

echo "/**************************************************************
  Amount by which average GPA of students applying to CS
  exceeds average of students not applying to CS
**************************************************************/"

select CS.avgGPA - NonCS.avgGPA
from (select avg(GPA) as avgGPA from Student
      where sID in (
         select sID from Apply where major = 'CS')) as CS,
     (select avg(GPA) as avgGPA from Student
      where sID not in (
         select sID from Apply where major = 'CS')) as NonCS;

echo "/*** Same using subqueries in Select ***/"

select (select avg(GPA) as avgGPA from Student
        where sID in (
           select sID from Apply where major = 'CS')) -
       (select avg(GPA) as avgGPA from Student
        where sID not in (
           select sID from Apply where major = 'CS')) as d
from Student;

echo "/*** Remove duplicates ***/"

select distinct (select avg(GPA) as avgGPA from Student
        where sID in (
           select sID from Apply where major = 'CS')) -
       (select avg(GPA) as avgGPA from Student
        where sID not in (
           select sID from Apply where major = 'CS')) as d
from Student;

echo "/**************************************************************
  Number of applications to each college
**************************************************************/"

select cName, count(*)
from Apply
group by cName;

echo "/*** First do query to picture grouping ***/"

select *
from Apply
order by cName;

echo "/*** Now back to query we want ***/"

select cName, count(*)
from Apply
group by cName;

echo "/**************************************************************
  College enrollments by state
**************************************************************/"

select state, sum(enrollment)
from College
group by state;

echo "/**************************************************************
  Minimum + maximum GPAs of applicants to each college & major
**************************************************************/"

select cName, major, min(GPA), max(GPA)
from Student, Apply
where Student.sID = Apply.sID
group by cName, major;

echo "/*** First do query to picture grouping ***/"

select cName, major, GPA
from Student, Apply
where Student.sID = Apply.sID
order by cName, major;

echo "/*** Now back to query we want ***/"

select cName, major, min(GPA), max(GPA)
from Student, Apply
where Student.sID = Apply.sID
group by cName, major;

echo "/*** Widest spread ***/"

select max(mx-mn)
from (select cName, major, min(GPA) as mn, max(GPA) as mx
      from Student, Apply
      where Student.sID = Apply.sID
      group by cName, major) M;

echo "/**************************************************************
  Number of colleges applied to by each student
**************************************************************/"

select Student.sID, count(distinct cName)
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID;

echo "/*** First do query to picture grouping ***/"

select Student.sID, cName
from Student, Apply
where Student.sID = Apply.sID
order by Student.sID;

echo "/*** Now back to query we want ***/"

select Student.sID, count(distinct cName)
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID;

echo "/*** Add student name ***/"

select Student.sID, sName, count(distinct cName)
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID;

echo "/*** First do query to picture grouping ***/"

select Student.sID, sName, cName
from Student, Apply
where Student.sID = Apply.sID
order by Student.sID;

echo "/*** Now back to query we want ***/"

select Student.sID, sName, count(distinct cName)
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID;

echo "/*** Add college (shouldn't work but does in some systems) ***/"

select Student.sID, sName, count(distinct cName), cName
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID;

echo "/*** Back to query to picture grouping ***/"

select Student.sID, sName, cName
from Student, Apply
where Student.sID = Apply.sID
order by Student.sID;

echo "/**************************************************************
  Number of colleges applied to by each student, including
  0 for those who applied nowhere
**************************************************************/"

select Student.sID, count(distinct cName)
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID;

echo "/*** Now add 0 counts ***/"

select Student.sID, count(distinct cName)
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID
union
select sID, 0
from Student
where sID not in (select sID from Apply);

echo "/**************************************************************
  Colleges with fewer than 5 applications
**************************************************************/"

select cName
from Apply
group by cName
having count(*) < 5;

echo "/*** Same query without Group-by or Having ***/"

select cName
from Apply A1
where 5 > (select count(*) from Apply A2 where A2.cName = A1.cName);

echo "/*** Remove duplicates ***/"

select distinct cName
from Apply A1
where 5 > (select count(*) from Apply A2 where A2.cName = A1.cName);

echo "/*** Back to original Group-by form, fewer than 5 applicants ***/"

select cName
from Apply
group by cName
having count(distinct sID) < 5;

echo "/**************************************************************
  Majors whose applicant's maximum GPA is below the average
**************************************************************/"

select major
from Student, Apply
where Student.sID = Apply.sID
group by major
having max(GPA) < (select avg(GPA) from Student);
