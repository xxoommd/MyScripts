# init_ss_for_ubuntu_1804.sh:
- curl:
```sh
curl -o- https://raw.githubusercontent.com/xxoommd/MyScripts/master/init_ss_for_ubuntu_1804.sh | bash
```
- wget:

```sh
wget -qO- https://raw.githubusercontent.com/xxoommd/MyScripts/master/init_ss_for_ubuntu_1804.sh | bash
```

# Ubuntu 18.04 install latest nginx:
```sh
sudo apt install -y curl gnupg2 ca-certificates lsb-release && echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list && curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add - && sudo apt-key fingerprint ABF5BD827BD9BF62 && apt update -y && apt install -y nginx
```
