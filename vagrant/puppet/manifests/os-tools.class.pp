class os-tools {
    $tools = [ "git", "vim", "curl", "nfs-common", "make", "htop", "g++" ]
    package { $tools:
        ensure => latest,
        require => Exec['apt-update'],
    }
}
