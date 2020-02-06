#!/bin/bash

echo "Setting up the College.sqlite database"

sqlite3 ./db/college.sqlite << EOF
drop table if exists College;
drop table if exists Student;
drop table if exists Apply;

create table College(cName text, state text, enrollment int);
create table Student(sID int, sName text, GPA real, sizeHS int);
create table Apply(sID int, cName text, major text, decision text);
EOF

echo "DB setup done!"
