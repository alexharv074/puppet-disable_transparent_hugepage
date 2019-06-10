require 'spec_helper'

describe 'disable_transparent_hugepage' do
  context 'EL7' do
    let(:facts) {{
      'os' => {'family' => 'RedHat', 'release' => { 'major' => '7', 'minor' => '1', 'full' => '7.1.1503'}},
      'operatingsystem' => 'Linux',
    }}
    it {
      is_expected.to compile.with_all_deps
    }
  end
  context 'Debian' do
    let(:facts) {{
      'os' => {'family' => 'Debian', 'release' => {'major' => '8'}},
      'operatingsystem' => 'Linux',
    }}
    it {
      is_expected.to compile.with_all_deps
    }
  end
end
