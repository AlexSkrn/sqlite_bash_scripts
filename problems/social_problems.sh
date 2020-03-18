#!/bin/bash

# Run this script from the main dir

# Source run_query()
. ./helper_functions.sh


for q in Highschooler Friend Likes; do
  query_social "select * from $q"
  query_social ".schema $q"
  echo
done



# printf "\nQ1\nFind the names of all students who are friends with someone named Gabriel.\n\n"
#
# q="select ID1, ID2
# from Highschooler
# join Friend on Highschooler.ID = Friend.ID1
# where ID1 in (select ID from Highschooler where name = 'Gabriel')"
#
# query_social "$q"
#
# q="select name
# from Highschooler
# where ID in
# (select ID2
# from Highschooler
# join Friend on Highschooler.ID = Friend.ID1
# where ID1 in (select ID from Highschooler where name = 'Gabriel'))"
#
# query_social "$q"

# printf "\nQ2\'nFor every student who likes someone 2 or more grades younger than
# themselves, return that student's name and grade, and the name and grade of the student they like.\n\n"
#
# q="select H1.name, H1.grade, H2.name, H2.grade
# from Highschooler H1, Highschooler H2
# join Likes on H1.ID = Likes.ID1
# where Likes.ID1 = H1.ID and Likes.ID2 = H2.ID
# and H1.grade - H2.grade >= 2
# "
#
# query_social "$q"

# printf "\nQ3\nFor every pair of students who both like each other, return
# the name and grade of both students. Include each pair only once, with
# the two names in alphabetical order.\n\n"
#
# q="select *
# from Likes
# where ID1 in
# (select ID2
# from Likes)
# and ID2 in
# (select ID1
# from Likes)
# and ID1 < ID2"
#
# query_social "$q"
#
# printf "\nThis is incorrect. Output needs to be in 4 columns.\n\n"
#
# q="select name, grade
# from Highschooler,
# (select *
# from Likes
# where ID1 in
# (select ID2
# from Likes)
# and ID2 in
# (select ID1
# from Likes)
# and ID1 < ID2) L
# where ID = L.ID1 or ID = L.ID2
# order by name"
#
# query_social "$q"
#
# printf "\nThis one is right.\n\n"
#
# q="select H1.name, H1.grade, H2.name, H2.grade
# from
# (select *
# from Likes
# where ID1 in
# (select ID2
# from Likes)
# and ID2 in
# (select ID1
# from Likes)
# ),
# Highschooler H1,
# Highschooler H2
# where H1.ID = ID1 and H2.ID = ID2 and H1.name < H2.name"
#
# query_social "$q"

# printf "\nQ4\nFind all students who do not appear in the Likes table
# (as a student who likes or is liked) and return their names and grades.
# Sort by grade, then by name within each grade.\n\n"
#
# q="select name, grade
# from Highschooler
# where (ID not in (select ID1 from Likes)) and (ID not in (select ID2 from Likes))
# order by grade, name"
#
# query_social "$q"

# printf "\nQ5\nFor every situation where student A likes student B, but we have no
# information about whom B likes (that is, B does not appear as an ID1 in the Likes table),
# return A and B's names and grades.\n\n"
#
# q="select H1.name, H1.grade, H2.name, H2.grade
# from Likes
# join Highschooler H1 on H1.ID = ID1
# join Highschooler H2 on H2.ID = ID2
# where ID2 not in (select ID1 from Likes)"
#
# query_social "$q"

# printf "\nQ6\nFind names and grades of students who only have friends in the same grade.
# Return the result sorted by grade, then by name within each grade.\n\n"
#
# printf "\nStep 1 - Group by ID1 and count the # of unique grades:\n"
#
# q="select ID1, H1.name, H1.grade, ID2, H2.grade, count(distinct H2.grade)
# from Friend
# join Highschooler H1 on H1.ID = ID1
# join Highschooler H2 on H2.ID = ID2
# group by ID1"
#
# query_social "$q"
#
# printf "\nStep 2 - Two conditions must be met, the # of unique grades must be
# one and the grade of each pair of friends must be the same
# (although the latter does not matter in this dataset):\n"
#
# q="select S.name, S.g1
# from
# (select ID1, H1.name, H1.grade g1, ID2, H2.grade g2, count(distinct H2.grade) as cnt
# from Friend
# join Highschooler H1 on H1.ID = ID1
# join Highschooler H2 on H2.ID = ID2
# group by ID1) as S
# where S.cnt = 1 and S.g1 = S.g2
# order by S.g1, S.name"
#
# query_social "$q"

# printf "\nQ7\nFor each student A who likes a student B where the two are not friends,
# find if they have a friend C in common (who can introduce them!). For all such trios,
# return the name and grade of A, B, and C.\n\n"
#
# printf "Explore 1 - Difference of Likes and Friends:\n"
#
# q="select ID1 A_likes, ID2 B
# from Likes
# except
# select ID1, ID2
# from Friend"
#
# query_social "$q"
#
# # Student_A_likes  Student_B
# # ---------------  ----------
# # 1025             1101
# # 1247             1468
# # 1316             1304
# # 1782             1709
#
# printf "\nExplore 2 - common friends of 1316 and 1304 by using intersect:\n"
#
# q="select ID2
# from Friend
# where ID1 = '1316'
# intersect
# select ID2
# from Friend
# where ID1 = '1304'"
#
# query_social "$q"
#
# # ID2
# # ----------
# # 1782
# # 1934
#
# printf "\nExplore 3 - common friends of 1316 and 1304 without intersect:\n"
#
# q="select F1.ID2
# from Friend F1, Friend F2
# where F1.ID2 = F2.ID2 and F1.ID1 = '1316' and F2.ID1 = '1304'"
#
# query_social "$q"
# # ID2
# # ----------
# # 1934
# # 1782
#
#
# printf "\nIt is unclear to me how to combine such queries, so I will cheat here:\n"
#
# q="SELECT DISTINCT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
# FROM Highschooler H1, Highschooler H2, Highschooler H3, Likes L, Friend F1, Friend F2
# WHERE (H1.ID = L.ID1 AND H2.ID = L.ID2) AND H2.ID NOT IN (
# SELECT ID2
# FROM Friend
# WHERE ID1 = H1.ID
# ) AND (H1.ID = F1.ID1 AND H3.ID = F1.ID2) AND (H2.ID = F2.ID1 AND H3.ID = F2.ID2)"
#
# query_social "$q"

# printf "\nQ8\nFind the difference between the number of students in the school
# and the number of different first names. "
#
# q="select H1.cnt - H2.cnt
# from
# (select count(ID) as cnt from Highschooler) H1,
# (select count(distinct name) as cnt from Highschooler) H2"
#
# query_social "$q"

printf "\nQ9\nFind the name and grade of all students who are liked by more than one other student.\n\n"

q="select name, grade
from Likes
join Highschooler on ID = ID2
group by ID2
having count(*) > 1"

query_social "$q"
