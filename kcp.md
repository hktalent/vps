# kcptun使用分享
https://github.com/xtaci/kcptun/issues/646
## 1、编译kcptun，这一步需要在翻墙的状态下完成
```
go get -v -u github.com/xtaci/kcptun/...
cd ~/go/src/github.com/xtaci/kcptun
./build-release.sh
```
## 2、将编译好的文件拷贝到远程的服务器上
```
scp  -C -r -P 449 /tools/kcptun/server_linux_amd64 root@191.124.10.101:/root
```

## 3、vps上运行
```
ulimit -n 65535
echo ulimit -n 65535 >>~/.bashrc
apt install python
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
pip install shadowsocks --upgrade 
# see:https://github.com/shadowsocks/shadowsocks/tree/master
pip install -U git+https://github.com/shadowsocks/shadowsocks.git@master
ln -sf /lib/x86_64-linux-gnu/libcrypto.so.1.0.0 /usr/local/lib/libcrypto.so.1.1

tmux
nohup /usr/bin/python /usr/local/bin/ssserver --workers 5 -s 127.0.0.1 -p 443 -k xxxxxxxxx -m aes-256-cfb &
./server_linux_amd64 -t "127.0.0.1:443" -l ":110" -mode fast3 -nocomp -sockbuf 16777217 -dscp 46

./server_linux_amd64 -t "127.0.0.1:443" -l ":110" -mode fast2 -nocomp -dscp 46 -mtu 1350 -crypt salsa20 -sndwnd 204 -rcvwnd 1024
```
## 4、你的机器上运行,win时（client_windows_amd64.exe）
```
./client_darwin_amd64 -r "191.124.210.101:110" -l ":1099" -mode fast3 -nocomp -autoexpire 300 -sockbuf 16777217 -dscp 46

./client_darwin_amd64 -r "191.124.210.101:110" -l ":1099" -mode fast2 -nocomp -autoexpire 300 -dscp 46 -mtu 1350 -crypt salsa20 -sndwnd 204 -rcvwnd 1024
```
## 5、运行ss客户端，连接本机127.0.0.1的1099
```
并使用你的密码xxxxxxxxx和加密：aes-256-cfb，
这时的127.0.0.1:1099等同远程服务器上的443
```
more see: [51pwn](https://51pwn.com)

只能说，太快了，用了一个月，流量超限185G
只能迁移到docker
```
1、环境准备
docker pull alpine:latest  
docker run -it  -v /tmp/.X11-unix:/tmp/.X11-unix --privileged --net=host -v /root/kcp:/kcp  -P --name=kcp cdf98d1859c1 /bin/sh

(ps:cdf98d1859c1 是docker images|grep alpine看到的那个哈)
2、进入docker后
echo "ulimit -n 65535">>~/.bashrc 
source ~/.bashrc
cat <<EOT>>/etc/sysctl.conf
net.core.rmem_max=26214400 // BDP - bandwidth delay product
net.core.rmem_default=26214400
net.core.wmem_max=26214400
net.core.wmem_default=26214400
net.core.netdev_max_backlog=2048 // proportional to -rcvwnd
EOT
3、如果你已经退出了docker重新进入

docker start 92507b990a7c
docker exec -it  92507b990a7c /bin/sh
（ps： 92507b990a7c 是
docker ps -a|grep kcp
看到的）
# 进入docker后
cd /kcp/;./server_linux_amd64 -c kcp.json 
ps:关键点：
kcp.json中ss的ip用宿主机docker0的ip
```


## kcp.json
```
{
"listen": ":110",
"target": "172.17.0.1:443",
"key": "xxxxxxxxx",
"crypt": "aes-128",
"mode": "manual",
"mtu": 1400,
"sndwnd": 1024,
"rcvwnd": 1024,
"datashard": 30,
"parityshard": 15,
"dscp": 46,
"nocomp": true,
"acknodelay": false,
"nodelay": 0,
"interval": 20,
"resend": 2,
"nc": 1,
"sockbuf": 4194304,
"keepalive": 10
}
```

