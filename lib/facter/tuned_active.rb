require 'facter'

def get_active_profile
  if File.exists?('/etc/tuned/active_profile') then
    active_profile = File.read('/etc/tuned/active_profile').chomp
  else
    active_output = Facter::Util::Resolution.exec('tuned-adm active')
    if active_output
      active_profile = active_output.chomp.sub('Current active profile: ','')
    else
      'virtual-guest'
    end
  end
end

Facter.add(:tuned_active_profile) do
  confine :kernel => "Linux"
  setcode do
    get_active_profile
  end
end

Facter.add(:tuned_base_profile) do
  confine :kernel => "Linux"
  setcode do
    active_profile = get_active_profile
    base_profile = ""
    if active_profile == "custom" then
      begin
        File.open('/etc/tuned/custom/tuned.conf').each do |line|
          if line.match("include=") then
            base_profile = line.chomp.sub('include=','')
          end
        end
      rescue
        base_profile = 'virtual-guest'
      end
    else
      base_profile = active_profile
    end

    base_profile
  end
end
