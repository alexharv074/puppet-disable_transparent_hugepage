require 'spec_helper'

describe 'disable_transparent_hugepage' do
  let(:facts) {{
    :osfamily                  => 'RedHat',
    :operatingsystemmajrelease => '7',
    :tuned_base_profile        => 'virtual-guest',
  }}
  it {
    is_expected.to compile.with_all_deps
  }
end
