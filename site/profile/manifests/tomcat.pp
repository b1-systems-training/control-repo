# Class: profile::tomcat
# deploy tomcat according to company policy
class profile::tomcat(
  $app_name       = 'sample.war',
  $app_url        = '/vagrant/files/puppet/sample.war',
  $catalina_base  = '/var/lib/tomcat',
  $tomcat_package = 'tomcat',
  $tomcat_service = 'tomcat',

) {
  contain ::apache
  contain ::java
  contain ::tomcat
  apache::balancer { 'puppet00': }

  apache::balancermember { "${::fqdn}-puppet00":
    balancer_cluster => 'puppet00',
    url              => "ajp://${::fqdn}:8009",
    options          => ['ping=5', 'disablereuse=on', 'retry=5', 'ttl=120'],
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
