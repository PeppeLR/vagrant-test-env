require 'spec_helper'
describe 'dummy' do

  context 'with defaults for all parameters' do
    it { should contain_class('dummy') }
  end
end
