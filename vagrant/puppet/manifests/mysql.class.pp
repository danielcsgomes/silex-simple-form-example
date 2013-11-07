class mysql {
  $mysqlpackages = [ "mysql-client", "mysql-server" ]
  package { $mysqlpackages:
    ensure => present,
    require => Exec["apt-update"],
  }

  service { "mysql":
    ensure => "running",
    require => Package["mysql-server"],
    notify => Exec['set-root-password'],
  }

  exec { "set-root-password":
    unless => "/usr/bin/mysqladmin -uroot -p12345 status",
    command => "mysqladmin -u root password 12345",
    path    => ["/usr/bin"],
    require => Service["mysql"],
  }

  exec { "set-mysql-user":
    unless => "/usr/bin/mysqladmin -uvagrant -p12345 status",
    command => "mysql -u root -p12345 -e \"CREATE USER 'vagrant'@'localhost' IDENTIFIED BY '12345';GRANT ALL PRIVILEGES ON *.* TO 'vagrant'@'localhost' WITH GRANT OPTION;CREATE USER 'vagrant'@'%' IDENTIFIED BY '12345';GRANT ALL PRIVILEGES ON *.* TO 'vagrant'@'%' WITH GRANT OPTION;GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '12345' WITH GRANT OPTION;FLUSH PRIVILEGES;\"",
    path    => ["/usr/bin"],
    require => [ Service["mysql"], Exec['set-root-password'] ],
  }

  file { "my.cnf":
    path => "/etc/my.cnf",
    ensure => file,
    owner => 'root',
    group => 'root',
    content => template('default/mysql.conf'),
    require => Package["mysql-server"],
    notify => Service["mysql"],
  }
}

