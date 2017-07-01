# Vagrant-test-env
Simple Vagrant test environment based on Puppet 3.x and VirtualBox.
My purpose is create an environment to test my Puppet modules on different OS flavours without implementing a Puppet Master server.


### Requirements
The following applications must already be installed:

* [VirtualBox package](https://www.virtualbox.org/) (5.1)
* [Vagrant](https://www.vagrantup.com/) (1.9.5)
* one or more Vagrant images (see installing section)

If your are using Windows also [Cygwin](http://www.cygwin.com) is required.


### Installing
Clone the project:

```
$ git clone https://github.com/PeppeLR/vagrant-test-env.git
```

For my purpose, I downloaded two box images with Puppet 3.x preinstalled from [Vagrantbox.es](http://Vagrantbox.es) using the follow commands:

```
$ vagrant box add CentOS66 https://github.com/tommy-muehle/puppet-vagrant-boxes/releases/download/1.0.0/centos-6.6-x86_64.box
$ vagrant box add CentOS7  https://github.com/tommy-muehle/puppet-vagrant-boxes/releases/download/1.1.0/centos-7.0-x86_64.box
```

you can use the images that you prefer, just add them using the same names (CentOS66 & CentOS7) or edit the `vm.box` field on `Vagrantfile` file under *example**x*** directory.


## Getting Started

After cloning the repo, the project structure would look like the following:

```
├── example1
│   └── Vagrantfile
├── example2
│   ├── scripts
│   │   ├── CentOS6.sh
│   │   └── CentOS7.sh
│   └── Vagrantfile
├── LICENSE.md
├── puppet
│   ├── manifests
│   │   └── default.pp
│   └── modules
│       └── dummy
└── README.md
```

I build the following test environments:

* Example1 (Single VM)
* Example2 (2 VMs)

During the deploy phase the Puppet Manifest below is applied on each VM.

*puppet/manifests/default.pp*
```
# Puppet catalog applied by Vagrant during the deploy task

Package {
  allow_virtual => true
}

# ad-hoc code
exec { "echo PuppetRulez.... >>/etc/motd":
  path => "/bin",
}

# Puppet module
include dummy
```

Basically, there are 2 sections:

1. Ad-hoc code:   it appends a string to the motd file 
2. Puppet Module: it run a [Dummy](https://github.com/stbenjam/puppet-dummy) puppet module deployed by [stbenjam](https://github.com/stbenjam) that create a file called ```dummy``` under ```/tmp```.

If you need to test/add a Puppet module:

1. Copy the module on ```./puppet/modules/``` 
2. Add ```include *PuppetModuleName*``` into the manifest file above


### Example1 (Single VM running CentOS 6)
Vagrant deployes a CentOS 6 VM and applies the Puppet catalog on it

 Box |     OS     | Hostname (FQDN)
-----|------------| -------------
CentOS66|CentOS 6 | test01.virtual

*Vagrantfile*
```
Vagrant.configure("2") do |config|
  config.vm.box = "CentOS66"
  config.vm.hostname = "test01.virtual"
  config.vm.network "forwarded_port",guest: 22, host: 2200, host_ip: "127.0.0.1", auto_correct: true
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  # Upgrade the VM on the latest minor release
  #config.vm.provision "shell", inline: "/usr/bin/yum -y update --nogpgcheck"

  # Set en language
  config.vm.provision "shell", inline: "/bin/sed -i 's/LANG.*/LANG=en_US.UTF-8/'/etc/sysconfig/i18n"

  # set up Puppet
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "../puppet/manifests"
    puppet.module_path = "../puppet/modules/"
    puppet.options = ['--verbose']
  end
end
```

In order to start the VM:
```
$ cd example1
$ vagrant up
```

check the VM status:
```
$ vagrant status
```

now, you can connect on it by:
```
$ vagrant ssh
```

If the puppet catalog was applied as well. you should see *"PuppetRulez.... "* on the *motd* and a file called */tmp/dummy* should exist.

Now, you can destroy the VM by:
```
$ vagrant ssh destroy
```

or shutdown it by:
```
$ vagrant ssh halt
```

After the deploy, If you change something on the Puppet manifest, you can apply it without destroy and recreate the VM by:
```
$ vagrant up --provision
```


### Example2 (Multi machines environment)
it's based on 2 different VMs:

 Box |     OS     | Hostname (FQDN)
-----|------------| -------------
box1 |CentOS 6.6 | centos6.virtual
box2 |CentOS 7.1 | centos7.virtual


*Vagrantfile*
```
Vagrant.configure("2") do |config|
  # Deploy box1: a CentOS 6.6 VM
  config.vm.define "box1" do |box1|
     box1.vm.box = "CentOS66"
     box1.vm.hostname = "centos6.virtual"
     box1.vm.provision "shell", path: "./scripts/CentOS6.sh"
  end

  # Deploy box2: a CentOS 7 VM
  config.vm.define "box2" do |box2|
    box2.vm.box = "CentOS7"
    box2.vm.hostname = "centos7.virtual"
    box2.vm.provision "shell", path: "./scripts/CentOS7.sh"
  end

  # configure the Puppet env for both VMs
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "../puppet/manifests"
    puppet.module_path = "../puppet/modules/"
    puppet.options = ['--verbose']
  end

end
```

As you can see, Vagrantfile doesn't contain any shell command, each command was moved on a specific provision script under *./script* 

Running "
```
$ vagrant status
``` 
two VMs will be displayed.

You can use the same commands on example1 specifying the VM if necessary.
On example, you can connect to box2 by:

```
$ vagrant ssh box2
```


## Contributing

If you want to submit pull requests to us, please contact me by email.


## Versioning
0.1.0 30/06/2017


## Authors

**PeppeLR** - *Initial work* - [PeppeLR](https://github.com/PeppeLR)


## License

This project is licensed under the  GNU GENERAL PUBLIC LICENSE Version 3 License - see the [LICENSE.md](LICENSE.md) file for details
