FROM fedora:29 AS ldif
LABEL maintainer="stephen@brokenbottle.net"

RUN yum update -y \
  && yum install -y ruby rubygem-net-ldap

COPY generate-ldif.rb /srv

RUN /srv/generate-ldif.rb > /srv/services.ldif

FROM fedora:29
LABEL maintainer="stephen@brokenbottle.net"

RUN yum update -y \
  && yum install -y openldap-servers

COPY slapd.ldif /srv/slapd.ldif

RUN rm -rf /etc/openldap/slapd.d \
  && mkdir -p /etc/openldap/slapd.d/ \
  && /usr/sbin/slapadd -F /etc/openldap/slapd.d/ -n0 -l /srv/slapd.ldif \
  && /usr/sbin/slapadd -F /etc/openldap/slapd.d/ -n0 -l /etc/openldap/schema/cosine.ldif \
  && /usr/sbin/slapadd -F /etc/openldap/slapd.d/ -n0 -l /etc/openldap/schema/nis.ldif \
  && chown -R ldap:ldap /etc/openldap/slapd.d/

COPY --from=ldif /srv/services.ldif /srv/services.ldif

RUN /usr/sbin/slapadd -F /etc/openldap/slapd.d/ -n 2 -l /srv/services.ldif \
  && chown -R ldap:ldap /var/lib/ldap \
  && rm /srv/services.ldif

EXPOSE 398
CMD /usr/sbin/slapd -u ldap -h "ldap:///" -d 512
