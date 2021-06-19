FROM ubuntu

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y autoconf bison \
    bsdmainutils bzip2 gzip flex gcc git groff language-pack-ja libncursesw5-dev \
    libsqlite3-dev make ncurses-dev patch sqlite3 tar wget \
    telnetd xinetd less nkf && \
  apt-get clean

RUN locale-gen ja_JP.UTF-8

RUN git clone git://github.com/paxed/dgamelaunch.git && \
  cd dgamelaunch && \
  sed -i \
    -e "s/-lrt/-lrt -pthread/" \
    configure.ac && \
  sed -i \
    -e "/^maxnicklen/s/=.*/= 16/" \
    -e "s:\"\$MOTDTIME\" =.*:\"\$MOTDTIME\" = \"2020.04.30\",:" \
    -e "/SERVERID/s/nethack\.alt\.org/nethack.kiyo2.info/" \
    -e "/SERVERID/s/nethack\.alt\.org/kiyo2.info\/nethack/" \
    -e "/game_\(path\|args\)/s/nethack/jnethack/" \
    -e "/game_name/s/NetHack 3\.4\.3/JNetHack 3.6.6-0.1/" \
    -e "s/343/366/g" \
    examples/dgamelaunch.conf && \
  sed -i \
    -e "s/NetHack 3\.4\.3/JNetHack 3.6.6-0.1/" \
    examples/dgl_menu_main_user.txt && \
  ./autogen.sh \
    --enable-sqlite \
    --enable-shmem \
    --with-config-file=/opt/nethack/nethack.alt.org/etc/dgamelaunch.conf && \
  make && \
  sed -i \
    -e "s/nh343/nh366/" \
    dgl-create-chroot && \
  sh -c ./dgl-create-chroot && \
  sh -c 'echo "#!/bin/sh\nLANG=ja_JP.UTF-8 /opt/nethack/nethack.alt.org/dgamelaunch" > /opt/nethack/nethack.alt.org/dgamelaunch-wrapper' && \
  chmod +x /opt/nethack/nethack.alt.org/dgamelaunch-wrapper && \
  cd .. && \
  rm -rf dgamelaunch 

RUN \
  wget \
    http://www.nethack.org/download/3.6.6/nethack-366-src.tgz \
    https://osdn.net/dl/jnethack/jnethack-3.6.6-0.1.diff.gz && \
  tar zxf nethack-366-src.tgz && \
  mv NetHack-NetHack-3.6.6_Released nethack-3.6.6 && \
  cd nethack-3.6.6 && \
  gzip -dc ../jnethack-3.6.6-0.1.diff.gz | nkf -e | patch -p1 && \
  sed -i \
    -e "/^CFLAGS/s/-O/-O2 -fomit-frame-pointer/" \
    sys/unix/Makefile.src sys/unix/Makefile.utl && \
  sed -i \
    -e "/rmdir \.\/-p/d" \
    -e "/^#GAMEUID/s:^#::" \
    -e "/^#GAMEGRP/ s:^#:: ; s:bin:games:" \
    -e "/\t\+-\?if.*SHELLDIR/,/fi$/ s/^/#/i" \
    -e "/GAMEDIR/ s:^:#:" \
    sys/unix/Makefile.top && \
  sed -i \
    -e "s:^PREFIX.*:PREFIX = /opt/nethack/nethack.alt.org:" \
    -e "s:^HACKDIR.*:HACKDIR = /nh366:" \
    sys/unix/hints/linux-chroot && \ 
  sh sys/unix/setup.sh sys/unix/hints/linux-chroot && \
  sed -i \
    -e "/# define XI18N/d" \
    -e "/define HACKDIR/s:\".*\":\"/nh366\":" \
    -e "/define COMPRESS /s:\".*\":\"/bin/gzip\":" \
    include/config.h && \
  sed -i \
    -e "/XI18N/i #include <locale.h>" \
    sys/unix/unixmain.c && \ 
  sed -i \
    -e "s:/\* \(#define\s*\(SYSV\|LINUX\|TERMINFO\|TIMED_DELAY\)\)\s*\*/:\1:" \
    -e "s:/\* \(#define VAR_PLAYGROUND\).*:\1 \"/nh366/var\":" \
    include/unixconf.h && \
  sed -i \
    -e "/^enter_explore_mode()/a {return 0;}\nSTATIC_PTR int _enter_explore_mode()" \
    src/cmd.c && \
  sed -i \
    -e "/^#define ENTRYMAX/s/100/10000/" \
    -e "/^#define NAMSZ/s/10/16/" \
    -e "/^#define PERS_IS_UID/d" \
    src/topten.c && \
  make all && \
  make install && \
  cd .. && \
  rm -rf \
    nethack-3.6.6 \
    nethack-366-src.tgz \
    jnethack-3.6.6-0.1.diff.gz

RUN tar cf - \
  /bin/sh \
  /bin/dash \
  /lib/x86_64-linux-gnu/libncurses* \
  /usr/share/i18n \
  /usr/share/locale \
  /usr/share/locale-langpack \
  /usr/lib/x86_64-linux-gnu/gconv \
  /usr/lib/locale \
  /usr/bin/nkf \
  /usr/bin/less \
  | tar xf - -C /opt/nethack/nethack.alt.org/

RUN ( \
  echo "service telnet" && \
  echo "{" && \
  echo "  socket_type = stream" && \
  echo "  protocol    = tcp" && \
  echo "  user        = root" && \
  echo "  wait        = no" && \
  echo "  server      = /usr/sbin/in.telnetd" && \
  echo "  server_args = -L /opt/nethack/nethack.alt.org/dgamelaunch-wrapper" && \
  echo "  rlimit_cpu  = 120" && \
  echo "}" \
) > /etc/xinetd.d/dgl

RUN cd /opt/nethack/nethack.alt.org && \
  chown games:games -R nh366 && \
  echo "FAQ comming soon."  > /opt/nethack/nethack.alt.org/nh366/var/faq.utf8

RUN git clone https://github.com/kiyotosi/jnethack-server.conf && \
  cd jnethack-server.conf/conf && \
  tar cf - * | tar xf - -C /opt/nethack/nethack.alt.org/ && \
  cd ../../ && \
  rm -r jnethack-server.conf/conf 

RUN  ( \
  echo "#!/bin/sh" && \
  echo "/usr/bin/nkf /nh366/var/record | /usr/bin/less" \
  ) > /opt/nethack/nethack.alt.org/bin/mkrank && \
  chmod +x /opt/nethack/nethack.alt.org/bin/mkrank 

VOLUME ["/opt/nethack/nethack.alt.org/nh366/var", "/opt/nethack/nethack.alt.org/dgldir"]

EXPOSE 23

CMD ["xinetd", "-dontfork"]

