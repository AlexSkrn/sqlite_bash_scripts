#!/bin/bash

echo "Selecting data from the college.sqlite database"

# /**************************************************************
#   BASIC SELECT STATEMENTS
#   Works for SQLite, MySQL, Postgres
# **************************************************************/

# echo "IDs, names, and GPAs of students with GPA > 3.6"
#
# sqlite3 ./db/college.sqlite << EOF
# select sID, sName, GPA
# from Student
# where GPA > 3.6;
# EOF

# # /*** Same query without GPA ***/
#
# select sID, sName
# from Student
# where GPA > 3.6;
#

# echo  "Student names and majors for which they've applied"
#
# sqlite3 ./db/college.sqlite << EOF
# select sName, major
# from Student, Apply
# where Student.sID = Apply.sID;
# EOF
#
# echo "Same query with Distinct, note difference from algebra"
# sqlite3 ./db/college.sqlite << EOF
# select distinct sName, major
# from Student, Apply
# where Student.sID = Apply.sID;
# EOF

# echo "Names and GPAs of students with sizeHS < 1000 applying to \
# CS at Stanford, and the application decision"
# sqlite3 ./db/college.sqlite << EOF
# select sname, GPA, decision
# from Student, Apply
# where Student.sID = Apply.sID
#   and sizeHS < 1000 and major = 'CS' and cname = 'Stanford';
# EOF

# echo "All large campuses with CS applicants WITH ERROR"
# sqlite3 ./db/college.sqlite << EOF
# select cName
# from College, Apply
# where College.cName = Apply.cName
#   and enrollment > 20000 and major = 'CS';
# EOF

# echo "All large campuses with CS applicants WITH ERROR FIXED"
# sqlite3 ./db/college.sqlite << EOF
# select College.cName
# from College, Apply
# where College.cName = Apply.cName
#   and enrollment > 20000 and major = 'CS';
# EOF
#
# # /*** Add Distinct ***/
#
# select distinct College.cName
# from College, Apply
# where College.cName = Apply.cName
#   and enrollment > 20000 and major = 'CS';
#
# # /**************************************************************
# #   Application information
# # **************************************************************/
#
# select Student.sID, sName, GPA, Apply.cName, enrollment
# from Student, College, Apply
# where Apply.sID = Student.sID and Apply.cName = College.cName;
#
# echo "Sort by decreasing GPA"
# sqlite3 ./db/college.sqlite << EOF
# .headers on
# .mode column
# select distinct Student.sID, sName, GPA, Apply.cName, enrollment
# from Student, College, Apply
# where Apply.sID = Student.sID and Apply.cName = College.cName
# order by GPA desc;
# EOF

# # /*** Then by increasing enrollment ***/
#
# select Student.sID, sName, GPA, Apply.cName, enrollment
# from Student, College, Apply
# where Apply.sID = Student.sID and Apply.cName = College.cName
# order by GPA desc, enrollment;
#
# # /**************************************************************
# #   Applicants to bio majors
# # **************************************************************/
#
# select sID, major
# from Apply
# where major like '%bio%';
#
# # /*** Same query with Select * ***/
#
# select *
# from Apply
# where major like '%bio%';
#
# echo "/**************************************************************
#   Select * cross-product
# **************************************************************/"
# sqlite3 ./db/college.sqlite << EOF
# .headers on
# .mode column
# select *
# from Student, College;
# EOF

echo "/**************************************************************
  Add scaled GPA based on sizeHS
  Also note missing Where clause
**************************************************************/"

# select sID, sName, GPA, sizeHS, GPA*(sizeHS/1000.0)
# from Student;

echo "/*** Rename result attribute ***/"
sqlite3 ./db/college.sqlite << EOF
.headers on
.mode column
select sID, sName, GPA, sizeHS, GPA*(sizeHS/1000.0) as scaledGPA
from Student;
EOF
