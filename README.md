# vps
one step create ups

## update
```
apt update;apt upgrade -yy
```
## install tools
```
apt install curl wget tmux git net-tools
```

### install outline
```
bash -c "$(wget -qO- https://raw.githubusercontent.com/Jigsaw-Code/outline-server/master/src/server_manager/install_scripts/install_server.sh)"
```
### install pip
```
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py&&rm get-pip.py
```
### install shadowsocks
```
pip install -U git+https://github.com/shadowsocks/shadowsocks.git@master
```

### start ss
```
tmux
nohup /usr/bin/python /usr/local/bin/ssserver   --workers 5 -s 0.0.0.0  -p 443 -k yourPswd -m aes-256-cfb &
```

### docker run kcp
```
docker pull alpine:latest
docker run -it  -v /tmp/.X11-unix:/tmp/.X11-unix --privileged --net=host -v /root/kcp:/kcp  -P --name=kcp cdf98d1859c1 /bin/sh
# (ps:cdf98d1859c1 is
docker images|grep alpine
# your see)

# in your docker
echo "ulimit -n 65535">>~/.bashrc 
source ~/.bashrc
cat <<EOT>>/etc/sysctl.conf
net.core.rmem_max=26214400 // BDP - bandwidth delay product
net.core.rmem_default=26214400
net.core.wmem_max=26214400
net.core.wmem_default=26214400
net.core.netdev_max_backlog=2048 // proportional to -rcvwnd
EOT


docker start 92507b990a7c;docker exec -it  92507b990a7c /bin/sh
#（ps： 92507b990a7c is
docker ps -a|grep kcp
# your see)

cd /kcp/;./server_linux_amd64 -c kcp.json 
```
