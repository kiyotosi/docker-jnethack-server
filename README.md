docker-jnethack-server
======================

Dockerfile for Public JNetHack server (Ver.3.6.6-0.1)
Public NetHack server at alt.org (NAO)のJNetHack版。
- jnethack ServerをDockerで構築することができる。
- telnet,HTTPSに対応

## Screen Shot
![title](https://user-images.githubusercontent.com/19776716/122664420-3a890280-d1dc-11eb-887f-080e37a80d5e.png)
![play](https://user-images.githubusercontent.com/19776716/122664440-60aea280-d1dc-11eb-875a-109a6e483b56.png)

## Howto

    git clone https://github.com/kiyotosi/docker-jnethack-server
    cd docker-jnethack-server
    sudo docker build -t jnh .
    sudo docker container run --name jnh -p 23:23 -d jnh
    
    # telnetのみでアクセスする場合は、上記手順のみでOK。
    # 以下の操作は、Web CLIを有効化する場合のみ実施すること。
    sudo apt-get install golang
    go get github.com/yudai/gotty
    sudo cp -p ~/go/bin/gotty /usr/local/bin/gotty
    sudo chown root:root /usr/local/bin/gotty
    sudo chmod 544 /usr/local/bin/gotty
    
    # HTTPの場合
    sudo /usr/local/bin/gotty -p 8080 \
        --title-format "\"jnethack\"" \
        -w docker run -it jnh /opt/nethack/nethack.alt.org/dgamelaunch-wrapper

    # HTTPSの場合(事前にSSLCertficateFile,SSLCertificateKeyFileの用意が必要)
    sudo /usr/local/bin/gotty -p 8080 \
        --title-format "\"jnethack\"" \
        --tls --tls-crt /etc/letsencrypt/live/kiyo2.info/fullchain.pem \
        --tls-key /etc/letsencrypt/live/kiyo2.info/privkey.pem \
        -w docker run -it jnh /opt/nethack/nethack.alt.org/dgamelaunch-wrapper

## References
以下のページを参考にさせていただきました。
- [Public JNetHack Server at nethack.matsuu.net](https://matsuu.net/nethack/)
- [matsuu/docker-jnethack](https://github.com/matsuu/docker-jnethack)
- [docker と gotty で cloud な nethack プレイ環境を構築](https://qiita.com/rerofumi/items/8bf1c4395eb1e9b07c3f)
- [NetHack 3.4.3: Home Page](http://www.nethack.org/)
- [JNetHack Home Page](http://www.jnethack.org/)
- [JNetHack Project](http://jnethack.sourceforge.jp/)
- [paxed/dgamelaunch](https://github.com/paxed/dgamelaunch)
- [HowTo setup dgamelaunch](http://nethackwiki.com/wiki/User:Paxed/HowTo_setup_dgamelaunch)
