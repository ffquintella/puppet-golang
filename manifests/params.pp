# This is the params class
class golang::params {

  $manage_dependencies = true

  if $::os::id == 'OracleServer' {
    $from_source         = true
  }else{
    $from_source         = false
  }

  validate_bool($from_source)

  if ($from_source) {
    $base_dir        = '/usr/local/go'
    $source_version  = 'go1.4.2'
    $goroot          = '$GOPATH/bin:/usr/local/go/bin:$PATH'
    $workdir         = '/usr/local/'
    }

  else {
  $base_dir        = '/usr/local/go'
  $package_version = 'present'
  $goroot          = '$GOPATH/bin:$PATH'
  $workdir         = '/usr/local/go'
  }
}
