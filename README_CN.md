if hostname is localhost.localdomain, need modify it

```
hostnamectl set-hostname postgres-server
```

设置免密登录

```
ssh-keygen
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

安装依赖

```
sudo ./README.ubuntu.bash
```

调整内核参数

```bash

sudo bash -c 'cat >> /etc/sysctl.conf <<-EOF
kernel.shmmax = 500000000
kernel.shmmni = 4096
kernel.shmall = 4000000000
kernel.sem = 500 1024000 200 4096
kernel.sysrq = 1
kernel.core_uses_pid = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.msgmni = 2048
net.ipv4.tcp_syncookies = 1
net.ipv4.ip_forward = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_max_syn_backlog = 4096
net.ipv4.conf.all.arp_filter = 1
net.ipv4.ip_local_port_range = 1025 65535
net.core.netdev_max_backlog = 10000
net.core.rmem_max = 2097152
net.core.wmem_max = 2097152
vm.overcommit_memory = 2
EOF'

sudo bash -c 'cat >> /etc/security/limits.conf <<-EOF
* soft nofile 65536
* hard nofile 65536
* soft nproc 131072
* hard nproc 131072
EOF'

sudo bash -c 'cat >> /etc/ld.so.conf <<-EOF
/usr/local/lib
EOF'

```

修改内核参数需要重启系统


GPORCA没有安装成功， 所以不能启用orca

编译 Greenplum Database ， 安装目录为/opt/gpdb/gpdb6

```
sudo mkdir /opt/gpdb
# sudo chown postgres:postgres /opt/gpdb

CFLAGS="-O0 -g3 -ggdb3" ./configure --with-perl --with-python --with-libxml --enable-debug --enable-cassert --disable-gpcloud --disable-orca --prefix=/opt/gpdb/gpdb6
make
make install

```

```
# Bring in greenplum environment into your running shell
source /opt/gpdb/gpdb6/greenplum_path.sh

export MASTER_MAX_CONNECT=50
export BATCH_DEFAULT=4
export WITH_MIRRORS=false

# Start demo cluster
make create-demo-cluster
# (gpdemo-env.sh contains __PGPORT__ and __MASTER_DATA_DIRECTORY__ values)
source gpAux/gpdemo/gpdemo-env.sh

$ psql postgres # 或者 psql -p 15432 -d postgres

postgres# SELECT version();
postgres# SELECT pg_backend_pid();
postgres# \q

gpstop

```

调试

打开Clion, 打开greenplum-gpdb工程, 菜单"run->attach to process", 选择刚才`SELECT pg_backend_pid();`语句输出的进程号
然后会看到`Debugger attached to process 进程号`, 表示成功了, 然后就可以打断点,调试了。

如果提示ptrac不允许操作, 用root用户执行以下命令
```
echo 0 >/proc/sys/kernel/yama/ptrace_scope
```





# greenplum-gpdb

## 目录结构

### 根目录

```
# git related

.git                             
.gitattributes                   
.github                          
.gitignore                       
.gitmodules                      # 目前有3个子模块, 分别是pgbouncer, pythonsrc-ext, googletest

PULL_REQUEST_TEMPLATE.md         

# documents

README.md                        
README.git                       
README.PostgreSQL                # 原版PostgreSQL的README文件

logo-greenplum.png               
COPYRIGHT                        
HISTORY                          
LICENSE                          
NOTICE                           

doc                              
gpdb-doc                         


# compile related

README.linux.md                  
README.macOS.md                  
README.windows.md                
README.docker.md                 
README.conda.md                  

README.CentOS.bash               
README.ubuntu.bash               
README.macOS.bash                
README.amazon_linux              

python-dependencies.txt          
python-developer-dependencies.txt

depends                          

getversion                       # Shell脚本, 从git仓库里提取当前版本信息
putversion                       # ???

# compile related

aclocal.m4                       
configure                        
configure.in                     
Makefile                         
GNUmakefile.in                   

# source code

src                              # 修改过的PostgreSQL源代码

contrib                          # 原版PostgreSQL的第三方贡献的代码
gpAux                            # ???
gpcontrib                        # Greenplum的第三方贡献的代码
gpMgmt                           # Greenplum集群管理相关的代码

concourse                        # 存放了很多shell脚本
config                           
hooks                            

# others

.travis.yml                      
.dir-locals.el                   


```

### gpAux

```

gpAux
  client      # greenplum的客户端程序, 包含windows和linux的, 暂时不知道这个客户端能干啥...
  extensions  # This directory contains various server extensions and tools, for use with the Greenplum server. 
    pgbouncer # 一个轻量级的连接池
  gpdemo      # The GP demo program will setup a virtual Greenplum Database system on a single host.
  gpperfmon   # 包含创建gpperfmon数据库的脚本和C库, 不包含GPCC的agent和web
  platform
  releng

```

### ppgbouncer

[让pgbounser可以直连segment](http://blogosdba.net/69.html)





PostgreSQL源代码包含3400多个文件，主要程序由C语言编写，包括十几个大型模块，定义了几百个主要的数据结构和上万个函数。







