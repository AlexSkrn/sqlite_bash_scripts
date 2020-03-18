#!/bin/bash

# Run this script from the main dir

# Source run_query()
. ./helper_functions.sh


for q in Highschooler Friend Likes; do
  query_social "select * from $q"
  query_social ".schema $q"
  echo
done


# printf "\nQ1\nFor every situation where student A likes student B, but student B likes
# a different student C, return the names and grades of A, B, and C.\n\n"
#
# q="select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
# from Highschooler H1, Highschooler H2, Highschooler H3, Likes L
# where (H1.ID = L.ID1 and H2.ID = L.ID2)
# and H2.ID in (select ID1 from Likes where ID1 = H2.ID and ID2 = H3.ID and ID2 <> H1.ID)"
#
# query_social "$q"

# printf "\nQ2\nFind those students for whom all of their friends are in different
# grades from themselves. Return the students' names and grades.\n\n"
#
# printf "\nStep 1 - Find all student IDs who have friends in the same grade:\n\n"
#
# q="select ID1, H1.name, H1.grade, ID2, H2.name, H2.grade
# from Friend
# join Highschooler H1 on H1.ID = ID1
# join Highschooler H2 on H2.ID = ID2
# where ID1 < ID2 and H1.grade = H2.grade"
#
# query_social "$q"
#
# printf "\nChoose those who are in ID1 in Friend but not listed in ID1 above\n:"
#
# q="select name, grade
# from Highschooler
# where ID in
# (select distinct ID1
# from Friend
# where ID1 not in
# (select ID1
# from Friend
# join Highschooler H1 on H1.ID = ID1
# join Highschooler H2 on H2.ID = ID2
# where ID1 < ID2 and H1.grade = H2.grade)
# and ID1 < ID2)"
#
# query_social "$q"

# printf "\nQ3\nWhat is the average number of friends per student? (Your result
# should be just one number.)\n\n"
#
# printf "\nCalculate the numerator:\n\n"
#
# q="select sum(S)
# from
# (select count(ID2) as S
# from Friend
# where ID1 < ID2
# group by ID1)"
#
# query_social "$q"
#
# printf "\nCalculate the denominator:\n\n"
#
# q="select count(*) as Cnt
# from Highschooler"
#
# query_social "$q"
#
# printf "\nCombine the above results:\n\n"
#
# q="select sum(Numerator.S) * 1.0 /  Denominator.Cnt
# from
# (select count(ID2) as S
# from Friend
# where ID1 < ID2
# group by ID1) as Numerator,
# (select count(*) as Cnt
# from Highschooler) as Denominator"
#
# query_social "$q"
#
# printf "\nStill incorrect because the expected result seems to require a double
# of that average. I can achieve this by not eliminating a half of friendship pairs:\n\n"
#
# q="select cast(sum(Numerator.S) as float) /  Denominator.Cnt
# from
# (select count(ID2) as S
# from Friend
# group by ID1) as Numerator,
# (select count(*) as Cnt
# from Highschooler) as Denominator"
#
# query_social "$q"

# printf "\nQ4\nFind the number of students who are either friends with Cassandra
# or are friends of friends of Cassandra. Do not count Cassandra, even though
# technically she is a friend of a friend.\n\n"
#
# printf "\nCassandra's friends:\n\n"
#
# q="select F.ID1, H1.name, F.ID2, H2.name
# from Friend F
# join Highschooler H1 on F.ID1 = H1.ID
# join Highschooler H2 on F.ID2 = H2.ID
# where H1.name = 'Cassandra'
# "
#
# query_social "$q"
#
# printf "\nFriends of Cassandra's friends, excluding Cassandra:\n\n"
#
# q="select ID1, ID2
# from Friend
# where ID1 in
# (select F.ID2
# from Friend F
# join Highschooler H1 on F.ID1 = H1.ID
# join Highschooler H2 on F.ID2 = H2.ID
# where H1.name = 'Cassandra')
# and ID2 <> (select ID from Highschooler where name = 'Cassandra')
# "
#
# query_social "$q"
#
# printf "\nSum unique ID1's and unqiue ID2's:\n\n"
#
# q="select count(distinct ID1) + count(distinct ID2) as Total
# from
# (select ID1, ID2
# from Friend
# where ID1 in
# (select F.ID2
# from Friend F
# join Highschooler H1 on F.ID1 = H1.ID
# join Highschooler H2 on F.ID2 = H2.ID
# where H1.name = 'Cassandra')
# and ID2 <> (select ID from Highschooler where name = 'Cassandra'))
# "
#
# query_social "$q"

# printf "\nQ5\nFind the name and grade of the student(s) with the greatest number of friends\n\n"
#
# q="select *, count(ID2) as cnt
# from Friend
# group by ID1"
#
# query_social "$q"
#
# q="select ID1, max(cnt)
# from
# (select *, count(ID2) as cnt
# from Friend
# group by ID1)"
#
# query_social "$q"
#
# q="select name, grade
# from
# (select *, count(ID2) as cnt
# from Friend
# group by ID1) S
# join Highschooler on ID = ID1
# where cnt =
# (select max(cnt)
# from
# (select *, count(ID2) as cnt
# from Friend
# group by ID1))"
#
# query_social "$q"
