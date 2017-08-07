#!/bin/bash
########################     蜗牛汉化     #################################
########################  www.wn789.com   #################################


if [ $(id -u) != "0" ]; then
echo 'ERROR! Please su root and try again!
'
exit 0
fi


os=$(cut -f 1 -d ' ' /etc/redhat-release)
release=$(grep -o "[0-9]" /etc/redhat-release |head -n1)
arch=`arch`
random=`cat /dev/urandom | tr -cd 'A-Z0-9' | head -c 5`
password=`cat /dev/urandom | tr -cd 'A-Z0-9' | head -c 10`
IP=`curl -s -L http://cpanel.net/showip.cgi`
if [ ! -f /etc/redhat-release ] || [ "$os" != "CentOS" ] || [ "$release" != "7" ]; then
echo '错误!请使用CentOS 7 x86_64系统!
'
exit 0
fi

clear
############################################################
echo '	欢迎使用VDVESTA:
一键自动为CentOS 7 x86_64系统安装VESTACP.由蜗牛789—www.wn789.com汉化修改！
								谢谢你的使用!
'

vDDoS_yn=''; File_Manager_yn=''; Zend_opcode_yn=''; Memcached_yn=''; Limit_Hosting_yn='';
Kernel_limit_DDOS_yn=''; change_port_yn=''; Web_Server_version=''; PHP_Server_version='';
auto_config_PHP_yn=''; MariaDB_Server_version=''; Spamassassin_Clamav_yn=''; fail2ban_yn='';


echo -n '选择要安装的Web Server版本 [apache|nginx]: '
read Web_Server_version
if [ "$Web_Server_version" != "apache" ] && [ "$Web_Server_version" != "nginx" ]; then
Web_Server_version=apache
fi
echo '选择要安装的PHP Server版本 => '$Web_Server_version''

echo -n 'Which PHP Server version you want to install [5.4|5.5|5.6|7.0|7.1]: '
read PHP_Server_version
if [ "$PHP_Server_version" != "5.4" ] && [ "$PHP_Server_version" != "5.5" ] && [ "$PHP_Server_version" != "5.6" ] && [ "$PHP_Server_version" != "7.0" ] && [ "$PHP_Server_version" != "7.1" ]; then
PHP_Server_version=7.1
fi
echo '你选择安装的PHP Server版本为 => '$PHP_Server_version''

echo -n '是否要自动配置PHP [Y|n]: '
read auto_config_PHP_yn
if [ "$auto_config_PHP_yn" != "y" ] && [ "$auto_config_PHP_yn" != "n" ]; then
auto_config_PHP_yn=y
fi
echo '自动配置PHP => '$auto_config_PHP_yn''

echo -n '选择要安装的MariaDB Server版本 [5.5|10.0|10.1]: '
read MariaDB_Server_version
if [ "$MariaDB_Server_version" != "5.5" ] && [ "$MariaDB_Server_version" != "10.0" ] && [ "$MariaDB_Server_version" != "10.1" ]; then
MariaDB_Server_version=10.1
fi
echo '你选择安装的MariaDB Server版本为 => '$MariaDB_Server_version''

echo -n '是否要安装文件管理器 [Y|n]: '
read File_Manager_yn
if [ "$File_Manager_yn" != "y" ] && [ "$File_Manager_yn" != "n" ]; then
File_Manager_yn=y
fi
echo '安装文件管理器 => '$File_Manager_yn''

echo -n 'W是否选择安装Zend优化加操作码缓存 [Y|n]: '
read Zend_opcode_yn
if [ "$Zend_opcode_yn" != "y" ] && [ "$Zend_opcode_yn" != "n" ]; then
Zend_opcode_yn=y
fi
echo '安装Zend => '$Zend_opcode_yn''


echo -n '是否选择安装安装Memcached [Y|n]: '
read Memcached_yn
if [ "$Memcached_yn" != "y" ] && [ "$Memcached_yn" != "n" ]; then
Memcached_yn=y
fi
echo '安装Memcached => '$Memcached_yn''

echo -n '是否选择安装限制主机（限制CPU，RAM，IO您的主机帐户） [Y|n]: '
read Limit_Hosting_yn
if [ "$Limit_Hosting_yn" != "y" ] && [ "$Limit_Hosting_yn" != "n" ]; then
Limit_Hosting_yn=y
fi
echo '安装限制主机 => '$Limit_Hosting_yn''

echo -n '是否将VestaCP 8083端口更改为2083 [Y|n]: '
read change_port_yn
if [ "$change_port_yn" != "y" ] && [ "$change_port_yn" != "n" ]; then
change_port_yn=y
fi
echo 'VestaCP 8083端口更改为2083 => '$change_port_yn''



echo -n '是否选择安装Spamassassin & Clamav [y|N]: '
read Spamassassin_Clamav_yn
if [ "$Spamassassin_Clamav_yn" != "y" ] && [ "$Spamassassin_Clamav_yn" != "Y" ]; then
Spamassassin_Clamav_yn=n
fi
echo '安装Spamassassin & Clamav => '$Spamassassin_Clamav_yn''

echo -n 'W是否选择安装Fail2ban [y|N]: '
read fail2ban_yn
if [ "$fail2ban_yn" != "y" ] && [ "$fail2ban_yn" != "Y" ]; then
fail2ban_yn=n
fi
echo '安装Fail2ban => '$fail2ban_yn''

hostname_set="vdvesta.`hostname -f`.local"
echo -n '输入你的主机名，请按回车键  ['$hostname_set']: '
read hostname_i
if [ "$hostname_i" = "" ]; then
hostname_i=$hostname_set
fi
echo '你的主机名 => '$hostname_i''

echo -n '输入你的邮箱，请按回车键 [admin@'$hostname_i']: '
read email_i
if [ "$email_i" = "" ]; then
email_i='admin@'$hostname_i''
fi
echo 'E你的邮箱 => '$email_i''

yum -y install nano screen wget curl zip unzip net-tools >/dev/null 2>&1
yum -y remove httpd* php* mysql* >/dev/null 2>&1
#############################################################






if [ "$PHP_Server_version" != "" ]; then
PHP_Server_version=`echo $PHP_Server_version |tr -d .`
fi

Remi_yn='--remi yes'
if [ "$PHP_Server_version" = "54" ]; then
Remi_yn='--remi no'
MariaDB_Server_version='5.5'
fi


if [ "$MariaDB_Server_version" = "5.5" ]; then
MariaDB_Server_version='5.5'
fi

if [ "$MariaDB_Server_version" = "10.0" ]; then
MariaDB_Server_version='10.1'
fi

if [ "$MariaDB_Server_version" = "10.1" ]; then
echo '# MariaDB 10.1 CentOS repository list - created 2017-02-20 12:34 UTC
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1' > /etc/yum.repos.d/MariaDB.repo
fi



############################################################

curl -L https://raw.githubusercontent.com/wn789/VDVESTA/master/vst-install.sh -o vst-install.sh
chmod 700 vst-install.sh


if [ "$Web_Server_version" = "apache" ]; then
Web_Server_version='--nginx no --apache yes --phpfpm no'
fi
if [ "$Web_Server_version" = "nginx" ]; then
Web_Server_version='--nginx yes --apache no --phpfpm yes'
fi
if [ "$Spamassassin_Clamav_yn" = "y" ]; then
Spamassassin_Clamav_yn='--spamassassin yes --clamav yes'
fi
if [ "$Spamassassin_Clamav_yn" = "n" ]; then
Spamassassin_Clamav_yn='--spamassassin no --clamav no'
fi
if [ "$fail2ban_yn" = "y" ]; then
fail2ban_yn='--fail2ban yes'
fi
if [ "$fail2ban_yn" = "n" ]; then
fail2ban_yn='--fail2ban no'
fi

sed -i "s#%PHP_Server_version%#$PHP_Server_version#g" vst-install.sh
sed -i "s#%MariaDB_Server_version%#$MariaDB_Server_version#g" vst-install.sh

bash vst-install.sh --force --interactive yes $Web_Server_version --vsftpd yes --proftpd no --exim yes --dovecot yes $Spamassassin_Clamav_yn --named yes --iptables yes $fail2ban_yn --mysql yes --postgresql no $Remi_yn --quota yes --hostname $hostname_i --email $email_i --password $password







if [ "$Zend_opcode_yn" = "y" ]; then
yum -y --enablerepo=remi,remi-php$PHP_Server_version install  php-opcache

fi

if [ "$Memcached_yn" = "y" ]; then
yum -y --enablerepo=remi,remi-php$PHP_Server_version install php-pecl-memcached php-pecl-memcache memcached php-memcached
service memcached start
chkconfig memcached on
fi

if [ "$Limit_Hosting_yn" = "y" ]; then
yum -y install libcgroup
yum -y install libcgroup-pam
echo "session         optional        pam_cgroup.so" >> /etc/pam.d/su
fi

if [ "$Kernel_limit_DDOS_yn" = "y" ]; then
cp /etc/sysctl.conf /etc/sysctl.conf.bak.$random
echo 'kernel.printk = 4 4 1 7
kernel.panic = 10
kernel.sysrq = 0
kernel.shmmax = 4294967296
kernel.shmall = 4194304
kernel.core_uses_pid = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
vm.swappiness = 20
vm.dirty_ratio = 80
vm.dirty_background_ratio = 5
fs.file-max = 2097152
net.core.netdev_max_backlog = 262144
net.core.rmem_default = 31457280
net.core.rmem_max = 67108864
net.core.wmem_default = 31457280
net.core.wmem_max = 67108864
net.core.somaxconn = 65535
net.core.optmem_max = 25165824
net.ipv4.neigh.default.gc_thresh1 = 4096
net.ipv4.neigh.default.gc_thresh2 = 8192
net.ipv4.neigh.default.gc_thresh3 = 16384
net.ipv4.neigh.default.gc_interval = 5
net.ipv4.neigh.default.gc_stale_time = 120
net.netfilter.nf_conntrack_max = 10000000
net.netfilter.nf_conntrack_tcp_loose = 0
net.netfilter.nf_conntrack_tcp_timeout_established = 1800
net.netfilter.nf_conntrack_tcp_timeout_close = 10
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 10
net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 20
net.netfilter.nf_conntrack_tcp_timeout_last_ack = 20
net.netfilter.nf_conntrack_tcp_timeout_syn_recv = 20
net.netfilter.nf_conntrack_tcp_timeout_syn_sent = 20
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 10
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.ip_no_pmtu_disc = 1
net.ipv4.route.flush = 1
net.ipv4.route.max_size = 8048576
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.tcp_congestion_control = htcp
net.ipv4.tcp_mem = 65536 131072 262144
net.ipv4.udp_mem = 65536 131072 262144
net.ipv4.tcp_rmem = 4096 87380 33554432
net.ipv4.udp_rmem_min = 16384
net.ipv4.tcp_wmem = 4096 87380 33554432
net.ipv4.udp_wmem_min = 16384
net.ipv4.tcp_max_tw_buckets = 1440000
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_max_orphans = 400000
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rfc1337 = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_sack = 1
net.ipv4.tcp_fack = 1
net.ipv4.tcp_ecn = 2
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_intvl = 60
net.ipv4.tcp_keepalive_probes = 10
net.ipv4.tcp_no_metrics_save = 1
net.ipv4.ip_forward = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.all.rp_filter = 1
net.ipv4.ip_nonlocal_bind = 1' >> /etc/sysctl.conf

touch /etc/security/limits.d/nofile.conf
echo '*    soft    nofile 65535'> /etc/security/limits.d/nofile.conf
echo '*    hard    nofile 65535' >> /etc/security/limits.d/nofile.conf

sysctl -p



fi


if [ "$change_port_yn" = "y" ]; then
cp /usr/local/vesta/nginx/conf/nginx.conf /usr/local/vesta/nginx/conf/nginx.conf.bak.$random
cp /usr/local/vesta/data/firewall/rules.conf /usr/local/vesta/data/firewall/rules.conf.bak.$random
sed -i '/8083;/a listen 2083;' /usr/local/vesta/nginx/conf/nginx.conf
service vesta restart
sed -i "s#8083#8083,2083#g" /usr/local/vesta/data/firewall/rules.conf
/usr/local/vesta/bin/v-update-firewall
fi

if [ "$auto_config_PHP_yn" = "y" ]; then
cp /etc/php.ini /etc/php.ini.bak.$random
sed -i "/^short_open_tag/c short_open_tag = On" /etc/php.ini
sed -i '/^;default_charset/c default_charset = "UTF-8"' /etc/php.ini
sed -i "/^post_max_size/c post_max_size = 500M" /etc/php.ini
sed -i "/^upload_max_filesize/c upload_max_filesize = 500M" /etc/php.ini
sed -i "/^memory_limit/c memory_limit = 500M" /etc/php.ini
sed -i "/^max_execution_time/c max_execution_time = 5000" /etc/php.ini
fi

if [ "$vDDoS_yn" = "y" ]; then
s='80' ; r='8080'
sed -i "s#$s#$r#g" /usr/local/vesta/conf/vesta.conf
s='443' ; r='8443'
sed -i "s#$s#$r#g" /usr/local/vesta/conf/vesta.conf

s=':8081' ; r=':8888'
sed -i "s#$s#$r#g" /etc/httpd/conf.d/*.conf >/dev/null 2>&1
s=':80' ; r=':8080'
sed -i "s#$s#$r#g" /etc/httpd/conf.d/*.conf >/dev/null 2>&1
s=':443' ; r=':8443'
sed -i "s#$s#$r#g" /etc/httpd/conf.d/*.conf >/dev/null 2>&1
s=':8888' ; r=':8081'
sed -i "s#$s#$r#g" /etc/httpd/conf.d/*.conf >/dev/null 2>&1

s=':8084' ; r=':8888'
sed -i "s#$s#$r#g" /etc/nginx/conf.d/*.conf >/dev/null 2>&1
s=':80' ; r=':8080'
sed -i "s#$s#$r#g" /etc/nginx/conf.d/*.conf >/dev/null 2>&1
s=':443' ; r=':8443'
sed -i "s#$s#$r#g" /etc/nginx/conf.d/*.conf >/dev/null 2>&1
s=':8888' ; r=':8084'
sed -i "s#$s#$r#g" /etc/nginx/conf.d/*.conf >/dev/null 2>&1

service vesta restart

VESTA='/usr/local/vesta/'
source /etc/profile.d/vesta.sh >/dev/null 2>&1
source /root/.bash_profile >/dev/null 2>&1
source /etc/sysconfig/clock >/dev/null 2>&1
source /usr/local/vesta/func/main.sh >/dev/null 2>&1
source /usr/local/vesta/conf/vesta.conf >/dev/null 2>&1
/usr/local/vesta/bin/v-rebuild-web-domains admin
fi

if [ "$File_Manager_yn" = "y" ]; then
curl -L https://github.com/duy13/VDVESTA/raw/master/File-Manager -o File-Manager
chmod 700 File-Manager
./File-Manager
rm -f File-Manager
cp /usr/local/vesta/web/css/styles.min.css /usr/local/vesta/web/css/styles.min.css.bak.$random
s='background-position: -117px -7px;'
r='background-position: -117px -55px;'
sed -i "s#$s#$r#g"  /usr/local/vesta/web/css/styles.min.css
s='5d5d5d;' 
r='DF0022;'
sed -i "s#$s#$r#g" /usr/local/vesta/web/css/styles.min.css

VESTA='/usr/local/vesta/'
source /etc/profile.d/vesta.sh >/dev/null 2>&1
source /root/.bash_profile >/dev/null 2>&1
source /etc/sysconfig/clock >/dev/null 2>&1
source /usr/local/vesta/func/main.sh >/dev/null 2>&1
source /usr/local/vesta/conf/vesta.conf >/dev/null 2>&1

/usr/local/vesta/bin/v-delete-cron-job admin 8 >/dev/null 2>&1

/usr/local/vesta/bin/v-delete-user-package gainsboro >/dev/null 2>&1
/usr/local/vesta/bin/v-delete-user-package palegreen >/dev/null 2>&1 >/dev/null 2>&1
/usr/local/vesta/bin/v-delete-user-package slategrey >/dev/null 2>&1

echo "WEB_TEMPLATE='default'
BACKEND_TEMPLATE='default'
PROXY_TEMPLATE='default'
DNS_TEMPLATE='default'
WEB_DOMAINS='unlimited'
WEB_ALIASES='unlimited'
DNS_DOMAINS='unlimited'
DNS_RECORDS='unlimited'
MAIL_DOMAINS='unlimited'
MAIL_ACCOUNTS='unlimited'
DATABASES='unlimited'
CRON_JOBS='unlimited'
DISK_QUOTA='1000'
BANDWIDTH='unlimited'
NS='ns1.localhost.ltd,ns2.localhost.ltd'
SHELL='nologin'
BACKUPS='1'
TIME='11:46:50'
DATE='2015-06-05'" > 1GB.pkg
echo "WEB_TEMPLATE='default'
BACKEND_TEMPLATE='default'
PROXY_TEMPLATE='default'
DNS_TEMPLATE='default'
WEB_DOMAINS='unlimited'
WEB_ALIASES='unlimited'
DNS_DOMAINS='unlimited'
DNS_RECORDS='unlimited'
MAIL_DOMAINS='unlimited'
MAIL_ACCOUNTS='unlimited'
DATABASES='unlimited'
CRON_JOBS='unlimited'
DISK_QUOTA='2000'
BANDWIDTH='unlimited'
NS='ns1.localhost.ltd,ns2.localhost.ltd'
SHELL='nologin'
BACKUPS='1'
TIME='11:46:50'
DATE='2015-06-05'" > 2GB.pkg
echo "WEB_TEMPLATE='default'
BACKEND_TEMPLATE='default'
PROXY_TEMPLATE='default'
DNS_TEMPLATE='default'
WEB_DOMAINS='unlimited'
WEB_ALIASES='unlimited'
DNS_DOMAINS='unlimited'
DNS_RECORDS='unlimited'
MAIL_DOMAINS='unlimited'
MAIL_ACCOUNTS='unlimited'
DATABASES='unlimited'
CRON_JOBS='unlimited'
DISK_QUOTA='3000'
BANDWIDTH='unlimited'
NS='ns1.localhost.ltd,ns2.localhost.ltd'
SHELL='nologin'
BACKUPS='1'
TIME='11:46:50'
DATE='2015-06-05'" > 3GB.pkg
echo "WEB_TEMPLATE='default'
BACKEND_TEMPLATE='default'
PROXY_TEMPLATE='default'
DNS_TEMPLATE='default'
WEB_DOMAINS='unlimited'
WEB_ALIASES='unlimited'
DNS_DOMAINS='unlimited'
DNS_RECORDS='unlimited'
MAIL_DOMAINS='unlimited'
MAIL_ACCOUNTS='unlimited'
DATABASES='unlimited'
CRON_JOBS='unlimited'
DISK_QUOTA='5000'
BANDWIDTH='unlimited'
NS='ns1.localhost.ltd,ns2.localhost.ltd'
SHELL='nologin'
BACKUPS='1'
TIME='11:46:50'
DATE='2015-06-05'" > 5GB.pkg
echo "WEB_TEMPLATE='default'
BACKEND_TEMPLATE='default'
PROXY_TEMPLATE='default'
DNS_TEMPLATE='default'
WEB_DOMAINS='unlimited'
WEB_ALIASES='unlimited'
DNS_DOMAINS='unlimited'
DNS_RECORDS='unlimited'
MAIL_DOMAINS='unlimited'
MAIL_ACCOUNTS='unlimited'
DATABASES='unlimited'
CRON_JOBS='unlimited'
DISK_QUOTA='10000'
BANDWIDTH='unlimited'
NS='ns1.localhost.ltd,ns2.localhost.ltd'
SHELL='nologin'
BACKUPS='1'
TIME='11:46:50'
DATE='2015-06-05'" > 10GB.pkg
echo "WEB_TEMPLATE='default'
BACKEND_TEMPLATE='default'
PROXY_TEMPLATE='default'
DNS_TEMPLATE='default'
WEB_DOMAINS='unlimited'
WEB_ALIASES='unlimited'
DNS_DOMAINS='unlimited'
DNS_RECORDS='unlimited'
MAIL_DOMAINS='unlimited'
MAIL_ACCOUNTS='unlimited'
DATABASES='unlimited'
CRON_JOBS='unlimited'
DISK_QUOTA='50000'
BANDWIDTH='unlimited'
NS='ns1.localhost.ltd,ns2.localhost.ltd'
SHELL='nologin'
BACKUPS='1'
TIME='11:46:50'
DATE='2015-06-05'" > 50GB.pkg





/usr/local/vesta/bin/v-add-user-package `pwd` 1GB >/dev/null 2>&1
/usr/local/vesta/bin/v-add-user-package `pwd` 2GB >/dev/null 2>&1
/usr/local/vesta/bin/v-add-user-package `pwd` 3GB >/dev/null 2>&1
/usr/local/vesta/bin/v-add-user-package `pwd` 5GB >/dev/null 2>&1
/usr/local/vesta/bin/v-add-user-package `pwd` 10GB >/dev/null 2>&1
/usr/local/vesta/bin/v-add-user-package `pwd` 50GB >/dev/null 2>&1
rm -rf *.pkg

fi

if [ ! -f /etc/rc.d/init.d/vesta ]; then
	echo 'Install VESTACP Fail!';
	exit 0
fi


if [ "$vDDoS_yn" = "y" ]; then

curl -L https://github.com/duy13/vDDoS-Protection/raw/master/vddos-1.13.3-centos7 -o /usr/bin/vddos
chmod 700 /usr/bin/vddos
/usr/bin/vddos setup
/usr/bin/vddos autostart
echo 'default http://0.0.0.0:80    http://'$IP':8080    no    no    no           no
default https://0.0.0.0:443  https://'$IP':8443  no    no    /vddos/ssl/your-domain.com.pri /vddos/ssl/your-domain.com.crt' >> /vddos/conf.d/website.conf
fi




/usr/bin/vddos restart >/dev/null 2>&1
service mariadb restart >/dev/null 2>&1
service memcached restart >/dev/null 2>&1
service vesta restart >/dev/null 2>&1
clear

if [ "$Web_Server_version" = "--nginx no --apache yes --phpfpm no" ]; then
chkconfig nginx off >/dev/null 2>&1
service httpd restart >/dev/null 2>&1
httpd -v
fi
if [ "$Web_Server_version" = "--nginx yes --apache no --phpfpm yes" ]; then
echo '[%backend%]
listen = /var/run/php5-%backend%.sock
listen.allowed_clients = 127.0.0.1
user = %user%
group = %user%
listen.owner = %user%
listen.group = nginx
pm = ondemand
pm.max_children = 50
pm.start_servers = 3
pm.min_spare_servers = 2
pm.max_spare_servers = 10
pm.process_idle_timeout = 10s
pm.max_requests = 500
env[HOSTNAME] = $HOSTNAME
env[PATH] = /usr/local/bin:/usr/bin:/bin
env[TMP] = /tmp
env[TMPDIR] = /tmp
env[TEMP] = /tmp' > /usr/local/vesta/data/templates/web/php-fpm/VDVESTA-Socket.tpl
chkconfig httpd off >/dev/null 2>&1
service nginx restart >/dev/null 2>&1
nginx -v
fi


mysql -V
php -v

echo '
=====> 安装和配置vdvesta完成! <=====
你的VestaCP地址: https://'$IP':2083 or https://'$IP':8083
	控制面板用户名: admin
	控制面板密码: '$password'

  请重新启动服务器!
'
