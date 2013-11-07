class os-tools {
    $tools = [ "git", "vim", "curl", "nfs-common", "make", "htop", "g++", "python-software-properties" ]
    package { $tools:
        ensure => latest,
        before => Exec['apt-update'],
    }
}
