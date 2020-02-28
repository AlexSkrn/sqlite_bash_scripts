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


# printf "Find the titles of all movies directed by Steven Spielberg\n"
#
# q="select title
# from Movie
# where director = 'Steven Spielberg';"
#
# query_ratings "$q"

# printf "\nFind all years that have a movie that received a rating of
# 4 or 5, and sort them in increasing order\n\n"
#
# q="select distinct year
# from Movie M join Rating R on M.mID=R.mID
# where stars >= 4
# order by year asc;"
#
# query_ratings "$q"

# printf "\nFind the titles of all movies that have no ratings\n\n"
#
# q="select title
# from Movie
# where mID not in (select distinct mID from Rating);"
#
# query_ratings "$q"

# printf "\nSome reviewers didn't provide a date with their rating.
# Find the names of all reviewers who have ratings with a NULL value for the date\n\n"
#
# q="select name
# from Reviewer V join Rating R on V.rID=R.rID
# where ratingDate is null;"
#
# query_ratings "$q"

# printf "\nQ5\nWrite a query to return the ratings data in a more readable format:
# reviewer name, movie title, stars, and ratingDate. Also, sort the data,
# first by reviewer name, then by movie title, and lastly by number of stars\n\n"
#
# q="select name, title, stars, ratingDate
# from Movie M join Rating R on M.mID = R.mID join Reviewer V on R.rID = V.rID
# order by name, title, stars;"
#
# query_ratings "$q"

# printf "Q6\nFor all cases where the same reviewer rated the same movie twice and gave
# it a higher rating the second time, return the reviewer's name
# and the title of the movie (expected result: Gone with the Wind - Gone with the Wind)\n\n"
#
# printf "\nThis selects all rows with reviewers who rated the same movie twice\n"
#
# q="select R.*
# from Rating as R
# join
# (select rID, mID, count(*)
# from Rating
# group by rID, mID
# having count(*) > 1 ) as Subq
# on R.rID = Subq.rID AND R.mID = Subq.mID;"
#
# query_ratings "$q"
#
# printf "\nNow make a join with conditions. HOW TO RE-USE A BASH VARIABLE
# WITHOUT REPEATING THE SUBQUERY TWICE?\n"
#
# q2="select A.*
# from
# (select R.*
# from Rating as R
# join
# (select rID, mID, count(*)
# from Rating
# group by rID, mID
# having count(*) > 1 ) as Subq
# on R.rID = Subq.rID AND R.mID = Subq.mID) as A,
# (select R.*
# from Rating as R
# join
# (select rID, mID, count(*)
# from Rating
# group by rID, mID
# having count(*) > 1 ) as Subq
# on R.rID = Subq.rID AND R.mID = Subq.mID) as B
# where A.rID = B.rID and A.mID = B.mID and A.stars > B.stars and A.ratingDate > B.ratingDate;"
#
# query_ratings "$q2"
#
#
# printf "\nFinal result\n"
#
# q3="select name, title
# from Reviewer, Movie,
# (select A.*
# from
# (select R.*
# from Rating as R
# join
# (select rID, mID, count(*)
# from Rating
# group by rID, mID
# having count(*) > 1 ) as Subq
# on R.rID = Subq.rID AND R.mID = Subq.mID) as A,
# (select R.*
# from Rating as R
# join
# (select rID, mID, count(*)
# from Rating
# group by rID, mID
# having count(*) > 1 ) as Subq
# on R.rID = Subq.rID AND R.mID = Subq.mID) as B
# where A.rID = B.rID and A.mID = B.mID and A.stars > B.stars and A.ratingDate > B.ratingDate)
# as SubSubQuery
# where SubSubQuery.rID = Reviewer.rID and SubSubQuery.mID = Movie.mID;"
#
# query_ratings "$q3"


# printf "\nQ7\nFor each movie that has at least one rating, find the highest number of
# stars that movie received. Return the movie title and number of stars.
# Sort by movie title.\n\n"
#
# q="select title, max(stars)
# from Rating, Movie
# where Movie.mID = Rating.mID
# group by Rating.mID
# order by title;"
#
# query_ratings "$q"

# printf "\nQ8\nFor each movie, return the title and the 'rating spread', that is,
# the difference between highest and lowest ratings given to that movie.
# Sort by rating spread from highest to lowest, then by movie title.\n\n"
#
# printf "!!! NOTE: If I make a column name with a space, SQlite ignores it when sorting !!!\n\n"
#
# q="select title, max(stars) - min(stars) as spread
# from Rating, Movie
# where Movie.mID = Rating.mID
# group by Rating.mID
# order by spread desc, title;"
#
# query_ratings "$q"

printf "\nQ9\nFind the difference between the average rating of movies
released before 1980 and the average rating of movies released after 1980.
(Make sure to calculate the average rating for each movie, then the average
of those averages for movies before 1980 and movies after. Don't just
calculate the overall average rating before and after 1980.)\n\n"

printf "\nLet me do this in steps. First, put all I need together:\n\n"

q="select title, avg(stars) as avg_per_movie, year
from Movie, Rating
where Movie.mID = Rating.mID
group by title;
"
query_ratings "$q"

printf "\nNow, this is the average of averages for movies before 1980:\n\n"

q="select avg(avg_per_movie)
from
(select title, avg(stars) as avg_per_movie, year
from Movie, Rating
where Movie.mID = Rating.mID
group by title)
where year < 1980
"
query_ratings "$q"

printf "\nAlmost there, select from two such queries:\n\n"

q="select before.avg_before_1980, after.avg_after_1980
from
(select avg(avg_per_movie) as avg_before_1980
from
(select title, avg(stars) as avg_per_movie, year
from Movie, Rating
where Movie.mID = Rating.mID
group by title)
where year >= 1980) as before,
(select avg(avg_per_movie) as avg_after_1980
from
(select title, avg(stars) as avg_per_movie, year
from Movie, Rating
where Movie.mID = Rating.mID
group by title)
where year < 1980) as after
"

query_ratings "$q"

printf "\nFinally, the difference:\n\n"

q="select after.avg_after_1980 - before.avg_before_1980
from
(select avg(avg_per_movie) as avg_before_1980
from
(select title, avg(stars) as avg_per_movie, year
from Movie, Rating
where Movie.mID = Rating.mID
group by title)
where year >= 1980) as before,
(select avg(avg_per_movie) as avg_after_1980
from
(select title, avg(stars) as avg_per_movie, year
from Movie, Rating
where Movie.mID = Rating.mID
group by title)
where year < 1980) as after
"

query_ratings "$q"
