FROM skysider/pwndocker:latest

RUN apt-get -y update && \
    apt install -y \
    clang \
    binutils-dev \
    libunwind8-dev \
    lldb \
    llvm \
    python2 \
    python-setuptools \
    python3-venv \
    python3-setuptools \
    openvpn \
    bsdmainutils \
    libtool && \
    rm -rf /var/lib/apt/list/*

RUN wget -O /root/.gdbinit-gef.py -q http://gef.blah.cat/py && \
    echo source /root/.gdbinit-gef.py >> /root/.gdbinit

RUN pip install pipx gdbgui && \
    python3 -m userpath append ~/.local/bin && \
    pipx install gdbgui

COPY gdbtools.sh /bin/
COPY gdbinit /root/.gdbinit
COPY .tmux.conf.local /root/.tmux.conf.local
COPY bin/cwdump /bin/cwdump
COPY bin/cwfind /bin/cwfind
COPY bin/cwtriage /bin/cwtriage

RUN chmod +x /bin/gdbtools.sh && ln -s /bin/gdbtools.sh /bin/gdbtools

RUN git clone https://github.com/AFLplusplus/AFLplusplus.git /root/AFLplusplus && \
    cd /root/AFLplusplus && \
    make install && \
    mkdir /root/src && \
    git clone https://github.com/jfoote/exploitable.git /root/src/exploitable && \
    cd /root/src/exploitable && \
    python3 setup.py install && \
    git clone https://github.com/google/honggfuzz.git /root/honggfuzz && \
    cd /root/honggfuzz && \
    make && make install && \
    cd /root && \
    git clone https://github.com/gpakosz/.tmux.git --progress --verbose && \
    ln -s -f .tmux/.tmux.conf && \
    git clone https://github.com/lieanu/LibcSearcher.git /root/LibcSearcher && \
    cd /root/LibcSearcher && \
    python3 setup.py develop && \
    git clone https://github.com/longld/peda.git /root/peda && \
    git clone https://gitlab.com/rc0r/afl-utils.git /root/afl-utils && \
    cd /root/afl-utils && \
    python3 setup.py install

EXPOSE 5000 22
