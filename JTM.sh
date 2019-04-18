#!/bin/sh
#查询java相关的自带服务
echo "-------------------------------------------------------------------"
echo -e "\e[31;40m 欢迎使用虚拟器一键配置脚本，作者：孙德祥 \e[0m";
echo -e "\e[31;40m 此脚本用于云时代学生学习专用脚本，盗版必究 \e[0m";
echo -e "\e[31;40m 请输入数字选择您是否要运行此脚本 \e[0m";
echo -e "\e[31;40m 确定运行后请去抽根烟，2分钟后回来就完成啦！ \e[0m";
echo -e "\e[31;40m 确定运行请输入：1  退出请输入： 2 \e[0m";
read -p "请选择是否运行：" number   #提示用户输入数字
if [ -z $number ];then                         #判断用户是否输入，如果未输入则打印error
   echo "输入错误！"
   exit
else
   jieguo=`echo "$number" | bc `    #把用户的输入值交给bc做运算
   if [ $jieguo -eq 1 ];then                  
      echo "一键配置开始运行！"
	  #脚本真正开始运行
	 
	   echo "首先开启端口！"
	 /sbin/iptables -I INPUT -p tcp --dport 3306 -j ACCEPT
	 /etc/rc.d/init.d/iptables save
	 /sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
	 /etc/rc.d/init.d/iptables save
	  
		echo "正在删除java开发包以及mysql开发包请不要操作键盘！"
		#这个也是一种删除开发包的实现方式
		#service_package=(java mysq)
		#rpm -qa ${service_package[@]} | xargs rpm -e --nodeps

	  rpm -qa| grep java | xargs rpm -e --nodeps
	 rpm -qa| grep mysql | xargs rpm -e --nodeps
	 
	 #执行 yun 依赖
	  echo "正在安装依赖！"
	 yum -y install glibc*
	 
	 #创建文件夹
	  echo "开始创建文件夹！"
	 mkdir -p /xuniji/{mysql,jdk,tomcat}


	 #开始解压文件第一个 jdk
	  echo "开始解压文件第一个 jdk！"
	 tar -xvf /xuniji/jdk-7u72-linux-i586.gz -C /xuniji/jdk
	  #开始解压文件第二个 mysql
	   echo "开始解压文件第二个 mysql！"
	 tar -xvf /xuniji/MySQL-5.5.49-1.linux2.6.i386.rpm-bundle.tar -C /xuniji/mysql
	  #开始解压文件第三个 tomcat
	   echo "开始解压文件第三个 tomcat！"
	 tar -xvf /xuniji/apache-tomcat-7.0.52.tar.gz -C /xuniji/tomcat
	   echo "jdk mysql tomcat 解压完成！"
	  
	   echo "开始重写环境变量配置文件！"
cat >> /etc/profile << EOF

#set java environment
JAVA_HOME=/xuniji/jdk/jdk1.7.0_72
CLASSPATH=.:$JAVA_HOME/lib.tools.jar
PATH=$JAVA_HOME/bin:$PATH
export JAVA_HOME CLASSPATH PATH 

EOF
	
	#重新加载环境变量配置文件
	source /etc/profile
	   echo "重写环境变量配置文件完成！"
	  
	  
	rpm -ivh /xuniji/mysql/MySQL-server-5.5.49-1.linux2.6.i386.rpm
	
	rpm -ivh /xuniji/mysql/MySQL-client-5.5.49-1.linux2.6.i386.rpm
	   echo "mysql安装完成！"
	   
	service mysql start
	service mysql status
	
	 echo "启动mysq服务！"
	 
	  echo "加入到系统服务！"
	 chkconfig --add mysql
	  echo "自动启动"
	 chkconfig mysql on
	 cd /xuniji/tomcat/apache-tomcat-7.0.52/bin
	  bash startup.sh
	 echo "启动tomcat服务！"
	 echo -e "\e[31;40m ---------------------------------------------------------------------  \e[0m";
	 echo -e "\e[31;40m 脚本运行完成，tomcat已经可以访问，8080与3306端口已经打开 2 \e[0m";
	 echo -e "\e[31;40m 请用户自动登陆mysql进行修改密码并开启远程服务，只需一行一行赋值粘贴即可， 2 \e[0m";
	 echo -e "\e[31;40m 使用代码： mysql -u root -p  进行登陆，不用输入密码，直接回车进入  \e[0m";
	 echo -e "\e[31;40m 登陆成功后输入:  set password = password('admin');   修改密码  \e[0m";
	 echo -e "\e[31;40m 开启远程服务第一句： grant all privileges on *.* to 'root' @'%' identified by 'admin';  \e[0m";
	 echo -e "\e[31;40m 开启远程服务第二句： flush privileges;  \e[0m";
	 echo -e "\e[31;40m 退出mysql的简单命令：  \q   \e[0m"; 
	 echo -e "\e[31;40m ------------------------------by：孙德祥----------------------------------  \e[0m";
	 
	  
      exit
else
	if [ $jieguo -eq 2 ];then                  
      echo "脚本已经成功退出！"
      exit
  
    fi
   fi

   

   

fi
