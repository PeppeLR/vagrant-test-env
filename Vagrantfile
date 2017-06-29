Vagrant.configure("2") do |config|
  config.vm.box = "CenOS66"
  config.vm.hostname = "test01.virtual"
  config.vm.network "forwarded_port", guest: 22, host: 2200, host_ip: "127.0.0.1", auto_correct: true

  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  #config.vm.provision "shell", inline: "/usr/bin/yum -y update --nogpgcheck"
  config.vm.provision "shell", inline: "/bin/sed -i 's/LANG.*/LANG=en_US.UTF-8/' /etc/sysconfig/i18n"
  
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules/"
    #Puppet 3 puppet.options = ['--verbose','--parser future']
    puppet.options = ['--verbose']
  end

end
