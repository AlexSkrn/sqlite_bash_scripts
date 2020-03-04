#!/bin/bash

# Run this script from the main dir

# Source run_query()
. ./helper_functions.sh

q_movie="select *
from Movie;"

q_reviewer="select *
from Reviewer;"

q_rating="select *
from Rating;"

for q in "$q_movie" "$q_reviewer" "$q_rating"; do
  query_ratings "$q"
  echo
done

# printf "\nQ1\nFind the names of all reviewers who rated Gone with the Wind\n\n"
#
# q="select distinct Reviewer.name
# from Reviewer
# join Rating on Rating.rID = Reviewer.rID
# join Movie on Movie.mID = Rating.mID
# where Movie.title = 'Gone with the Wind'"
#
# query_ratings "$q"

# printf "\nQ2\nFor any rating where the reviewer is the same as the director
# of the movie, return the reviewer name, movie title, and number of stars\n\n"
#
# q="select name, title, stars
# from Rating
# join Reviewer on Reviewer.rID = Rating.rID
# join Movie on Movie.mID = Rating.mID
# where Reviewer.name = Movie.director"
#
# query_ratings "$q"

# printf "\nQ3\nReturn all reviewer names and movie names together in a single list,
# alphabetized. (Sorting by the first name of the reviewer and first word in the title is
# fine; no need for special processing on last names or removing \"The\".)\n\n"
#
# q="select name from Reviewer
# union
# select title from Movie
# order by name"
#
# query_ratings "$q"

# printf "\nQ4\nFind the titles of all movies not reviewed by Chris Jackson\n\n"
#
# printf "\nFirst, find the titles of all movies reviewed by C.J.:\n\n"
#
# q="select Movie.title
# from Movie
# join Rating on Movie.mID = Rating.mID
# join Reviewer on Reviewer.rID = Rating.rID
# where Reviewer.name = 'Chris Jackson'"
#
# query_ratings "$q"
#
# printf "\nNow, select those titles which are not in this list:\n\n"
#
# q="select Movie.title
# from Movie
# where Movie.title not in
# (select Movie.title
# from Movie
# join Rating on Movie.mID = Rating.mID
# join Reviewer on Reviewer.rID = Rating.rID
# where Reviewer.name = 'Chris Jackson')"
#
# query_ratings "$q"

# printf "\nQ5\nFor all pairs of reviewers such that both reviewers gave a rating
# to the same movie, return the names of both reviewers. Eliminate duplicates,
# don't pair reviewers with themselves, and include each pair only once.
# For each pair, return the names in the pair in alphabetical order\n\n"
#
# printf "\nGroup by mID and rID:\n\n"
#
# q="select mID, rID
# from Rating
# group by mID, rID"
#
# query_ratings "$q"
#
# printf "\nAdd names to the above data. But one group repeats twice and
# I don't see a way to order by name within groups:\n\n"
#
# q="select Rating.mID, Rating.rID, Reviewer.name
# from Rating
# join Reviewer on Rating.rID = Reviewer.rID
# group by Rating.mID, Rating.rID"
#
# query_ratings "$q"

# printf "\nPairs of reviewers who rated the same movie:\n\n"
#
# q="select distinct R1.rID, R2.rID
# from Rating R1, Rating R2
# where R1.mID = R2.mID and R1.rID < R2.rID"
#
# query_ratings "$q"
#
# printf "\nAdd their names:\n\n"
#
# q="select distinct R1.rID, R2.rID, V1.name, V2.name
# from Rating R1, Rating R2, Reviewer V1, Reviewer V2
# where R1.mID = R2.mID and R1.rID < R2.rID
# and V1.rID = R1.rID and V2.rID = R2.rID"
#
# query_ratings "$q"
#
# printf "\nNames only. Still wrong result:\n\n"
#
# q="select distinct V1.name, V2.name
# from Rating R1, Rating R2, Reviewer V1, Reviewer V2
# where R1.mID = R2.mID and R1.rID < R2.rID
# and V1.rID = R1.rID and V2.rID = R2.rID"
#
# query_ratings "$q"
#
# printf "\nWhat if I start by adding names to the Rating Table?\n\n"
#
# q="select R.mID, V.name
# from Rating R
# join Reviewer V on R.rID = V.rID"
#
# query_ratings "$q"
#
# printf "\nFinally, do the same with names as I did with mIDs and rIDs:\n\n"
#
# q="select distinct V1.name, V2.name
# from
# (select R.mID, V.name
# from Rating R
# join Reviewer V on R.rID = V.rID) as V1,
# (select R.mID, V.name
# from Rating R
# join Reviewer V on R.rID = V.rID) as V2
# where V1.mID = V2.mID and V1.name < V2.name
# order by V1.name"
#
# query_ratings "$q"

# printf "\nQ6\nFor each rating that is the lowest (fewest stars) currently
# in the database, return the reviewer name, movie title, and number of stars\n\n"
#
# q="select V.name, M.title, R.stars
# from Rating R
# join Movie M on R.mID = M.mID
# join Reviewer V on R.rID = V.rID
# where stars = (select min(stars) as mn from rating)"
#
# query_ratings "$q"

# printf "\nQ7\nList movie titles and average ratings, from highest-rated to
# lowest-rated. If two or more movies have the same average rating,
# list them in alphabetical order\n\n"
#
# q="select M.title, avg(stars) as avg_stars
# from Rating R
# join Movie M on M.mID = R.mID
# group by R.mID
# order by avg_stars desc, title"
#
# query_ratings "$q"

# printf "\nQ8\nFind the names of all reviewers who have contributed three or
# more ratings. (As an extra challenge, try writing the query
# without HAVING or without COUNT.)\n\n"
#
# q="select V.name
# from Rating R
# join Reviewer V on V.rID = R.rID
# group by R.rID
# having count(R.rID) >= 3"
#
# query_ratings "$q"
#
# printf "\nNow, without having:\n\n"
#
# q="select S.name
# from
# (select V.name name, count(*) as cnt
# from Rating R
# join Reviewer V on V.rID = R.rID
# group by R.rID) S
# where cnt >= 3"
#
# query_ratings "$q"

# printf "\nQ9\nSome directors directed more than one movie. For all such directors, return
# the titles of all movies directed by them, along with the director name. Sort
# by director name, then movie title. (As an extra challenge, try writing
# the query both with and without COUNT.) \n\n"
#
# q="select title, director
# from Movie
# where director in
# (select director
# from Movie
# group by director
# having count(*) > 1)
# order by director, title"
#
# query_ratings "$q"
#
# printf "\nHow about without COUNT?\n\n"
#
# q="select M1.title, M1.director
# from Movie M1, Movie M2
# where M1.director = M2.director and M1.title != M2.title
# order by M1.director, M1.title"
#
# query_ratings "$q"

# printf "\nQ10\nFind the movie(s) with the highest average rating. Return
# the movie title(s) and average rating. (Hint: This query is more difficult
# to write in SQLite than other systems; you might think of it as finding
# the highest average rating and then choosing the movie(s) with that average rating.)\n\n"
#
# q="select M.title, avg(R.stars)
# from Movie M, Rating R
# where M.mID = R.mID
# group by M.title
# "
# query_ratings "$q"
#
# printf "\nIs it possible to re-use the code within the query?\n\n"
#
# q="select Q.title, Q.avg_stars
# from
# (select M.title, avg(R.stars) as avg_stars
# from Movie M, Rating R
# where M.mID = R.mID
# group by M.title) Q
# where Q.avg_stars in
# (select max(S.avg_stars)
# from
# (select M.title, avg(R.stars) as avg_stars
# from Movie M, Rating R
# where M.mID = R.mID
# group by M.title) as S)
# "
# query_ratings "$q"

# printf "\nQ11\nFind the movie(s) with the lowest average rating. Return
# the movie title(s) and average rating. (Hint: This query may be more difficult
# to write in SQLite than other systems; you might think of it as finding
# the lowest average rating and then choosing the movie(s) with that average rating.)\n\n"
#
# printf "\nIs it possible to re-use the code within the query?\n\n"
#
# q="select Q.title, Q.avg_stars
# from
# (select M.title, avg(R.stars) as avg_stars
# from Movie M, Rating R
# where M.mID = R.mID
# group by M.title) Q
# where Q.avg_stars in
# (select min(S.avg_stars)
# from
# (select M.title, avg(R.stars) as avg_stars
# from Movie M, Rating R
# where M.mID = R.mID
# group by M.title) as S)
# "
# query_ratings "$q"

printf "\nQ12\nFor each director, return the director's name together with
the title(s) of the movie(s) they directed that received the highest rating
among all of their movies, and the value of that rating. Ignore movies
whose director is NULL.\n\n"

# printf "\nThis is a wrong solution - it returns the highest rated movie\n\n"
#
# q="select director, title, stars
# from Movie, Rating
# where Movie.mID = Rating.mID
# and stars in
# (select max(stars)
# from Rating)
# and director is not null"
#
# query_ratings "$q"

q="select S.director, S.title, S.stars
from
(select director, title, Rating.mID, stars
from Rating, Movie
where Rating.mID = Movie.mID
and director is not null
group by Rating.mID
having max(stars)) S
group by S.director
having max(S.stars)"

query_ratings "$q"
