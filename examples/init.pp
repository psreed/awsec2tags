# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# https://docs.puppet.com/guides/tests_smoke.html
#
include ::awsec2tags

#ec2_instance { "myinstnace.example.com":
#  ensure               => present,
#  region               => "us-west-2",
#  availability_zone    => "us-west-2a",
#  image_id             => "ami-id",
#  instance_type        => "t2.small",
#  key_name             => "your-key-name",
#  security_groups      => ['standard-access'],
#  tags                 =>  {
#    "created_by"       => "paul.reed",
#    "department"       => "tse",
#    "project"          => "AWS Customer Demos & Testing",
#  },
#  user_data            => epp('awsec2tags/user-data.epp', {
#    'puppet_master'    => 'master.example.com',
#    'agent_certname'   => 'mynewclient.example.com',
#    'os_type'          => 'Linux or Windows',
#    'pp_preshared_key' => 'key, if using autosign',
#    'pp_cloudplatform' => 'aws',
#    'pp_role'          => 'role::my-role-for-this-host',
#  }),
#}
