require 'spec_helper'
describe 'awsec2tags' do
  context 'with default values for all parameters' do
    it { should contain_class('awsec2tags') }
  end
end
