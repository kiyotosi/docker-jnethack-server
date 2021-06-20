# みんなでJNethackやろうぜ  

## これは何？
Dockerを利用したPublick JNetHackサーバです。  
Public NetHack server at alt.org (NAO)をJNetHackに変更してあります。  

## やれること
- JNetHack (Ver.3.6.6-0.1)をプレイすることができる。  
- ほかの人のプレイを覗くことができる。(自分のプレイのみでではない)  
- アクセス方法はtelnetとHTTP/HTTPSの２種類

## Screen Shot
![title](https://user-images.githubusercontent.com/19776716/122664420-3a890280-d1dc-11eb-887f-080e37a80d5e.png)
![play](https://user-images.githubusercontent.com/19776716/122664440-60aea280-d1dc-11eb-875a-109a6e483b56.png)

## Howto

    git clone https://github.com/kiyotosi/docker-jnethack-server
    cd docker-jnethack-server
    sudo docker build -t jnh .
    
    # HTTP and telnetの場合
    docker run -it --name jnhsrv \
      -p 23:23 \
      -p 8080:8080 \
      jnh:latest

    # HTTPS and telnetの場合
    # (事前にSSLCertficateFile,SSLCertificateKeyFileの用意が必要)
    docker run -it --name jnhsrv \
      -p 23:23 \
      -p 8080:8080 \
      -e GOTTY_TLS=true \
      -v "/etc/letsencrypt/live/kiyo2.info/fullchain.pem:/root/.gotty.crt:ro" \
      -v "/etc/letsencrypt/live/kiyo2.info/privkey.pem:/root/.gotty.key:ro" \
      jnh:latest

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
