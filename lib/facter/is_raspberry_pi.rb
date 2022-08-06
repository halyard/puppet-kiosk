Facter.add('is_raspberry_pi') do
  setcode do
    return false unless File.exist? '/sys/firmware/devicetree/base/model'
    File.read('/sys/firmware/devicetree/base/model') =~ /^Raspberry/
  end
end
