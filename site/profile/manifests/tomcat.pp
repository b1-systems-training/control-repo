# Class: profile::tomcat
# deploy tomcat according to company policy
class profile::tomcat(
  $proxy_vhost_name = 'tomcat',
  $proxy_port       = '80',
  $proxy_path       = '/sample',
  $proxy_pass       = 'ajp://localhost:8009/sample',
  $docroot          = '/var/www/html',
  $app_name         = 'sample.war',
  $app_url          = '/vagrant/files/puppet/sample.war',
  $catalina_base    = '/var/lib/tomcat',
  $tomcat_package   = 'tomcat',
  $tomcat_service   = 'tomcat',

) {

  class{'::apache':
    default_vhost => false,
  }
  contain ::apache::mod::proxy_ajp
  contain ::java
  contain ::tomcat

  apache::vhost{$proxy_vhost_name:
    port       => $proxy_port,
    docroot    => $docroot,
    proxy_pass => [
                    { 
                      'path' => $proxy_path,
                      'url'  => $proxy_pass,
                    },
                  ],
  }
    
    

  tomcat::instance { 'default':
    catalina_home       => $catalina_base,
    install_from_source => false,
    package_name        => $tomcat_package,
  } ->
  tomcat::service { 'default':
    use_jsvc     => false,
    use_init     => true,
    service_name => $tomcat_service,
  }
  tomcat::war { $app_name:
    catalina_base => $catalina_base,
    war_source    => $app_url,
  }
}
