#params for awsec2tags module
class awsec2tags::params {
  $aws_access_key_id = ''
  $aws_secret_access_key = ''

  case $facts['os']['family'] {
    'windows': {
      $gem_bin = '"C:\Program Files\Puppet Labs\Puppet\sys\ruby\bin\gem.bat"'
      $ini_path = 'C:\Windows\System32\config\systemprofile\.aws'
      $ini_file = 'C:\Windows\System32\config\systemprofile\.aws\credentials'
      $grep_cmd = 'find /C'
    }
    'RedHat': {
      $gem_bin = '/opt/puppetlabs/puppet/bin/gem'
      $ini_path = '/etc/puppetlabs/puppet/.aws/'
      $ini_file = '/etc/puppetlabs/puppet/.aws/credentials'
      $grep_cmd = 'grep'
    }
    default: {
      fail("The module ${module_name} is not supported on ${facts['os']['family']}")
    }
  }
}
