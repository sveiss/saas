#!/usr/bin/env ruby

require 'erb'
require 'net/ldap'
require 'net/ldap/dn'

SERVICES_BLACKLIST = [
  'Mon' # conflicts with 'mon'
]

LDIF_HEADER = <<~EOF
  dn: dc=brokenbottle,dc=net
  objectClass: organization
  objectClass: dcObject
  dc: brokenbottle
  o: brokenbottle

  dn: ou=services,dc=brokenbottle,dc=net
  objectClass: organizationalUnit
  objectClass: top
  ou: services

EOF

LDIF_TEMPLATE = <<~EOF
  dn: cn=<%= Net::LDAP::DN.escape(names[0]) %>+ipServiceProtocol=<%= proto %>,ou=services,dc=brokenbottle,dc=net
  objectClass: ipService
  objectClass: top
  <% names.each do |name| -%>
  cn: <%= Net::LDAP::DN.escape(name) %>
  <% end -%>
  ipServicePort: <%= port %>
  ipServiceProtocol: <%= proto %>

EOF

puts LDIF_HEADER

IO.popen(['/usr/bin/getent', 'services']) do |services|
  services.each do |s|
    (service, portspec, aliases) = s.split(/\s+/, 3)
    (port, proto) = portspec.split('/')

    next if SERVICES_BLACKLIST.include? service

    names = [service] + aliases.split

    puts ERB.new(LDIF_TEMPLATE, 0, '-').result(binding)
  end
end
