class osnailyfacter::cinder_netapp2 (
  $netapp_cfg   = $::fuel_settings['netapp']
){

        class {'osnailyfacter::multipath':}

        package {'iscsi-initiator-utils.x86_64':
          ensure => 'present';
        } ->
        #osnailyfacter::cinder::backend::netapp {'netapp':
        osnailyfacter::cinder_netapp::netapp {'DEFAULT':
           netapp_login => $netapp_cfg['netapp_login'],
           netapp_password => $netapp_cfg['netapp_password'],
           netapp_server_hostname => $netapp_cfg['netapp_server_hostname'],
           netapp_server_port => $netapp_cfg['netapp_server_port'],
           netapp_storage_family => 'eseries',
           netapp_storage_protocol => 'iscsi',
           netapp_transport_type => 'https',
           netapp_controller_ips => $netapp_cfg['netapp_controller_ips'],
           netapp_storage_pools => $netapp_cfg['netapp_storage_pools'],
           use_multipath_for_image_xfer => 'True',
        }
}

