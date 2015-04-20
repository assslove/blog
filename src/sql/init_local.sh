#!/bin/bash
cd ~/xxmn/
git pull origin master
cd -
cp ~/xxmn/src/sql/blog.sql
./create_db.sh

