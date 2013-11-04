class apt {
      exec { "apt-update":
        command => "apt-get update -y",
        path => ["/bin", "/usr/bin"],
    }
}
