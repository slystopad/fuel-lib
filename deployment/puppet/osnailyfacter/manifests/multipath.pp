class osnailyfacter::multipath (
  #$var   = value,
){

        package {'device-mapper-multipath':
          ensure => 'present';
        }

        package {'device-mapper-multipath-libs':
          ensure => 'present';
        }

        ## TODO: add Nova_config ~> Service['nova-api']. What is correct name for service?
        ## should use param.pp to obtain correct service names
        nova_config { 'DEFAULT/iscsi_use_multipath': value => 'true' } ~> Service<| title == 'openstack-nova-api'|>

	file {'multipath.conf':
	   path   =>'/etc/multipath.conf',
	   mode   => '0755',
	   owner  => root,
	   group  => root,
	   source => "puppet:///modules/osnailyfacter/multipath.conf",
	}

        service {'multipathd':
           enable => true,
           ensure => "running",
        }

        Package['device-mapper-multipath'] -> File['multipath.conf']
        Package['device-mapper-multipath-libs'] -> File['multipath.conf']
        File['multipath.conf'] -> Service['multipathd']

}

