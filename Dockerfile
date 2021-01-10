FROM skysider/pwndocker:latest

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
COPY gdbinit /root/.gdbinit
COPY .tmux.conf.local /root/.tmux.conf.local
COPY LibcSearcher /root/LibcSearcher

RUN chmod +x /bin/gdbtools.sh && ln -s /bin/gdbtools.sh /bin/gdbtools

RUN ulimit -c unlimited && \
    echo 1 > /proc/sys/kernel/core_uses_pid

RUN git clone https://github.com/google/AFL.git /root/AFL --progress --verbose && \
    cd /root/AFL && \
    make && make install && \
    git clone https://github.com/google/honggfuzz.git /root/honggfuzz && \
    cd /root/honggfuzz && \
    make && make install && \
    cd /root && \
    git clone https://github.com/gpakosz/.tmux.git --progress --verbose && \
    ln -s -f .tmux/.tmux.conf && \
    cd /root/LibcSearcher && \
    python3 setup.py develop
    # cd /root/LibcSearcher/libc-database && \
    # ./get ubuntu


#RUN cd /root && \
#    r2pm init && \
#    r2pm update && \
#    r2pm -i r2ghidra-dec
