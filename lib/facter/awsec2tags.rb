  Facter.add("facter_rus_as") do
    setcode do
      Facter::Core::Execution.exec('whoami')
    end
  end

begin 
  require 'aws-sdk-resources'
  require 'net/http'
  require 'uri'
  require 'json'
  require 'facter'
  require 'inifile'

  #read credentials 
  credfile='/etc/puppetlabs/puppet/.aws/credentials'
  if File.file?(credfile)
    creds = IniFile.load(credfile)
  else 
    credfile='C:\Windows\System32\config\systemprofile\.aws\credentials'
    if File.file?(credfile) 
      creds = IniFile.load(credfile)
    end
  end

  aws_secret_access_key = creds['default']['aws_secret_access_key']
  aws_access_key_id = creds['default']['aws_access_key_id']

  if aws_secret_access_key.to_s.empty? 
    raise("aws_secret_access_key not set") 
  end
  if aws_access_key_id.to_s.empty? 
    raise("aws_access_key_id not set")
  end


  uri = URI.parse("http://169.254.169.254")
  http = Net::HTTP.new(uri.host, uri.port)
  http.open_timeout = 2
  http.read_timeout = 2

  # Get Instance ID to it's own custom fact
  request = Net::HTTP::Get.new("/latest/meta-data/instance-id")
  response = http.request(request)
  instance_id = response.body

  request = Net::HTTP::Get.new("/latest/meta-data/placement/availability-zone")
  response = http.request(request)
  r = response.body
  region = r.match(/.*-.*-[0-9]/)[0]

  request = Net::HTTP::Get.new("latest/meta-data/public-ipv4/")
  response = http.request(request)
  public_ip = response.body

  Aws.use_bundled_cert!
  ec2 = Aws::EC2::Resource.new(region: region, credentials: Aws::Credentials.new(aws_access_key_id, aws_secret_access_key))
# ec2 = Aws::EC2::Resource.new(region: region)
  i = ec2.instance(instance_id)

  Facter.add("ec2_instance_id") do
    setcode do
      instance_id
    end
  end

  Facter.add("ec2_public_ip") do
    setcode do
      public_ip
    end
  end

  Facter.add("ec2_region") do
    setcode do
      region
    end
  end

  if i.exists?
    result = {}

    #flat
    i.tags.each do |tag|
      name = tag.key
      name.downcase
      Facter.add("ec2_tag_#{name}") do
        setcode do
          tag.value
        end   
      end
      result[name]=tag.value
    end

    #structured
    if defined?(result) != nil
      Facter.add(:ec2_tags) do
        setcode do
          result
        end
      end
    end
  end
rescue Exception => e
  Facter.add("ec2_tags_error") do
    setcode do
      "#{e.message} #{e.backtrace.inspect}"
    end
  end
end

