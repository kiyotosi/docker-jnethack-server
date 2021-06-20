docker-jnethack-server
======================

Dockerfile for Public JNetHack server (Ver.3.6.6-0.1)

## DEMO
![play](https://user-images.githubusercontent.com/19776716/122664324-b33b8f00-d1db-11eb-8a97-6eba374a5bd1.png)

## Howto

    docker run --detach --name=jnh --publish=23:23 kiyo2/jnethack-server

## Build

    docker build -t jnethack-server .

## References

- [Public JNetHack Server at nethack.matsuu.net](https://matsuu.net/nethack/)
- [matsuu/docker-jnethack](https://github.com/matsuu/docker-jnethack)
- [docker と gotty で cloud な nethack プレイ環境を構築](https://qiita.com/rerofumi/items/8bf1c4395eb1e9b07c3f)
- [NetHack 3.4.3: Home Page](http://www.nethack.org/)
- [JNetHack Home Page](http://www.jnethack.org/)
- [JNetHack Project](http://jnethack.sourceforge.jp/)
- [Compiling - Wikihack](http://nethack.wikia.com/wiki/Compiling)
- [jNetHack UTF-8対応 を CentOS 6.3 にインストール](http://qiita.com/KurokoSin/items/bbbfb4b4f9ee645418f1)
- [paxed/dgamelaunch](https://github.com/paxed/dgamelaunch)
- [HowTo setup dgamelaunch](http://nethackwiki.com/wiki/User:Paxed/HowTo_setup_dgamelaunch)
