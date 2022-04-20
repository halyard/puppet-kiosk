# @summary Configure kiosk display
#
# @param url sets the page to display
# @param username sets the username for the kiosk install
# @param resolution sets the screen size for the kiosk
class kiosk (
  String $url,
  String $username = 'kiosk',
  String $resolution = '3840 2160',
) {
  package { [
      'firefox',
      'xorg-server',
      'xorg-xinit',
      'xorg-xset'
      'xdotool',
      'xf86-video-fbdev',
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
