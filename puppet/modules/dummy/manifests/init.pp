# == Class: dummy
#
# This is a dummy module that generates a simple file in /tmp/dummy.
# Used for testing.
#
# === Parameters
#
# $path::       Override the path for the file
#               default: /tmp/dummy
#
# $content::    Content for the module
#               default: 'Lorem ipsum dolor sit amet\n'
#
# === Authors
#
# Stephen Benjamin <stephen@redhat.com>
#
# === Copyright
#
# Copyright 2014 Stephen Benjamin
#
class dummy($path    = '/tmp/dummy',
            $content = 'Lorem ipsum dolor sit amet\n') {

  file { $path:
    ensure  => present,
    mode    => '0777',
    content => $content, 
  }

}
