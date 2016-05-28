require 'spec_helper'

describe 'Facter::Util::Fact' do
  before {
    Facter.clear
    allow(File).to receive('file?').at_least(:once).with('/etc/tuned/active_profile').and_return(false)
    allow(Facter::Util::Resolution).to receive(:exec).once.with('tuned-adm active').and_return('Current active profile: foo')
  }

  context 'no active profile' do
    it do
      expect(Facter.fact(:tuned_base_profile).value).to eq 'foo'
      expect(Facter.fact(:tuned_active_profile).value).to eq 'foo'
    end
  end
end
