# HA configuration for LDAP server which lives on controller and populated by scripts
# from parent LDAP server
class openstack::ha::ldap {

  openstack::ha::haproxy_service { 'ldap':
    order           => '389',
    listen_port     => 389,
    public          => false,
    #require_service => 'slapd',
    mode            => 'tcp',
    haproxy_config_options => {
      'option'  => ['socket-stats', 'tcpka'],
      'timeout' => ['client 5s', 'server 2s', 'connect 1s'],
    },
    
    balancermember_options => 'check fall 1 rise 1 inter 2s',
  }

  firewall {'389 LDAP for keystone':
    port   => 389,
    proto  => 'tcp',
    action => 'accept',
  }

}
