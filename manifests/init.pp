# @summary Configure kiosk display
#
# @param urls sets the list of page to display (first is default, others use hotkeys)
# @param username sets the username for the kiosk install
# @param width sets the width of the kiosk window
# @param height sets the height of the kiosk window
# @param navigate_version sets the version to install of the navigate CLI
# @param custom_script sets an alternate script instead of the default navigation hotkey
# @param overscan_top sets the top overscan value in pixels
# @param overscan_bottom sets the bottom overscan value in pixels
# @param overscan_left sets the left overscan value in pixels
# @param overscan_right sets the right overscan value in pixels
class kiosk (
  Array[String, 1, 3] $urls,
  String $username = 'kiosk',
  Integer $width = 3840,
  Integer $height = 2160,
  String $navigate_version = 'v0.0.4',
  Optional[String] $custom_script = undef,
  Optional[Integer] $overscan_top = undef,
  Optional[Integer] $overscan_bottom = undef,
  Optional[Integer] $overscan_left = undef,
  Optional[Integer] $overscan_right = undef,
) {
  package { [
      'chromium',
      'xorg-server',
      'xorg-xinit',
      'xorg-xset',
      'xdotool',
      'xbindkeys',
      'unclutter',
  ]: }

  user { $username:
    ensure     => present,
    home       => "/home/${username}",
    managehome => true,
  }

  file { "/home/${username}/.xinitrc":
    ensure => file,
    source => 'puppet:///modules/kiosk/xinitrc',
    owner  => $username,
  }

  file { "/home/${username}/.xbindkeysrc":
    ensure => file,
    source => 'puppet:///modules/kiosk/xbindkeysrc',
    owner  => $username,
  }

  file { "/home/${username}/.bashrc":
    ensure => file,
    source => 'puppet:///modules/kiosk/bashrc',
    owner  => $username,
  }

  $hotkey_script = $custom_script == nil ? {
    true  => file('kiosk/kiosk_hotkey.sh'),
    false => $custom_script,
  }

  file { "/home/${username}/.kiosk_hotkey.sh":
    ensure  => file,
    content => $hotkey_script,
    mode    => '0755',
    owner   => $username,
  }

  file { "/home/${username}/.kiosk_config":
    ensure  => file,
    content => template('kiosk/kiosk_config.erb'),
    owner   => $username,
  }

  file { '/etc/systemd/system/getty@tty1.service.d':
    ensure => directory,
  }

  file { '/etc/systemd/system/getty@tty1.service.d/autologin.conf':
    ensure  => file,
    content => template('kiosk/autologin.erb'),
  }

  if $facts['is_raspberry_pi'] {
    package { 'xf86-video-fbdev': }

    file { '/boot/config.txt':
      ensure  => file,
      content => template('kiosk/rpi_config.txt'),
    }
  }

  $arch = $facts['os']['architecture'] ? {
    'x86_64'  => 'amd64',
    'arm64'   => 'arm64',
    'aarch64' => 'arm64',
    'arm'     => 'arm',
    default   => 'error',
  }

  $binfile = '/usr/local/bin/navigate'
  $filename = "navigate_${downcase($facts['kernel'])}_${arch}"
  $url = "https://github.com/akerl/navigate/releases/download/${navigate_version}/${filename}"

  exec { 'download navigate':
    command => "/usr/bin/curl -sLo '${binfile}' '${url}' && chmod a+x '${binfile}'",
    unless  => "/usr/bin/test -f ${binfile} && ${binfile} version | grep '${navigate_version}'",
  }
}
