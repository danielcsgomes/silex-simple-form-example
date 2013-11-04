# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

vconfig = YAML::load_file("./Vagrantconfig.yml")

Vagrant.configure("2") do |config|
    config.vm.box = "dummy"

    config.vm.provider :aws do |aws, override|
        aws.access_key_id = vconfig['aws']['access_key_id']
        aws.secret_access_key = vconfig['aws']['secret_access_key']
        aws.keypair_name = vconfig['aws']['keypair_name']
        aws.region = vconfig['aws']['region']
        aws.security_groups = vconfig['aws']['security_groups']
        aws.instance_type = vconfig['aws']['instance_type']

        aws.ami = vconfig['aws']['ami']

        override.ssh.username = vconfig['aws']['ssh_username']
        override.ssh.private_key_path = vconfig['aws']['ssh_private_key_path']
    end

    config.vm.provision :puppet do |puppet|
        puppet.module_path = "vagrant/puppet/modules"
        puppet.manifests_path = "vagrant/puppet/manifests"
        puppet.manifest_file  = "main.pp"
        puppet.options = [
            '--verbose',
            #'--debug',
        ]
    end
end
