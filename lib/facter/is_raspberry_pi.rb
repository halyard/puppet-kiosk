Facter.add('is_raspberry_pi') do
  setcode do
    Facter::Util::FileRead('/sys/firmware/devicetree/base/model') =~ /^Raspberry/
  end
end
