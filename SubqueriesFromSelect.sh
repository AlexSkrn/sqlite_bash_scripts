#!/bin/bash

# Source run_query()
. ./helper_functions.sh

echo "/**************************************************************
  SUBQUERIES IN THE FROM AND SELECT CLAUSES
  Works for MySQL and Postgres
  SQLite doesn't support All
**************************************************************/"

# echo "/**************************************************************
#   Students whose scaled GPA changes GPA by more than 1
# **************************************************************/"
#
# q="select sID, sName, GPA, GPA*(sizeHS/1000.0) as scaledGPA
# from Student
# where GPA*(sizeHS/1000.0) - GPA > 1.0
#    or GPA - GPA*(sizeHS/1000.0) > 1.0;"
#
# run_query "$q"
#
# echo "/*** Can simplify using absolute value function ***/"
#
# q="select sID, sName, GPA, GPA*(sizeHS/1000.0) as scaledGPA
# from Student
# where abs(GPA*(sizeHS/1000.0) - GPA) > 1.0;"
#
# run_query "$q"
#
# echo "/**************************************************************
# Can further simplify using subquery in From
# (G. in G.scaledGPA is not really needed because scaledGPA
# is not umbiguous)
# **************************************************************/"
#
# q="select *
# from (select sID, sName, GPA, GPA*(sizeHS/1000.0) as scaledGPA
#       from Student) G
# where abs(G.scaledGPA - GPA) > 1.0;"
#
#
# run_query "$q"

echo "/**************************************************************
  Colleges paired with the highest GPA of their applicants
**************************************************************/"

q="select College.cName, state, GPA
from College, Apply, Student
where College.cName = Apply.cName
  and Apply.sID = Student.sID
  and GPA >= all
          (select GPA from Student, Apply
           where Student.sID = Apply.sID
             and Apply.cName = College.cName);"

run_query "$q"

echo "/*** Add Distinct to remove duplicates ***/"

q="select distinct College.cName, state, GPA
from College, Apply, Student
where College.cName = Apply.cName
  and Apply.sID = Student.sID
  and GPA >= all
          (select GPA from Student, Apply
           where Student.sID = Apply.sID
             and Apply.cName = College.cName);"

run_query "$q"

echo "/*** Use subquery in Select ***/"

q="select distinct cName, state,
  (select distinct GPA
   from Apply, Student
   where College.cName = Apply.cName
     and Apply.sID = Student.sID
     and GPA >= all
           (select GPA from Student, Apply
            where Student.sID = Apply.sID
              and Apply.cName = College.cName)) as GPA
from College;"

run_query "$q"

echo "/*** Now pair colleges with names of their applicants
    (doesn't work due to multiple rows in subquery result) ***/"

q="select distinct cName, state,
  (select distinct sName
   from Apply, Student
   where College.cName = Apply.cName
     and Apply.sID = Student.sID) as sName
from College;"

run_query "$q"
