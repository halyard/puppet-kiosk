Facter.add('device_model') do
  setcode do
    Facter::Util::FileRead('/sys/firmware/devicetree/base/model')
  end
end
