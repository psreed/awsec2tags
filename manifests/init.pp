# Class: awsec2tags
# ===========================
#
# Another AWS EC2 Tags Module.
# This one doesn't use the aws cli however, and only relys on ruby gems.
# Currently supports Windows and Linux
# Tested on Windows 2012 R2, RHEL7 and CentOS7
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'awsec2tags':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class awsec2tags (
  $aws_access_key_id = $awsec2tags::params::aws_access_key_id,
  $aws_secret_access_key = $awsec2tags::params::aws_secret_access_key,
  $gem_bin = $awsec2tags::params::gem_bin,
) inherits awsec2tags::params {
  case $facts['os']['family'] {
    'windows': {
      exec { "${gem_bin} install retries":
        unless => "${gem_bin} list | find /C \"retries\"",
      }
      exec { "${gem_bin} install aws-sdk-core":
        unless => "${gem_bin} list | find /C \"aws-sdk-core\"",
      }
      exec { "${gem_bin} install aws-sdk-resources":
        unless => "${gem_bin} list | find /C \"aws-sdk-resources\"",
      }
      exec { "${gem_bin} install inifile":
        unless => "${gem_bin} list | find /C \"inifile\"",
      }

    }
    'RedHat': {
      exec { "${gem_bin} install retries":
        unless => "${gem_bin} list | grep retries",
      }
      exec { "${gem_bin} install aws-sdk-core":
        unless => "${gem_bin} list | grep aws-sdk-core",
      }
      exec { "${gem_bin} install aws-sdk-resources":
        unless => "${gem_bin} list | grep aws-sdk-resources",
      }
      exec { "${gem_bin} install inifile":
        unless => "${gem_bin} list | grep inifile",
      }
    }
  }

  file { "${ini_path}":
    ensure  => directory,
    recurse => true,
  } ->
  file { "${ini_file}":
    ensure => file,
    content => "[default]
aws_access_key_id = ${aws_access_key_id}
aws_secret_access_key = ${aws_secret_access_key}
"
  }
}
