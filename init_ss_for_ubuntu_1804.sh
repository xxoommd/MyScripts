#!/bin/bash
  
echo "Open bbr..."
cp /etc/sysctl.conf /tmp/
echo "net.core.default_qdisc=fq" >> /tmp/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /tmp/sysctl.conf
sudo cp /tmp/sysctl.conf /etc/
sudo sysctl -p; lsmod |grep bbr

echo "Installing docker..."
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker `whoami`
sudo systemctl enable docker
sudo systemctl start docker
sudo docker run -dt --restart always --name ssserver -p 9527:6443 -p 6500:6500/udp mritd/shadowsocks -m "ss-server" -s "-s 0.0.0.0 -p 6443 -m chacha20 -k fuckyouall --fast-open" -x -e "kcpserver" -k "-t 127.0.0.1:6443 -l :6500 -mode fast2"
sudo docker run -d -p 9528:443 --name=mtproto --ulimit nofile=98304:98304 --restart=always -v proxy-config:/data -e SECRET=abcdef1234567890987654321fedcdba telegrammessenger/proxy
