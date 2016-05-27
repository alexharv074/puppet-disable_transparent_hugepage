require 'facter'

def get_active_profile
  begin
    if File.file?('/etc/tuned/active_profile')
      File.read('/etc/tuned/active_profile').chomp
    else
      Facter::Core::Resolution.exec('tuned-adm active').
        chomp.sub('Current active profile: ', '')
    end
  rescue
    'virtual-guest'
  end
end

Facter.add(:tuned_active_profile) do
  confine :kernel => 'Linux'
  setcode do
    get_active_profile()
  end
end

Facter.add(:tuned_base_profile) do
  confine :kernel => 'Linux'
  setcode do
    active_profile = get_active_profile()
    if active_profile == 'custom'
      begin
        File.open('/etc/tuned/custom/tuned.conf').each do |line|
          if line.match('include=')
            line.chomp.sub('include=', '')
          end
        end
      rescue
        'virtual-guest'
      end
    else
      active_profile
    end
  end
end
