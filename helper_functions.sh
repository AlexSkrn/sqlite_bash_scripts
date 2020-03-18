#!/bin/bash

run_query(){
sqlite3 ./db/college.sqlite << EOF
.headers on
.mode column
$1
EOF
}

query_ratings(){
sqlite3 ./db/ratings.sqlite << EOF
.headers on
.mode column
$1
EOF
}

query_social(){
sqlite3 ./db/social.sqlite << EOF
.headers on
.mode column
$1
EOF
}
