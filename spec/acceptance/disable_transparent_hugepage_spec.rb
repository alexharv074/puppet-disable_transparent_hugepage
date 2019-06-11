require 'spec_helper_acceptance'

describe 'disable_transparent_hugepage' do
  it 'should apply and be idempotent' do
    pp = 'include disable_transparent_hugepage'
    
    apply_manifest pp, :catch_failures => true
    expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
  end

  describe command('cat /sys/kernel/mm/*transparent_hugepage/enabled') do
    its(:stdout) { is_expected.to match /never/ }
  end

  describe command('cat /sys/kernel/mm/*transparent_hugepage/defrag') do
    its(:stdout) { is_expected.to match /never/ }
  end
end
