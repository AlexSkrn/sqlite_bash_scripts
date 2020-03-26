#!/bin/bash

# Run this script from the main dir

# Source run_query()
. ./helper_functions.sh


for q in Movie Reviewer Rating; do
  query_ratings ".schema $q"
  query_ratings "select * from $q"
  echo
done

printf "\nCreate a view LateRating contains movie ratings after January 20, 2011.
The view contains the movie ID, movie title, number of stars, and rating date.\n"

q="drop view if exists LateRating;
create view LateRating as
  select distinct R.mID, title, stars, ratingDate
  from Rating R, Movie M
  where R.mID = M.mID
  and ratingDate > '2011-01-20'"

query_ratings "$q"

query_ratings "select * from LateRating"


printf "\nView HighlyRated contains movies with at least one rating above 3 stars.
The view contains the movie ID and movie title.\n"

q="drop view if exists HighlyRated;
create view HighlyRated as
  select mID, title
  from Movie
  where mID in (select mID from Rating where stars > 3) "

query_ratings "$q"

query_ratings "select * from HighlyRated"

printf "\nView NoRating contains movies with no ratings in the database.
The view contains the movie ID and movie title.\n"

query_ratings "drop view if exists NoRating"
q="
create view NoRating as
  select mID, title
  from Movie
  where mID not in (select mID from Rating)"

query_ratings "$q"

query_ratings "select * from NoRating"

# Write an instead-of trigger that enables updates to the title attribute of view LateRating.
#
# Policy: Updates to attribute title in LateRating should update Movie.title for
# the corresponding movie. (You may assume attribute mID is a key for table Movie.)
# Make sure the mID attribute of view LateRating has not also been updated -- if it
# has been updated, don't make any changes. Don't worry about updates to stars or ratingDate.
#
# create trigger t
# instead of update of title
# on LateRating
# when Old.mID = New.mID
# begin
#   update Movie
#   set title = New.title
#   where Movie.mID = Old.mID;
# end

# Write an instead-of trigger that enables updates to the stars attribute of view LateRating.
#
# Policy: Updates to attribute stars in LateRating should update Rating.stars
# for the corresponding movie rating. (You may assume attributes [mID,ratingDate] together
# are a key for table Rating.) Make sure the mID and ratingDate attributes of view
# LateRating have not also been updated -- if either one has been updated, don't make any
# changes. Don't worry about updates to title.
#
# create trigger t
# instead of update of stars
# on LateRating
# when Old.mID = New.mID and Old.ratingDate = New.ratingDate
# begin
#   update Rating
#   set stars = New.stars
#   where Rating.mID = Old.mID and Rating.ratingDate = Old.ratingDate;
# end

# Write an instead-of trigger that enables updates to the mID attribute of view LateRating.
#
# Policy: Updates to attribute mID in LateRating should update Movie.mID and Rating.mID
# for the corresponding movie. Update all Rating tuples with the old mID, not just the ones
# contributing to the view. Don't worry about updates to title, stars, or ratingDate.
#
# create trigger t
# instead of update of mID
# on LateRating
# begin
#   update Rating
#   set mID = New.mID
#   where Rating.mID = Old.mID;
#   update Movie
#   set mID = New.mID
#   where Movie.mID = Old.mID;
# end

# Finally, write a single instead-of trigger that combines all three of the previous
# triggers to enable simultaneous updates to attributes mID, title, and/or stars
# in view LateRating. Combine the view-update policies of the three previous problems,
# with the exception that mID may now be updated. Make sure the ratingDate attribute
# of view LateRating has not also been updated -- if it has been updated, don't make any changes.
#
# create trigger t
# instead of update of mID, title, stars
# on LateRating
# when Old.ratingDate = New.ratingDate
# begin
#   update Rating
#   set mID = New.mID, stars = New.stars
#   where Rating.mID = Old.mID and Rating.ratingDate = Old.ratingDate;
#
#   update Rating
#   set mID = New.mID
#   where Rating.mID = Old.mID;
#
#   update Movie
#   set mID = New.mID, title = New.title
#   where Movie.mID = Old.mID;
# end

# Q5
# Write an instead-of trigger that enables deletions from view HighlyRated.
#
# Policy: Deletions from view HighlyRated should delete all ratings for the corresponding
# movie that have stars > 3.
#
# create trigger t
# instead of delete
# on HighlyRated
# begin
#   delete from Rating
#   where Rating.mID = Old.mID
#   and Rating.stars > 3;
# end


# Q6
# Write an instead-of trigger that enables deletions from view HighlyRated.
#
# Policy: Deletions from view HighlyRated should update all ratings for the corresponding
# movie that have stars > 3 so they have stars = 3.
#
# create trigger t
# instead of delete
# on HighlyRated
# begin
#   update Rating
#   set stars = 3
#   where Rating.mID = Old.mID
#   and Rating.stars > 3;
# end

# Q7
# Write an instead-of trigger that enables insertions into view HighlyRated.
#
# Policy: An insertion should be accepted only when the (mID,title) pair already
# exists in the Movie table. (Otherwise, do nothing.) Insertions into view HighlyRated
# should add a new rating for the inserted movie with rID = 201, stars = 5, and NULL ratingDate.
#
# create trigger t
# instead of insert
# on HighlyRated
# when New.mID in (select mID from Movie) and New.title in (select title from Movie)
# begin
#   insert into Rating (rID, mID, stars, ratingDate)
#   values (201, New.mID, 5, null);
# end


# Q8
# Write an instead-of trigger that enables insertions into view NoRating.
#
# Policy: An insertion should be accepted only when the (mID,title) pair already
# exists in the Movie table. (Otherwise, do nothing.) Insertions into view NoRating
# should delete all ratings for the corresponding movie.
#
# create trigger t
# instead of insert
# on NoRating
# when New.mID in (select mID from Movie) and New.title in (select title from Movie)
# begin
#   delete from Rating
#   where Rating.mID = New.mID;
# end

# Q9
# Write an instead-of trigger that enables deletions from view NoRating.
# Policy: Deletions from view NoRating should delete the corresponding movie from the Movie table.
#
# create trigger t
# instead of delete
# on NoRating
# begin
#   delete from Movie
#   where Movie.mID = Old.mID;
# end

# Q10
# Write an instead-of trigger that enables deletions from view NoRating.
#
# Policy: Deletions from view NoRating should add a new rating for the deleted
# movie with rID = 201, stars = 1, and NULL ratingDate.
#
# create trigger t
# instead of delete
# on NoRating
# begin
#   insert into Rating (rID, mID, stars, ratingDate)
#   values (201, Old.mID, 1, null);
# end
