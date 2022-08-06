Facter.add('is_raspberry_pi') do
  confine do
    File.exist? '/sys/firmware/devicetree/base/model'
  end

  setcode do
    File.read('/sys/firmware/devicetree/base/model') =~ /^Raspberry/
  end
end
