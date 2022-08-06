Facter.add('device_model') do
  confine do
    File.exist? '/sys/firmware/devicetree/base/model'
  end

  setcode do
    File.read('/sys/firmware/devicetree/base/model')
  end
end
