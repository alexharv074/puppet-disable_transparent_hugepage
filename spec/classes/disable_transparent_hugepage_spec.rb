require 'spec_helper'

describe 'disable_transparent_hugepage' do
  context 'EL7' do
    let(:facts) {{
      :osfamily                  => 'RedHat',
      :operatingsystemmajrelease => '7',
    }}
    it {
      is_expected.to compile.with_all_deps
    }
  end

  context 'Debian' do
    let(:facts) {{
      :osfamily                  => 'Debian',
      :operatingsystemmajrelease => '8',
    }}
    it {
      is_expected.to compile.with_all_deps
    }
  end
end
