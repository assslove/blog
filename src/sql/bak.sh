# 备份远程

ssh 5532215afcf933acf700000f@xxmn-limai.rhcloud.com 'mysqldump -h127.5.31.130 -P3306 -uadminkt2Nj93 -ptkV8Rpma-M1G blog > blog.sql'
echo "back blog";
# 备份图片为库
ssh 5532215afcf933acf700000f@xxmn-limai.rhcloud.com 'tar -zcvf upload.tar.gz ./../../img/upload/'
echo "back img";

