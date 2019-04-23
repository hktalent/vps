apt update;apt upgrade -yy
apt install curl wget tmux git net-tools -yy
bash -c "$(wget -qO- https://raw.githubusercontent.com/Jigsaw-Code/outline-server/master/src/server_manager/install_scripts/install_server.sh)"

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py&&rm get-pip.py
pip install -U git+https://github.com/shadowsocks/shadowsocks.git@master
tmux new -s myss -d
tmux send -t "myss" "
nohup /usr/bin/python /usr/local/bin/ssserver   --workers 5 -s 0.0.0.0  -p 443 -k $yourPswd -m aes-256-cfb
" Enter
docker pull alpine:latest
did=`docker images|grep alpine|grep latest|awk '{print $3}'`
docker run -it  -v /tmp/.X11-unix:/tmp/.X11-unix --privileged --net=host -v /root/kcp:/kcp  -P --name=kcp $did /bin/sh

