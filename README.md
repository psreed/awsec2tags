# awsec2tags

## Description

AWS Tags as Puppet Facts for EC2 Instances.
Does not use the aws cli, only ruby gems.
Supports Windows and Linux

## Setup

Add this repo to your Puppetfile
<pre>
mod 'psreed-awsec2tags',
  :git    => 'https://github.com/psreed/awsec2tags.git',
  :branch => 'master'
</pre>

## Usage

Add this class to your puppet enabled EC2 isntances:
<pre>
include awsec2tags
</pre>

## Limitations

Puppet agent needs to run twice before facts will be available. This is just the way it is since we need things that don't exist to check the tags, but we can't put those things in place before facter plugin sync runs.

First Run: Will install required ruby gems for the facter code to work
Second Run (and consecutive runs): Facter will use the ruby sdk through this plugin to pull EC2 tags and make them available

## Development

I probably will not actively develop this since it works for my needs as is. Feel free to contribute if you like.
I get a lot of github notifications that go into a black hole, so if i don't see a PR, send me an email directly outside of GitHub to paul.reed@puppet.com

## Contributors

Just me (Paul Reed) currently. You can reach me at paul.reed@puppet.com



