FROM amd64/debian:stretch as builder
MAINTAINER Kai Timmer <email@kaitimmer.de>

RUN apt-get update && apt-get install -y \
  build-essential \
  git \
  curl \
  libcurl4-openssl-dev

RUN git clone https://git.code.sf.net/p/esniper/git /tmp/esniper-git
RUN cd /tmp/esniper-git; ./configure; make

FROM amd64/debian:stretch
# install needed php extensions
RUN apt-get update && apt-get install -y \
  apache2 \
  ca-certificates \
  curl \
  git \
  libapache2-mod-php7.0 \
  openssl \
  php7.0 \
  php7.0-curl \
  php7.0-gd \
  php7.0-mbstring \
  php7.0-xml

# install esniper
COPY --from=builder /tmp/esniper-git/esniper /usr/local/bin/
RUN chmod 755 /usr/local/bin/esniper

# configure apache
ADD files/apache2-foreground /usr/bin/apache2-foreground
RUN chmod 755 /usr/bin/apache2-foreground
RUN rm /var/www/html/index.html

# install es-f
RUN git clone https://github.com/syssi/es-f.git  /var/www/html
WORKDIR /var/www/html
RUN git submodule init && git submodule update
VOLUME /var/www/html/local
RUN chown www-data:www-data -R /var/www/html

CMD apache2-foreground
