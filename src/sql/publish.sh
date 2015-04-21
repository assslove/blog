#!/bin/bash
#一键发布功能

# 备份mysql 全库
ssh 5532215afcf933acf700000f@xxmn-limai.rhcloud.com 'cd app-root/repo/src/sql && sh ./bak.sh'
#echo "remote back sql & img";

#拷贝到本地
scp 5532215afcf933acf700000f@xxmn-limai.rhcloud.com:~/app-root/repo/src/sql/blog.sql .
scp 5532215afcf933acf700000f@xxmn-limai.rhcloud.com:~/app-root/repo/src/sql/upload.tar.gz .
#echo "cpy to local";

#拷贝到工作目录 并解压照片
cp upload.tar.gz /var/www/html/blog/img/upload/ && cd /var/www/html/blog/img/upload/ && tar -zxvf upload.tar.gz && rm -f upload.tar.gz && chmod 644 *
#照片加入本地库中
cd /var/www/html/blog/img/upload && git add *
git commit -a -m "统一提交"
git push origin master
#echo "push to github";
#初始化本地库
cd /var/www/html/blog/src/sql && ./create_db.sh
#拷贝所有程序到远程
cd /var/www/html/blog/ && cp -r * ~/xxmn
cd ~/xxmn/src
sh ./init.sh
cd ../
git add *
git commit -a -m "统一提交"
git push origin master
echo "publish successful";


