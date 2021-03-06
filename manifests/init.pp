 # This class installs Google language GO.

class golang (

  $manage_dependencies = $golang::params::manage_dependencies,
  $from_source         = $golang::params::from_source,
  $base_dir            = $golang::params::base_dir,
  $source_version      = $golang::params::version,
  $package_version     = $golang::params::package_version,
  $goroot              = $golang::params::goroot,
  $workdir             = $golang::params::workdir,

) inherits golang::params {

validate_re($::osfamily,
  '^(Debian|RedHat)$',
  'This module only works on Debian and Red Hat based systems.')
validate_bool($manage_dependencies)

if $manage_dependencies {
    class {'golang::packages':}->
    class {'golang::install':}
    contain 'golang::install'
    }

else {
    class {'golang::install':}
    }
  }
