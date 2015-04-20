# 备份远程
# 备份mysql 全库
ssh 5532215afcf933acf700000f@xxmn-limai.rhcloud.com 'mysqldump -uadminkt2Nj93 -ptkV8Rpma-M1G blog > blog.sql'

# 备份图片为库
ssh 5532215afcf933acf700000f@xxmn-limai.rhcloud.com 'tar -zcvf upload.tar.gz ./../../img/upload/'

