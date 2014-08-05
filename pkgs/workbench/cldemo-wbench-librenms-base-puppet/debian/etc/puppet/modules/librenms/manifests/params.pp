class librenms::params {
    $config = {
        'title_image'      => 'url(//upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Wikimedia_Foundation_RGB_logo_with_text.svg/100px-Wikimedia_Foundation_RGB_logo_with_text.svg.png)',

        'db_host'          => 'db1001.eqiad.wmnet',
        'db_user'          => $passwords::librenms::db_user,
        'db_pass'          => $passwords::librenms::db_pass,
        'db_name'          => 'librenms',

        'snmp'             => {
            'community' => [ $passwords::network::snmp_ro_community ],
        },

        'nets'             => $network::constants::external_networks,
        'autodiscovery'    => {
            'xdp'      => true,
            'ospf'     => true,
            'bgp'      => false,
            'snmpscan' => false,
        },

        'enable_inventory' => 1,
        'email_backend'    => 'sendmail',
        'alerts'           => {
            'port_util_alert' => true,
            'port_util_perc'  => 85,
            'email' => {
                'default' => 'noc@wikimedia.org',
                'enable'  => true,
            },
            'port' => {
                'ifdown'  => false,
            },
        },

        'enable_syslog'    => 1,
        'syslog_filter'    => [
            'message repeated',
            'Connection from UDP: [',
            'CMD (   /usr/libexec/atrun)',
            'CMD (newsyslog)',
            'CMD (adjkerntz -a)',
            'kernel time sync enabled',
        ],

        'auth_mechanism'   => 'mysql',
    }
}
