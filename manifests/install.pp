# This manifest builds Golang
class golang::install inherits golang::params {

  validate_bool($golang::from_source)

  if $golang::from_source {

    vcsrepo { $golang::base_dir:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/golang/go.git',
    revision => 'master',
    before   => [Exec['make GO'], Exec['checkout go']]
    }

    exec { 'checkout go':
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    command => "git checkout ${golang::source_version}",
    cwd     => '/usr/local/go/',
    before  => Exec['make GO'],
    creates => '/etc/profile.d/golang.sh'
    }


    exec { 'make GO':
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    cwd     => '/usr/local/go/src/',
    command => 'sh -c ./all.bash',
    creates => '/etc/profile.d/golang.sh',
    tries   => 3,
    timeout => 600,
    before  => File['/etc/profile.d/golang.sh']
    }
  }

  else {

    if $::operatingsystem == 'OracleLinux' {
      package { 'yum-utils':
        ensure => present
      } ->

      exec { 'enable repo':
        command => 'yum-config-manager --enable ol7_optional_latest',
        path    => '/usr/bin',
        creates => '/var/run/.optional_on'
      } ->

      file { '/var/run/.optional_on':
        ensure => present,
        content => '-'
      } ->

      package { 'golang':
        ensure => $golang::package_version,
      }

    }else {
      package { 'golang':
        ensure => $golang::package_version,
      }
    }




    file { [$golang::base_dir, "${$golang::base_dir}/src"]:
    ensure => directory,
    }
  }

  file { '/etc/profile.d/golang.sh':
  ensure  => present,
  content => template('golang/golang.sh.erb'),
  owner   => root,
  group   => root,
  mode    => 'a+x',
  }
}
