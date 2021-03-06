FROM skysider/pwndocker:latest

RUN apt-get -y update && \
    apt install -y \
    clang \
    binutils-dev \
    libunwind8-dev \
    lldb \
    openvpn \
    emacs \
    libtool && \
    rm -rf /var/lib/apt/list/*

RUN wget -O /root/.gdbinit-gef.py -q http://gef.blah.cat/py && \
    echo source /root/.gdbinit-gef.py >> /root/.gdbinit

COPY gdbtools.sh /bin/
COPY gdbinit /root/.gdbinit
COPY .tmux.conf.local /root/.tmux.conf.local
COPY honggfuzz /root/honggfuzz
COPY AFL /root/AFL
COPY tmux /root/.tmux
COPY LibcSearcher /root/LibcSearcher
COPY peda /root/peda
COPY spacemacs /root/.emacs.d

RUN chmod +x /bin/gdbtools.sh && ln -s /bin/gdbtools.sh /bin/gdbtools

#RUN git clone https://github.com/google/AFL.git /root/AFL --progress --verbose && \
RUN cd /root/AFL && \
    make && make install && \
#    git clone https://github.com/google/honggfuzz.git /root/honggfuzz && \
    cd /root/honggfuzz && \
    make && make install && \
    cd /root && \
#    git clone https://github.com/gpakosz/.tmux.git --progress --verbose && \
    ln -s -f .tmux/.tmux.conf && \
#    git clone https://github.com/lieanu/LibcSearcher.git /root/LibcSearcher && \
    cd /root/LibcSearcher && \
    python3 setup.py develop
#    git clone https://github.com/longld/peda.git /root/peda
