# Puppet catalog applied by Vagrant during the deploy task

Package {
  allow_virtual => true
}

# ad hoc code
exec { "echo PuppetRulez.... >>/etc/motd":
  path => "/bin",
}

# Puppet module 
include dummy
