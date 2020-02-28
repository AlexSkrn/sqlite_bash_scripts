#!/bin/bash

echo "/**************************************************************
  TABLE VARIABLES AND SET OPERATORS
  Works for SQLite, Postgres
  MySQL doesn't support Intersect or Except
**************************************************************/"

run_query(){
sqlite3 ./db/college.sqlite << EOF
.headers on
.mode column
$1
EOF
}

echo "/**************************************************************
  Application information
**************************************************************/"
q="select Student.sID, sName, GPA, Apply.cName, enrollment
from Student, College, Apply
where Apply.sID = Student.sID and Apply.cName = College.cName;"

run_query "$q"

echo "/*** Introduce table variables ***/"

q="select S.sID, S.sName, S.GPA, A.cName, C.enrollment
from Student S, College C, Apply A
where A.sID = S.sID and A.cName = C.cName;"

run_query "$q"

echo "/**************************************************************
  Pairs of students with same GPA
**************************************************************/"

q="select S1.sID, S1.sName, S1.GPA, S2.sID, S2.sName, S2.GPA
from Student S1, Student S2
where S1.GPA = S2.GPA;"

run_query "$q"

echo "/*** Get rid of self-pairings ***/"

q="select S1.sID, S1.sName, S1.GPA, S2.sID, S2.sName, S2.GPA
from Student S1, Student S2
where S1.GPA = S2.GPA and S1.sID <> S2.sID;"

run_query "$q"

echo "/*** Get rid of reverse-pairings ***/"

q="select S1.sID, S1.sName, S1.GPA, S2.sID, S2.sName, S2.GPA
from Student S1, Student S2
where S1.GPA = S2.GPA and S1.sID < S2.sID;"

run_query "$q"

echo "/**************************************************************
  List of college names and student names
**************************************************************/"

q="select cName from College
union
select sName from Student;"

run_query "$q"

echo "/*** Add 'As name' to both sides ***/"

q="select cName as name from College
union
select sName as name from Student;"

run_query "$q"

echo "/*** Change to Union All ***/"

q="select cName as name from College
union all
select sName as name from Student;"

run_query "$q"

echo "/*** Notice not sorted any more (SQLite), add order by cName ***/"

q="select cName as name from College
union all
select sName as name from Student
order by name;"

run_query "$q"

echo "/**************************************************************
  IDs of students who applied to both CS and EE
**************************************************************/"

q="select sID from Apply where major = 'CS'
intersect
select sID from Apply where major = 'EE';"

run_query "$q"

# sID         cName       major       decision
# ----------  ----------  ----------  ----------
# 123         Stanford    CS          Y
# 123         Berkeley    CS          Y
# 345         Cornell     CS          Y
# 987         Stanford    CS          Y
# 987         Berkeley    CS          Y
# 876         Stanford    CS          N
# 543         MIT         CS          N
#
# sID         cName       major       decision
# ----------  ----------  ----------  ----------
# 123         Stanford    EE          N
# 123         Cornell     EE          Y
# 345         Cornell     EE          N

echo "/**************************************************************
  IDs of students who applied to both CS and EE
  Some systems don't support intersect
**************************************************************/"

q="select A1.sID
from Apply A1, Apply A2
where A1.sID = A2.sID and A1.major = 'CS' and A2.major = 'EE';"

run_query "$q"

echo "/*** Why so many duplicates? Look at Apply table ***/
/*** Add Distinct ***/"

q="select distinct A1.sID
from Apply A1, Apply A2
where A1.sID = A2.sID and A1.major = 'CS' and A2.major = 'EE';"

run_query "$q"

echo "/**************************************************************
  IDs of students who applied to CS but not EE
**************************************************************/"

q="select sID from Apply where major = 'CS'
except
select sID from Apply where major = 'EE';"

run_query "$q"

echo "/**************************************************************
  IDs of students who applied to CS but not EE
  Some systems don't support except
**************************************************************/"

q="select A1.sID
from Apply A1, Apply A2
where A1.sID = A2.sID and A1.major = 'CS' and A2.major <> 'EE';"

run_query "$q"

echo "/*** Add Distinct ***/"

q="select distinct A1.sID
from Apply A1, Apply A2
where A1.sID = A2.sID and A1.major = 'CS' and A2.major <> 'EE';"

run_query "$q"

echo "/*** Can't do it with constructs we have so far ***/"
