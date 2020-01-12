# Creamos la imagen a partir de ubuntu versión 18.04
FROM ubuntu:18.04

# Damos información sobre la imagen que estamos creando
LABEL \
	version="1.0" \
	description="Ubuntu + Apache2 + virtual host" \
	creationDate="23-11-2019" \
	maintainer="Teresa del Romero <tdelromero@birt.eus>"

# Instalamos el editor nano
RUN \
	apt-get update \
	&& apt-get install nano \
	&& apt-get install apache2 --yes \
	&& mkdir /var/www/html/sitio1 /var/www/html/sitio2 \
	&& apt-get install ssh --yes \
	&& apt-get install git --yes \
	&& apt-get install proftpd --yes

# Copiamos el index al directorio por defecto del servidor Web
COPY index1.html index2.html sitio1.conf sitio2.conf sitio1.key sitio1.cer proftpd.conf tls.conf ftpusers proftpd.crt proftpd.key sshd_config /

RUN \
	mv /index1.html /var/www/html/sitio1/index.html \
	&& mv /index2.html /var/www/html/sitio2/index.html \
	&& mv /sitio1.conf /etc/apache2/sites-available \
	&& a2ensite sitio1 \
	&& mv /sitio2.conf /etc/apache2/sites-available \
	&& a2ensite sitio2 \
	&& mv /sitio1.key /etc/ssl/private \
	&& mv /sitio1.cer /etc/ssl/certs \
	&& a2enmod ssl \
	&& mv /proftpd.conf /etc/proftpd \
	&& mv /tls.conf /etc/proftpd \
	&& mv /ftpusers /etc \
	&& mv /proftpd.crt /etc/ssl/certs \
	&& mv /proftpd.key /etc/ssl/private \
	&& mv /sshd_config /etc/ssh \
	&& useradd teresa1 \
	&& useradd teresa2 \
	&& chmod 777 -R /var/www/html/sitio1 \
	&& chmod 777 -R /var/www/html/sitio2 \
	&& usermod -d /var/www/html/sitio1 teresa1 \
	&& usermod -d /var/www/html/sitio2 teresa2

# Copiamos la clave privada
#COPY SSH-key/id_rsa /etc 

# arrancamos el ssh-agent, añadimos la clave y el host
#RUN eval "$(ssh-agent -s)" \
#&& chmod 700 /etc/id_rsa \
#&& ssh-add /etc/id_rsa \
#&& ssh-keyscan -H github.com >> /etc/ssh/ssh_known_hosts \
#&& git clone git@github.com:deaw-birt/proyecto-html.git /usr/local/apache2/htdocs/proyecto

# Indicamos el puerto que utiliza la imagen
EXPOSE 80
EXPOSE 443
EXPOSE 21
EXPOSE 1022
EXPOSE 50000-50053