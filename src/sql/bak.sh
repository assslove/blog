#!/bin/bash 
#备份远程
mysqldump -h127.5.31.130 -P3306 -uadminkt2Nj93 -ptkV8Rpma-M1G blog > blog.sql
echo "back blog";
# 备份图片为库
tar -zcv upload.tar.gz ./../../img/upload/*
echo "back img";

