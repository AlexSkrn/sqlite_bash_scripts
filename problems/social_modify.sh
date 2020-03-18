#!/bin/bash

# Run this script from the main dir

# Source run_query()
. ./helper_functions.sh


for q in Highschooler Friend Likes; do
  query_social ".schema $q"
  query_social "select * from $q"
  echo
done

# printf "\nQ1\nIt's time for the seniors to graduate. Remove all 12th graders from Highschooler.\n\n"
#
# q="delete
# from Highschooler
# where grade = 12"
#
# query_social "$q"
#
# printf "\nSee the results:\n"
#
# query_social "select * from Highschooler order by ID"

printf "\nQ2\nIf two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.\n\n"

# q="select * from Likes
# where ID1 in
# (select F.ID1
# from Friend F
# join Likes L on L.ID1 = F.ID1
# where F.ID1 = L.ID1 and F.ID2 = L.ID2
# and not (F.ID2 = L.ID1 and F.ID1 = L.ID2)
# and F.ID1 < F.ID2)
# and ID2 in
# (select F.ID2
# from Friend F
# join Likes L on L.ID1 = F.ID1
# where F.ID1 = L.ID1 and F.ID2 = L.ID2
# and not (F.ID2 = L.ID1 and F.ID1 = L.ID2)
# and F.ID1 < F.ID2)"

# printf "\nFind students where A likes B but not vice-versa:\n"
#
# q="select ID1, H1.name, ID2, H2.name
# from Likes
# join Highschooler H1 on H1.ID = ID1
# join Highschooler H2 on H2.ID = ID2
# where not (ID1 in (select ID2 from Likes)
# and ID2 in (select ID1 from Likes))"
#
# query_social "$q"
#
# printf "\nThe following works but looks ugly:\n"
#
# q="delete from Likes
# where ID1 in
# (select L.ID1
# from Likes L
# join Highschooler H1 on H1.ID = L.ID1
# join Highschooler H2 on H2.ID = L.ID2
# join Friend F1 on F1.ID1 = L.ID1
# join Friend F2 on F2.ID2 = L.ID2
# where not (L.ID1 in (select ID2 from Likes) and L.ID2 in (select ID1 from Likes))
# and F1.ID1 = L.ID1 and F1.ID2 = L.ID2)
# and ID2 in
# (select L.ID2
# from Likes L
# join Highschooler H1 on H1.ID = L.ID1
# join Highschooler H2 on H2.ID = L.ID2
# join Friend F1 on F1.ID1 = L.ID1
# join Friend F2 on F2.ID2 = L.ID2
# where not (L.ID1 in (select ID2 from Likes) and L.ID2 in (select ID1 from Likes))
# and F1.ID1 = L.ID1 and F1.ID2 = L.ID2)"
#
# query_social "$q"
