require 'spec_helper'

describe 'disable_transparent_hugepage' do
  context 'EL 7' do
    let(:facts) {{
      :osfamily                  => 'RedHat',
      :operatingsystemmajrelease => '7',
      :tuned_base_profile        => 'virtual-guest',
    }}
    it {
      is_expected.to compile.with_all_deps
    }
    it {
      is_expected.to contain_file('/etc/init.d/disable-transparent-hugepage')
      is_expected.to contain_service('disable-transparent-hugepage')
    }
  end

  context 'EL 6' do
    let(:facts) {{
      :osfamily                  => 'RedHat',
      :operatingsystemmajrelease => '6',
    }}
    it {
      is_expected.to compile.with_all_deps
    }
  end
end
