Facter.add('is_raspberry_pi') do
  setcode do
    File.read('/sys/firmware/devicetree/base/model') =~ /^Raspberry/
  end
end
