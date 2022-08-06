Facter.add('device_model') do
  setcode do
    File.read('/sys/firmware/devicetree/base/model')
  end
end
