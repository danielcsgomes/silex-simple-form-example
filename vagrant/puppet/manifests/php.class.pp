class php {
  exec { "ondrej-php54-repository":
    unless => "apt-key list | grep -i ond",
    command => "sudo apt-add-repository ppa:ondrej/php5-oldstable -y",
    path => ["/bin", "/usr/bin"],
    require => Package["python-software-properties"],
    notify => Exec["apt-update"],
  }

  $phppackages = [ "php5-cli", "php5-dev", "php5-xdebug", "php5-intl", "php5-sqlite", "php-pear" ]
  package { $phppackages:
    ensure => latest,
    require => [
      Exec["apt-update", "ondrej-php54-repository"],
      Package["libapache2-mod-php5"]
    ],
    notify => Service["apache2"],
  }

  package { "php5-mysql":
    ensure => latest,
    require => [
      Exec["apt-update", "ondrej-php54-repository"],
      Package["mysql-client"]
    ],
  }

  file { "php-timezone.ini":
    path => "/etc/php5/cli/conf.d/30-timezone.ini",
    ensure => file,
    content => template('default/timezone.ini'),
    require => Package["php5-cli"],
    notify => Service["apache2"],
  }

  file { "xdebug-conf.ini":
    path => "/etc/php5/cli/conf.d/40-xdebug.ini",
    ensure => file,
    content => template('default/xdebug-conf.ini'),
    require => Package["php5-cli"],
    notify => Service["apache2"],
  }
}
