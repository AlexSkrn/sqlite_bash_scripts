#!/bin/bash

# Run this script from the main dir

# Source run_query()
. ./helper_functions.sh


for q in Highschooler Friend Likes; do
  query_social ".schema $q"
  query_social "select * from $q"
  echo
done

# printf "\nQ1
# Write a trigger that makes new students named 'Friendly' automatically like everyone else
# in their grade. That is, after the trigger runs, we should have ('Friendly', A) in the Likes
# table for every other Highschooler A in the same grade as 'Friendly'.\n\n"
#
# q="drop trigger if exists T;
# create trigger T
# after insert on Highschooler
# when New.name = 'Friendly'
# begin
# insert into Likes select H1.ID, H2.ID
# from Highschooler H1, Highschooler H2
# where H1.name = 'Friendly' and H2.name <> 'Friendly' and H1.grade = H2.grade
# except
# select ID1, ID2
# from Likes;
# end"
#
# query_social "$q"
#
# q="insert into Highschooler values (1000, 'Friendly', 9);
# insert into Highschooler values (2000, 'Friendly', 11);
# insert into Highschooler values (3000, 'Unfriendly', 10)"
#
# query_social "$q"
#
# q="select H1.name, H1.grade, H2.name, H2.grade
# from Likes L, Highschooler H1, Highschooler H2
# where L.ID1 = H1.ID and L.ID2 = H2.ID
# order by H1.name, H1.grade, H2.name, H2.grade"
#
# query_social "$q"

# printf "\nQ2
# Write one or more triggers to manage the grade attribute of new Highschoolers.
# If the inserted tuple has a value less than 9 or greater than 12, change
# the value to NULL. On the other hand, if the inserted tuple has a null value
# for grade, change it to 9.\n\n"
#
# printf "\nFor some reason, the statement 'when New.grade = null' does not work.
# But a workaround statement, when typeof(New.grade) <> 'integer', does.\n"
#
# q="create trigger T
# after insert on Highschooler
# for each row
# when typeof(New.grade) <> 'integer'
# begin
#   update Highschooler
#   set grade = 9
#   where ID = New.ID;
# end"
#
# query_social "$q"
#
# q="create trigger S
# after insert on Highschooler
# for each row
# when New.grade < 9 or New.grade > 12
# begin
#   update Highschooler
#   set grade = null
#   where ID = New.ID;
# end"
#
# query_social "$q"
#
# q="insert into Highschooler values (2121, 'Caitlin', null);
# insert into Highschooler values (2122, 'Don', null);
# insert into Highschooler values (2123, 'Elaine', 7);
# insert into Highschooler values (2124, 'Frank', 20);
# insert into Highschooler values (2125, 'Gale', 10)"
#
# query_social "$q"
#
# q="select * from Highschooler order by ID"
#
# query_social "$q"

# printf "\nQ
# Write one or more triggers to maintain symmetry in friend relationships.
# Specifically, if (A,B) is deleted from Friend, then (B,A) should be deleted too.
# If (A,B) is inserted into Friend then (B,A) should be inserted too.
# Don't worry about updates to the Friend table.\n\n"
#
# q="create trigger S
# after delete on Friend
# for each row
# begin
#   delete from Friend
#   where ID1 = Old.ID2 and ID2 = Old.ID1;
# end"
#
# query_social "$q"
#
# q="create trigger T
# after insert on Friend
# for each row
# begin
#   insert into Friend values (New.ID2, New.ID1);
# end"
#
# query_social "$q"
#
# printf "\nChecking these triggers.
# Description of modifications:
# Deleted friendship (Brittany, 10, Kris, 10);
# Deleted friendship (Alexis, 11, Gabriel, 11);
# Inserted friendship (Jordan, 9, Kyle, 12);
# Inserted friendship (Haley, 10, Cassandra, 9)\n\n"
#
# q="delete from Friend where ID1 = 1641 and ID2 = 1468;
# delete from Friend where ID1 = 1247 and ID2 = 1911;
# insert into Friend values (1510, 1934);
# insert into Friend values (1101, 1709)"
#
# query_social "$q"
#
# q="select H1.name, H1.grade, H2.name, H2.grade
# from Friend F, Highschooler H1, Highschooler H2
# where F.ID1 = H1.ID and F.ID2 = H2.ID
# order by H1.name, H1.grade, H2.name, H2.grade"
#
# query_social "$q"

# printf "\nQ4
# Write a trigger that automatically deletes students when they graduate,
# i.e., when their grade is updated to exceed 12.\n\n"
#
# q="create trigger S
# after update of grade on Highschooler
# for each row
# begin
#   delete from Highschooler where ID = New.ID and grade > 12;
# end"
#
# query_social "$q"
#
# printf "\nInclude Austin, Kyle, and Logan into graduates:\n\n"
#
# q="update Highschooler
# set grade = grade + 1
# where name = 'Austin' or name = 'Kyle' or name = 'Logan'"
#
# query_social "$q"
#
# q="select * from Highschooler
# order by name, grade"

# printf "\nQ5
# Write a trigger that automatically deletes students when they graduate,
# i.e., when their grade is updated to exceed 12 (same as Question 4).
# In addition, write a trigger so when a student is moved ahead one grade,
# then so are all of his or her friends.\n\n"
#
#
# q="create trigger S
# after update of grade on Highschooler
# for each row
# begin
#   delete from Highschooler where ID = New.ID and grade > 12;
# end"
#
# query_social "$q"
#
# q="create trigger T
# after update of grade on Highschooler
# for each row
# when New.grade - Old.grade = 1
# begin
#   update Highschooler
#   set grade = 1 + grade
#   where ID in (select ID2 from Friend where ID1 = New.ID);
# end"
#
# query_social "$q"
#
# q="update Highschooler
# set grade = grade + 1
# where name = 'Austin' or name = 'Kyle' or name = 'Logan'"
#
# query_social "$q"
#
# q="select * from Highschooler
# order by name, grade"
#
# query_social "$q"

# printf "\nQ6
# Write a trigger to enforce the following behavior:
# If A liked B but is updated to A liking C instead, and B and C were friends,
# make B and C no longer friends. Don't forget to delete the friendship in both
# directions, and make sure the trigger only runs when the 'liked' (ID2) person
# is changed but the 'liking' (ID1) person is not changed.\n\n"
#
# q="create trigger S
# after update of ID2 on Likes
# for each row
# when New.ID2 <> Old.ID2 and Old.ID1 = New.ID1
# begin
#   delete from Friend
#   where (Old.ID2 = ID1 and New.ID2 = ID2)
#   or (New.ID2 = ID1 and Old.ID2 = ID2);
# end"
#
# query_social "$q"
#
# printf "\nChecking:
# Description of modifications:
# Changed Gabriel-11 to like Jessica-11 instead of Alexis-11;
# Changed Jessica-11 to like Austin-11 instead of Kyle-12;
# Changed Kyle-12 to like Jordan-12 instead of Jessica-11;
# Changed 'John-12 liking Haley-10' to 'Logan-12 liking Brittany-10';
# Changed Alexis-11 to like Kris-10 instead of Kris-10 (so no actual change)\n\n"
#
# query_social "$q"
#
# q="update Likes set ID2 = 1501 where ID1 = 1911;
# update Likes set ID2 = 1316 where ID1 = 1501;
# update Likes set ID2 = 1304 where ID1 = 1934;
# update Likes set ID1 = 1661, ID2 = 1641 where ID1 = 1025;
# update Likes set ID2 = 1468 where ID1 = 1247"
#
# query_social "$q"
#
# q="select H1.name, H1.grade, H2.name, H2.grade
# from Friend F, Highschooler H1, Highschooler H2
# where F.ID1 = H1.ID and F.ID2 = H2.ID
# order by H1.name, H1.grade, H2.name, H2.grade"
#
# query_social "$q"
