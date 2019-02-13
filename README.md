# SaaS

A bad idea, taken too far.

Or, the one true SaaS: `/etc/services` as a service!

## Overview

Expanding upon a [joke tweet](https://twitter.com/sveiss/status/1095538449132613633),
I set out to discover if you really could serve /etc/services over LDAP.

A [helpful blog entry](http://karellen.blogspot.com/2011/12/migrating-etcservices-into-ldap.html) showed the schema elements needed, and the rest is proof you just can't take a bad joke too far.

## Obligatory Gratuitous Animated GIF

![GIF of Example](https://s3.amazonaws.com/saas.brokenbottle.net/rec3.gif)

## Example

There's a public server available at ldap://services.brokenbottle.net, built from the [server](server/) directory. (It's running on GKE, because [that's the *-aaS*y way to do it in 2019, right?](https://medium.com/circleci/its-the-future-90d0e5361b44))

There's an example client, too:

```shell
$ docker run sveiss/saas-client getent services http
http                  80/tcp www www-http
```
This gives _exactly the same result_ as executing the command locally (on a Fedora host, at least), but with *Extra Cloud™!*

If you really want to make your own machine talk to this, the [client](client/) directory has what you need.

You can also speak LDAP to the server directly:

```shell
[stephen@drazi:~/hobby/saas]$ ldapsearch -x -H ldap://services.brokenbottle.net \
                                         -b dc=brokenbottle,dc=net cn=http
# extended LDIF
#
# LDAPv3
# base <dc=brokenbottle,dc=net> with scope subtree
# filter: cn=http
# requesting: ALL
#

# http + tcp, services, brokenbottle.net
dn: cn=http+ipServiceProtocol=tcp,ou=services,dc=brokenbottle,dc=net
objectClass: ipService
objectClass: top
cn: http
cn: www
cn: www-http
ipServicePort: 80
ipServiceProtocol: tcp

# http + udp, services, brokenbottle.net
dn: cn=http+ipServiceProtocol=udp,ou=services,dc=brokenbottle,dc=net
objectClass: ipService
objectClass: top
cn: http
cn: www
cn: www-http
ipServicePort: 80
ipServiceProtocol: udp

# http + sctp, services, brokenbottle.net
dn: cn=http+ipServiceProtocol=sctp,ou=services,dc=brokenbottle,dc=net
objectClass: ipService
objectClass: top
cn: http
ipServicePort: 80
ipServiceProtocol: sctp

# search result
search: 2
result: 0 Success

# numResponses: 4
# numEntries: 3
```

Yes, we even have HTTP over both SCTP and UDP covered!

## Acknowledgements

Thanks to [Nik Ogura](https://github.com/nikogura/), who's recent LDAP digging at work gave me sufficient context to bash this out in an evening of poor decisions, and to [Ian Connolly](https://twitter.com/IanConnolly) for providing the inspiration by tweeting his frustrations!
