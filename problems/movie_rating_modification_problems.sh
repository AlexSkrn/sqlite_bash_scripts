#!/bin/bash

# Run this script from the main dir

# Source run_query()
. ./helper_functions.sh


for q in Movie Reviewer Rating; do
  query_ratings ".schema $q"
  query_ratings "select * from $q"
  echo
done

# printf "\nQ1\nAdd the reviewer Roger Ebert to your database, with an rID of 209\n\n"
#
# q="insert into Reviewer values (209, 'Roger Ebert')"
#
# query_ratings "$q"
#
# q="select * from Reviewer order by rID, name"
#
# query_ratings "$q"

# printf "\nQ2\nInsert 5-star ratings by James Cameron for all movies in the database.
# Leave the review date as NULL.\n\n"
#
# printf "\nWhat will be added:\n"
#
# q="select rID, mID, 5, null
# from Movie, Reviewer
# where name = 'James Cameron'"
#
# query_ratings "$q"
#
# q="insert into Rating
# select rID, mID, 5, null
# from Movie, Reviewer
# where name = 'James Cameron'"
#
# query_ratings "$q"
#
# printf "\nChecking:"
#
# q="select * from Rating where stars = 5 order by rID, mID"
#
# query_ratings "$q"

# printf "\nQ3\nFor all movies that have an average rating of 4 stars or higher,
# add 25 to the release year. (Update the existing tuples; don't insert new tuples.)\n\n"
#
# printf "\nWhat movies are to be updated:\n"
#
# q="select mID
# from Rating
# group by mID
# having avg(stars) >= 4"
#
# query_ratings "$q"
#
# printf "\nHow the updated data will look like:\n"
# q="select year + 25
# from Movie
# where mID in
# (select mID
# from Rating
# group by mID
# having avg(stars) >= 4)"
#
# query_ratings "$q"
#
# printf "\nNow, update the table:\n"
#
# q="update Movie
# set year = year + 25
# where mID in
# (select mID
# from Rating
# group by mID
# having avg(stars) >= 4)"
#
# query_ratings "$q"
#
# printf "\nView the results:\n"
#
# query_ratings "select * from Movie order by mID"

# printf "\nQ4\nRemove all ratings where the movie's year is before 1970 or after 2000,
# and the rating is fewer than 4 stars.\n\n"
#
# printf "\nFirst see in which rows stars will deleted:\n"
#
# q="select *
# from Rating
# where mID in
# (select mID
# from Movie
# where year < 1970 or year > 2000)
# and stars < 4"
#
# query_ratings "$q"
#
# printf "\nThen delete them\n"
#
# q="delete from Rating
# where mID in
# (select mID
# from Movie
# where year < 1970 or year > 2000)
# and stars < 4"
#
# query_ratings "$q"
#
# printf "\nSee the results:\n"
#
# query_ratings "select * from Rating"
