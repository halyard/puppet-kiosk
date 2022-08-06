Facter.add('device_model') do
  setcode do
    return nil unless File.exist? '/sys/firmware/devicetree/base/model'
    File.read('/sys/firmware/devicetree/base/model')
  end
end
