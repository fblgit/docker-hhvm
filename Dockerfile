FROM ubuntu:trusty
MAINTAINER brunoric <brunoric@gmail.com>

# Installing packages
RUN apt-get update && apt-get upgrade -y
RUN apt-get -y install wget supervisor
RUN wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | sudo apt-key add -
RUN echo deb http://dl.hhvm.com/ubuntu trusty main | sudo tee /etc/apt/sources.list.d/hhvm.list
RUN sudo apt-get update && apt-get -y install libgmp-dev libmemcached-dev hhvm
RUN apt-get clean && apt-get autoremove -y

# Scripts
ADD supervisord-hhvm.conf /supervisord-hhvm.conf
ADD supervisord-hhvm.sh /supervisord-hhvme.sh
ADD start.sh /start.sh
RUN chmod 755 /start.sh

# Exposing HHVM-FastCGI port
EXPOSE 9000

# Default command
CMD ["/start.sh"]