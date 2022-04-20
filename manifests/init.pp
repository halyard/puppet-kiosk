# @summary Configure kiosk display
#
# @param url sets the page to display
# @param username sets the username for the kiosk install
# @param hdmi_mode sets the HDMI resolution for the display
# @param hdmi_rpi4 enables 4k60 for the RPi4
class kiosk (
  String $url,
  String $username = 'kiosk',
  String $hdmi_mode = '97',
  Boolean $hdmi_rpi4 = true,
  String $resolution = '3840 2160',
) {
  package { [
      'firefox',
      'xorg-server',
      'xorg-xinit',
      'xdotool',
  ]: }

  user { $username:
    ensure     => present,
    home       => "/home/${username}",
    managehome => true,
  }

  file { "/home/${username}/.xinitrc":
    ensure  => file,
    content => template('kiosk/xinitrc.erb'),
    owner   => $username,
  }

  file { "/home/${username}/.bashrc":
    ensure => file,
    source => 'puppet:///modules/kiosk/bashrc',
    owner  => $username,
  }

  file { '/etc/systemd/system/getty@tty1.service.d':
    ensure => directory,
  }

  file { '/etc/systemd/system/getty@tty1.service.d/autologin.conf':
    ensure  => file,
    content => template('kiosk/autologin.erb'),
  }

  file { '/boot/config.txt':
    ensure  => file,
    content => template('kiosk/config.txt.erb'),
  }
}
