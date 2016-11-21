# Class: profile::tomcat
# deploy tomcat according to company policy
class profile::tomcat(
  $app_name      = 'sample.war',
  $app_url       = '/vagrant/files/sample.war',
  $catalina_base = '/opt/tomcat',

) {
  contain ::apache
  contain ::java
  apache::balancer { 'puppet00': }

  apache::balancermember { "${::fqdn}-puppet00":
      balancer_cluster => 'puppet00',
        url            => "ajp://${::fqdn}:8009",
          options      => ['ping=5', 'disablereuse=on', 'retry=5', 'ttl=120'],
  }
  tomcat::install { $catalina_base:
    install_from_source => false,
  }
  tomcat::instance { 'default':
      catalina_home => $catalina_base,
  }
  tomcat::war { $app_name:
    catalina_base => $catalina_base,
    war_source    => $app_url,
  }
}
