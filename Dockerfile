FROM phusion/baseimage:master-amd64

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Asia/Shanghai

RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt install -y \
    libc6:i386 \
    libc6-dbg:i386 \
    libc6-dbg \
    lib32stdc++6 \
    g++-multilib \
    cmake \
    ipython3 \
    vim \
    net-tools \
    iputils-ping \
    libffi-dev \
    libssl-dev \
    python3-dev \
    python3-pip \
    build-essential \
    ruby \
    ruby-dev \
    tmux \
    strace \
    ltrace \
    nasm \
    wget \
    gdb \
    gdb-multiarch \
    netcat \
    socat \
    git \
    patchelf \
    gawk \
    file \
    python3-distutils \
    bison \
    rpm2cpio cpio \
    zstd \
    tzdata --fix-missing && \
    rm -rf /var/lib/apt/list/*

RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata
    
RUN wget https://github.com/radareorg/radare2/releases/download/4.4.0/radare2_4.4.0_amd64.deb && \
    dpkg -i radare2_4.4.0_amd64.deb && rm radare2_4.4.0_amd64.deb

RUN python3 -m pip install -U pip && \
    python3 -m pip install --no-cache-dir \
    ropgadget \
    pwntools \
    z3-solver \
    smmap2 \
    apscheduler \
    ropper \
    unicorn \
    keystone-engine \
    capstone \
    angr \
    pebble \
    r2pipe

RUN gem install one_gadget seccomp-tools && rm -rf /var/lib/gems/2.*/cache/*

RUN git clone https://github.com/pwndbg/pwndbg && \
    cd pwndbg && \
    /bin/sh setup.sh
# RUN git clone https://github.com/pwndbg/pwndbg && \
#     cd pwndbg && chmod +x setup.sh && ./setup.sh && \
#     git clone https://github.com/longld/peda.git /root/peda && \
#     git clone https://github.com/scwuaptx/Pwngdb.git /root/Pwngdb && \
#     cd /root/Pwngdb && cat /root/Pwngdb/.gdbinit  >> /root/.gdbinit && \
#     sed -i "s?source ~/peda/peda.py?# source ~/peda/peda.py?g" /root/.gdbinit && \
#     git clone https://github.com/niklasb/libc-database.git libc-database && \
#     cd libc-database && ./get ubuntu debian || echo "/libc-database/" > ~/.libcdb_path && \
#     git clone https://github.com/google/AFL.git /root/AFL --progress --verbose && \
#     cd /root/AFL && make && make install && \
#     git clone https://github.com/google/honggfuzz.git /root/honggfuzz && \
#     cd /root/honggfuzz && make && make install && cd /root && \
#     git clone https://github.com/gpakosz/.tmux.git --progress --verbose && \
#     ln -s -f .tmux/.tmux.conf && \
#     git clone https://github.com/lieanu/LibcSearcher.git /root/LibcSearcher && \
#     cd /root/LibcSearcher && \
#     python3 setup.py develop

WORKDIR /ctf/work/

COPY --from=skysider/glibc_builder64:2.19 /glibc/2.19/64 /glibc/2.19/64
COPY --from=skysider/glibc_builder32:2.19 /glibc/2.19/32 /glibc/2.19/32

COPY --from=skysider/glibc_builder64:2.23 /glibc/2.23/64 /glibc/2.23/64
COPY --from=skysider/glibc_builder32:2.23 /glibc/2.23/32 /glibc/2.23/32

COPY --from=skysider/glibc_builder64:2.24 /glibc/2.24/64 /glibc/2.24/64
COPY --from=skysider/glibc_builder32:2.24 /glibc/2.24/32 /glibc/2.24/32

COPY --from=skysider/glibc_builder64:2.28 /glibc/2.28/64 /glibc/2.28/64
COPY --from=skysider/glibc_builder32:2.28 /glibc/2.28/32 /glibc/2.28/32

COPY --from=skysider/glibc_builder64:2.29 /glibc/2.29/64 /glibc/2.29/64
COPY --from=skysider/glibc_builder32:2.29 /glibc/2.29/32 /glibc/2.29/32

COPY --from=skysider/glibc_builder64:2.30 /glibc/2.30/64 /glibc/2.30/64
COPY --from=skysider/glibc_builder32:2.30 /glibc/2.30/32 /glibc/2.30/32

COPY --from=skysider/glibc_builder64:2.27 /glibc/2.27/64 /glibc/2.27/64
COPY --from=skysider/glibc_builder32:2.27 /glibc/2.27/32 /glibc/2.27/32

COPY linux_server linux_server64  /ctf/

RUN chmod a+x /ctf/linux_server /ctf/linux_server64

RUN apt-get -y update && \
    #apt purge --autoremove radare2 -y && \
    apt install -y \
    clang \
    binutils-dev \
    libunwind8-dev \
    lldb \
    openvpn \
    libtool && \
    #flex && \
    #libzip-dev && \
    #radare2 && \
    rm -rf /var/lib/apt/list/*

RUN wget -O /root/.gdbinit-gef.py -q http://gef.blah.cat/py && \
    echo source /root/.gdbinit-gef.py >> /root/.gdbinit

COPY gdbtools.sh /bin/
# COPY gdbinit /root/.gdbinit
COPY .tmux.conf.local /root/.tmux.conf.local

RUN chmod +x /bin/gdbtools.sh && ln -s /bin/gdbtools.sh /bin/gdbtools

#RUN ulimit -c unlimited && \
#    echo 1 > /proc/sys/kernel/core_uses_pid

CMD ["/sbin/my_init"]