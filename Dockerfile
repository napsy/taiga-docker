FROM ubuntu:16.10
RUN apt-get update && \
    apt-get -y install supervisor git postgresql sudo bash && \
    adduser \
    --system \
    --shell /bin/bash \
    --gecos 'Taiga user' \
    --group \
    --disabled-password \
    --home /home/taiga \
    taiga && \
    mkdir -p /home/taiga/.setup
ADD dot_setup /home/taiga/.setup/data.sh
RUN chown -R taiga:taiga /home/taiga/.setup && \
    sudo -u taiga git clone https://github.com/taigaio/taiga-scripts.git /home/taiga/taiga-scripts
WORKDIR /home/taiga/taiga-scripts
RUN echo "taiga ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    export HOME=/home/taiga && \
    service postgresql start && \
    sudo -u taiga bash setup-server.sh
ADD *.conf /etc/supervisor/conf.d/
ADD start-backend.sh /home/taiga/taiga-backend/
EXPOSE 80
CMD ["/usr/bin/supervisord", "-n"]
