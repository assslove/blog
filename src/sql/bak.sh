# 备份mysql 全库
mysqldump -uroot -p8459328 blog > blog.sql

# 备份图片为库
tar -zcvf upload.tar.gz ./../../img/upload/
