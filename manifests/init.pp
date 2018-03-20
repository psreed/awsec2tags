# Class: awsec2tags
# ===========================
#
# Another AWS EC2 Tags Module.
# This one doesn't use the aws cli however, and only relys on ruby gems.
# Currently supports Windows and Linux
# Tested on Windows 2012 R2, RHEL7 and CentOS7
#
# Authors
# -------
#
# Paul Reed <paul.reed@puppet.com>
#
# Copyright
# ---------
#
# Copyright 2018 Paul Reed, unless otherwise noted.
#
class awsec2tags (
  $aws_access_key_id = $awsec2tags::params::aws_access_key_id,
  $aws_secret_access_key = $awsec2tags::params::aws_secret_access_key,
  $gem_bin = $awsec2tags::params::gem_bin,
  $grep_cmd = $awsec2tags::params::grep_cmd,
  $clean_up_aws_gems = $awsec2tags::params::clean_up_aws_gems,
) inherits awsec2tags::params {

  if $clean_up_aws_gems == true {
    if $facts['os']['family'] != 'windows' {
      exec { "${gem_bin} list aws-sdk* | cut -d\" \" -f1 | xargs ${gem_bin} uninstall -aIx":
        before => File[$awsec2tags::ini_file],
      }
    }
    if $facts['os']['family'] == 'windows' {
      $pshell = 'C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoProfile -NoLogo -NonInteractive'
      file { "${facts['env_temp_variable']}\\aws_sdk_gem_clean.ps1":
        ensure  => present,
        content => "& ${gem_bin} list aws-sdk* | ForEach-Object {\n  if (\$_ -like \"aws-sdk*\") {\n    & ${gem_bin} uninstall -aIx \$_.split(\" \")[0]\n  }\n}", #lint:ignore:140chars
      }
      -> exec { "${pshell} ${facts['env_temp_variable']}\\aws_sdk_gem_clean.ps1":
        logoutput => true,
        before    => File[$awsec2tags::ini_file],
      }
    }
  }

  ['retries','0.0.5','aws-sdk','2.11.17'].slice(2) |String $gem, String $ver| {
    exec { "${gem_bin} install ${gem} -v '${ver}'":
      unless  => "${gem_bin} list | ${grep_cmd} \"${gem} \"",
      require => File[$awsec2tags::ini_file],
    }
  }

  file { $awsec2tags::ini_path:
    ensure  => directory,
    recurse => true,
  }
  -> file { $awsec2tags::ini_file:
    ensure  => file,
    content => "[default]\naws_access_key_id = ${aws_access_key_id}\naws_secret_access_key = ${aws_secret_access_key}\n"
  }
}
