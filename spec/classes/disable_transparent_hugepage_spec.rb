require 'spec_helper'

describe 'disable_transparent_hugepage' do
  it {
    is_expected.to compile.with_all_deps
  }
end
