#!/bin/bash
#备份远程
mysqldump -h127.5.31.130 -P3306 -uadminkt2Nj93 -ptkV8Rpma-M1G blog > blog.sql
echo "back blog";
# 备份图片为库
cd /var/lib/openshift/5532215afcf933acf700000f/app-root/repo/img/upload && tar -zcvf upload.tar.gz ./*
mv upload.tar.gz /var/lib/openshift/5532215afcf933acf700000f/app-root/repo/src/sql
echo "back img";
