#!/bin/bash

# Source run_query()
. ./helper_functions.sh

echo "/**************************************************************
  SUBQUERIES IN THE WHERE CLAUSE
  Works for MySQL, Postgres
  SQLite doesn't support All or Any
  Problems of the form: Get facts from A, conditional on facts from B
**************************************************************/"

# echo "/**************************************************************
#   IDs and names of students applying to CS
# **************************************************************/"
#
# q="select sID, sName
# from Student
# where sID in (select sID from Apply where major = 'CS');"
#
# run_query "$q"
#
# echo "/**************************************************************
#   Same query written without 'In'
# **************************************************************/"
#
# q="select sID, sName
# from Student, Apply
# where Student.sID = Apply.sID and major = 'CS';"
#
# run_query "$q"
#
# echo "/*** Fix error ***/"
#
# q="select Student.sID, sName
# from Student, Apply
# where Student.sID = Apply.sID and major = 'CS';"
#
# run_query "$q"
#
# echo "/*** Remove duplicates ('cos Amy applied to several colleges) ***/"
#
# q="select distinct Student.sID, sName
# from Student, Apply
# where Student.sID = Apply.sID and major = 'CS';"
#
# run_query "$q"
#
# echo "/**************************************************************
#   Just names of students applying to CS (note that Craigs are different Craigs)
# **************************************************************/"
#
# q="select sName
# from Student
# where sID in (select sID from Apply where major = 'CS');"
#
# run_query "$q"
#
# echo "/**************************************************************
#   Same query written without 'In'
# **************************************************************/"
#
# q="select sName
# from Student, Apply
# where Student.sID = Apply.sID and major = 'CS';"
#
# run_query "$q"
#
# echo "/*** Remove duplicates (still incorrect) ***/"
#
# q="select distinct sName
# from Student, Apply
# where Student.sID = Apply.sID and major = 'CS';"
#
# run_query "$q"

# echo "/**************************************************************
#   Duplicates are important: average GPA of CS applicants
# **************************************************************/"
#
# q="select GPA
# from Student
# where sID in (select sID from Apply where major = 'CS');"
# run_query "$q"
#
# echo "/**************************************************************
#   Alternative (incorrect) queries without 'In'
# **************************************************************/"
#
# q="select GPA
# from Student, Apply
# where Student.sID = Apply.sID and major = 'CS';"
# run_query "$q"
#
# q="select distinct GPA
# from Student, Apply
# where Student.sID = Apply.sID and major = 'CS';"
# run_query "$q"

echo "/**************************************************************
  Students who applied to CS but not EE
  (query we used 'Except' for earlier)
**************************************************************/"

q="select sID, sName
from Student
where sID in (select sID from Apply where major = 'CS')
  and sID not in (select sID from Apply where major = 'EE');"

run_query "$q"

echo "/*** Change to 'not sID in' ***/"

q="select sID, sName
from Student
where sID in (select sID from Apply where major = 'CS')
  and not sID in (select sID from Apply where major = 'EE');"

run_query "$q"

# echo "/**************************************************************
#   Colleges such that some other college is in the same state
# **************************************************************/"
#
# select cName, state
# from College C1
# where exists (select * from College C2
#               where C2.state = C1.state);
#
# echo "/*** Fix error ***/"
#
# select cName, state
# from College C1
# where exists (select * from College C2
#               where C2.state = C1.state and C2.cName <> C1.cName);
#
# echo "/**************************************************************
#   Biggest college
# **************************************************************/"
#
# select cName
# from College C1
# where not exists (select * from College C2
#                   where C2.enrollment > C1.enrollment);
#
# echo "/*** Similar: student with highest GPA  ***/"
#
# select sName
# from Student C1
# where not exists (select * from Student C2
#                   where C2.GPA > C1.GPA);
#
# echo "/*** Add GPA ***/"
#
# select sName, GPA
# from Student C1
# where not exists (select * from Student C2
#                   where C2.GPA > C1.GPA);
#
# echo "/**************************************************************
#   Highest GPA with no subquery
# **************************************************************/"
#
# select S1.sName, S1.GPA
# from Student S1, Student S2
# where S1.GPA > S2.GPA;
#
# echo "/*** Remove duplicates (still incorrect - finds all students
# except those who have the lowest GPA) ***/"
#
# select distinct S1.sName, S1.GPA
# from Student S1, Student S2
# where S1.GPA > S2.GPA;
#
# echo "/**************************************************************
#   Highest GPA using ">= all"
# **************************************************************/"
#
# select sName, GPA
# from Student
# where GPA >= all (select GPA from Student);
#
# echo "/**************************************************************
#   Higher GPA than all other students
# **************************************************************/"
#
# select sName, GPA
# from Student S1
# where GPA > all (select GPA from Student S2
#                  where S2.sID <> S1.sID);
#
# echo "/*** Similar: higher enrollment than all other colleges  ***/"
#
# select cName
# from College S1
# where enrollment > all (select enrollment from College S2
#                         where S2.cName <> S1.cName);
#
# echo "/*** Same query using 'Not <= Any' ***/"
#
# select cName
# from College S1
# where not enrollment <= any (select enrollment from College S2
#                              where S2.cName <> S1.cName);
#
# echo "/**************************************************************
#   Students not from the smallest HS
# **************************************************************/"
#
# select sID, sName, sizeHS
# from Student
# where sizeHS > any (select sizeHS from Student);
#
# echo "/**************************************************************
#   Students not from the smallest HS
#   Some systems don't support Any/All
# **************************************************************/"
#
# select sID, sName, sizeHS
# from Student S1
# where exists (select * from Student S2
#               where S2.sizeHS < S1.sizeHS);
#
# echo "/**************************************************************
#   Students who applied to CS but not EE
# **************************************************************/"
#
# select sID, sName
# from Student
# where sID = any (select sID from Apply where major = 'CS')
#   and sID <> any (select sID from Apply where major = 'EE');
#
# echo "/*** Subtle error, fix ***/"
#
# select sID, sName
# from Student
# where sID = any (select sID from Apply where major = 'CS')
#   and not sID = any (select sID from Apply where major = 'EE');
