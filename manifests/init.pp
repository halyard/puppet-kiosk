# @summary Configure kiosk display
#
# @param url sets the page to display
# @param username sets the username for the kiosk install
class kiosk (
  String $url,
  String $username = 'kiosk',
) {
  package { [
      'firefox',
      'xorg-server',
      'xorg-xinit',
      'xorg-xrandr',
      'xdotool',
      'xf86-video-vesa',
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
}
