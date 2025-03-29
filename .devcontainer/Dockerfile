FROM ubuntu:22.04@sha256:77906da86b60585ce12215807090eb327e7386c8fafb5402369e421f44eff17e

ARG DEBIAN_FRONTEND=noninteractive

ARG CONTAINER_USERNAME=developer
ARG USER_ID=1000
ARG GROUP_ID=1000

RUN groupadd -g $GROUP_ID $CONTAINER_USERNAME && \
        useradd -u $USER_ID -g $GROUP_ID -ms /bin/bash $CONTAINER_USERNAME && \
        usermod -aG sudo $CONTAINER_USERNAME
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates sudo wget && rm -rf /var/lib/apt/lists/*
RUN echo "$CONTAINER_USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3-dev python3-pip git automake autoconf libtool g++ coreutils policykit-1 \
              libgtk2.0-dev uml-utilities gtk-sharp2 libncurses5 libtinfo5 make libusb-dev libftdi1* patch vim openssh-client -y
RUN apt-get install git help2man perl python3 make cmake autoconf g++ flex bison ccache lcov\
                    libgoogle-perftools-dev numactl perl-doc -y
RUN apt-get update && apt-get install -y \
        python3-pip
RUN pip install gdown && \
        rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt install -y gnupg && \
        apt install -y ca-certificates gnupg && \
        gpg --homedir /tmp --no-default-keyring --keyring /usr/share/keyrings/mono-official-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
        echo "deb [signed-by=/usr/share/keyrings/mono-official-archive-keyring.gpg] https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list && \
        apt update
RUN apt-get update && apt-get install -y libc6
RUN apt install -y mono-devel && apt install -y mono-complete
RUN apt-get install -y policykit-1 libgtk2.0-0 screen uml-utilities gtk-sharp2 libc6-dev gcc python3 python3-pip curl
RUN apt-get install -y hicolor-icon-theme && apt-get install -y mime-support
RUN apt-get install -y ruby ruby-dev rpm 'bsdtar|libarchive-tools' && gem install dotenv -v 2.8.1 && gem install fpm
RUN apt-get install --reinstall ca-certificates

USER $CONTAINER_USERNAME
WORKDIR /home/$CONTAINER_USERNAME
RUN git config --global http.sslverify false
RUN git clone https://github.com/verilator/verilator.git && unset VERILATOR_ROOT
RUN cd verilator && \
        git pull && git checkout stable && autoconf && \
        export VERILATOR_AUTHOR_SITE=1  && export VERILATOR_ROOT=`pwd` && \
        ./configure --enable-longtests && \
        git pull && git checkout stable && autoconf && make -j '1'

USER root
RUN cd /home/$CONTAINER_USERNAME/verilator && sudo make install
RUN sudo cpan -i Parallel::ForkManager
RUN pip install robotframework==6.0.2 \
                robotframework-retryfailed==0.2.0 \
                psutil==5.9.3 \
                pyyaml==6.0 \
                construct==2.10.68 \
                pyelftools==0.30 \
                construct==2.10.68 \
                pyelftools==0.30 \
                # For downloading sc-dt from official release page.
                gdown==5.2.0

RUN sudo apt-get update &&  sudo apt-get -y install build-essential clang bison flex \
                libreadline-dev gawk tcl-dev libffi-dev git \
                graphviz xdot pkg-config python3 zlib1g-dev

RUN python3 -m pip install click

RUN git config --global http.sslverify "false"

RUN cd /home/developer
RUN git clone https://github.com/YosysHQ/yosys --recurse-submodules
RUN cd /home/developer/yosys && make
RUN cd /home/developer/yosys && sudo make install

RUN cd /home/developer
RUN git clone https://github.com/YosysHQ/sby --recurse-submodules
RUN cd /home/developer/sby && sudo make install

RUN cd /home/developer
RUN git clone https://github.com/Z3Prover/z3.git --recurse-submodules
RUN cd /home/developer/z3 && python3 scripts/mk_make.py
RUN cd /home/developer/z3/build && make && sudo make install

USER $CONTAINER_USERNAME
ENV HOME /home/$CONTAINER_USERNAME
WORKDIR /home/$CONTAINER_USERNAME

ARG SC_DT_FILE="https://drive.syntacore.com/s/8Atb2bcYjZS8eHE/download?path=%2F2024%2F2024.12&files=sc-dt-2024.12.tar.gz&downloadStartSecret=zf4hv9rvnno"
RUN curl --insecure --output sc-dt.tar.gz ${SC_DT_FILE} && \
        tar -xvf /home/$CONTAINER_USERNAME/sc-dt.tar.gz && \
        rm -rf /tmp/cookies.txt sc-dt.tar.gz
# RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  

USER root