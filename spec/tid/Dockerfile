FROM rastasheep/ubuntu-sshd:14.04
MAINTAINER linyows <linyows@gmail.com>

ENV HOME /root
RUN apt-get install -y rsync
RUN mkdir /root/.ssh
ADD id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 700 /root/.ssh
RUN chmod 600 /root/.ssh/authorized_keys
