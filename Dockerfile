FROM ubuntu:16.04
MAINTAINER ManuelLR "manuellr.git@gmail.com"

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y curl sudo oracle-java8-installer libxext-dev libxrender-dev libxtst-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

# Install libgtk as a separate step so that we can share the layer above with
# the netbeans image
RUN apt-get update && apt-get install -y libgtk2.0-0 libcanberra-gtk-module

RUN echo 'Installing eclipse' && \
    curl -SL http://eclipse.c3sl.ufpr.br/technology/epp/downloads/release/neon/1a/eclipse-cpp-neon-1a-linux-gtk-x86_64.tar.gz | \
    tar -C /opt/ -xz && echo "ECLIPSE_C downloaded !"

ADD run /usr/local/bin/eclipse

RUN chmod +x /usr/local/bin/eclipse && \
    mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown developer:developer -R /home/developer && \
    chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo

USER developer
ENV HOME /home/developer
WORKDIR /home/developer
CMD /usr/local/bin/eclipse
