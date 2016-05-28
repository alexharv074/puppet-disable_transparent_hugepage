require 'spec_helper'

describe 'disable_transparent_hugepage' do
  let(:facts) {{
    :osfamily                  => 'RedHat',
    :operatingsystemmajrelease => '7',
  }}
  it {
    is_expected.to compile.with_all_deps
  }
end
