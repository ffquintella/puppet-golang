# This controls the package dependdencies that Golang needs.
# This is controlled by the
# $manage_dependencies param being set to true or false

class golang::packages {

  if(!defined(Package['gcc'])){
    package { 'gcc':
      ensure => installed,
    }
  }


  case $::osfamily {

  'RedHat': {

    package { 'glibc-devel':
      ensure => installed,
      require => Package['gcc']
    }
  }

  'Debian': {

    package {'libc6-dev':
      ensure => installed,
      require => Package['gcc']
    }

    package {'bison':
      ensure => installed,
      require => [Package['gcc'],Package['libc6-dev']]
    }

    package {'make':
      ensure => installed,
      require => [Package['gcc'], Package['libc6-dev'], Package['bison']]
    }

    package {'build-essential':
      ensure => installed,
      require => [Package['gcc'], Package['libc6-dev'], Package['bison'], Package['make']]
    }
  }

  default: { notify {"${::osfamily} is not supported by this module":}
    }
  }
}
