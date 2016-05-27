require "spec_helper"

describe Facter::Util::Fact do
  before {
    Facter.clear
  }

  describe 'tuned_active_profile' do
    context 'returns file content of /etc/tuned/active_profile when present' do
      before do
        Facter.fact(:kernel).stubs(:value).returns("Linux")
        File.stubs(:exists?)
        File.stubs(:read)
        File.expects(:exists?).with('/etc/tuned/active_profile').returns(true)
        Facter::Util::Resolution.stubs(:exec)
      end
      it do
        active_profile_output = <<-EOS
custom
        EOS
        File.expects(:read).with('/etc/tuned/active_profile').returns(active_profile_output)
        expect(Facter.value(:tuned_active_profile)).to eq('custom')
      end
    end

    context 'returns response of tuned-adm active when avaliable' do
      before do
        Facter.fact(:kernel).stubs(:value).returns("Linux")
        File.stubs(:exists?)
        File.stubs(:read)
        File.expects(:exists?).with('/etc/tuned/active_profile').returns(false)
        Facter::Util::Resolution.stubs(:exec)
      end
      it do
        active_profile_output = <<-EOS
Current active profile: custom
        EOS
        Facter::Util::Resolution.expects(:exec).with('tuned-adm active').returns(active_profile_output)
        expect(Facter.value(:tuned_active_profile)).to eq('custom')
      end
    end

    context 'returns virtual-guest if all else fails' do
      before do
        Facter.fact(:kernel).stubs(:value).returns("Linux")
        File.stubs(:exists?)
        File.stubs(:read)
        File.expects(:exists?).with('/etc/tuned/active_profile').returns(false)
        File.expects(:exists?).with('/proc/cpuinfo').returns(false)
        Facter::Util::Resolution.stubs(:exec)
      end
      it do
        active_profile_output = <<-EOS
Current active profile: custom
        EOS
        Facter::Util::Resolution.expects(:exec).with('tuned-adm active').returns(nil)
        expect(Facter.value(:tuned_active_profile)).to eq('virtual-guest')
      end
    end
  end

end
