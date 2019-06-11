# @summary Disables transparent hugepage according to MongoDB project.
#
# @example Basic usage
#   include disable_transparent_hugepage
#
# @see https://docs.mongodb.org/manual/tutorial/transparent-huge-pages/
#
class disable_transparent_hugepage {

  file { '/etc/init.d/disable-transparent-hugepage':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("$module_name/disable-transparent-hugepage.erb"),
    before  => Service['disable-transparent-hugepage'],
  }

  service { 'disable-transparent-hugepage':
    ensure   => running,
    enable   => true,
  }

  $family = $facts['os']['family']
  $major  = $facts['os']['release']['major']

  if ($family == 'RedHat') {

    package { 'tuned':
      ensure => installed,
      before => Exec['enable-tuned-profile'],
    }

    $profile_name = 'custom'

    case $major {
      '7': {
        file { "/etc/tuned/$profile_name":
          ensure => directory,
        }

        file { "/etc/tuned/$profile_name/tuned.conf":
          ensure  => file,
          content => template("$module_name/el7/tuned.conf.erb"),
          before  => Exec['enable-tuned-profile'],
        }
      }
      '6': {
        file { "/etc/tune-profiles/$profile_name":
          ensure => directory,
        }

        ['sysctl.ktune','sysctl.s390x.ktune','ktune.sysconfig','tuned.conf'].each |$file| {
          file { "/etc/tune-profiles/$file":
            ensure  => file,
            content => template("$module_name/el6/$file.erb"),
            before  => Exec['enable-tuned-profile'],
          }
        }
      }
      default: {
        fail("Unsupported OS ${facts['os']}")
      }
    }

    exec { 'enable-tuned-profile':
      command => "tuned-adm profile $profile_name",
      unless  => 'tuned-adm active | grep -q custom',
      path    => '/bin:/sbin:/usr/bin',
    }
  }
}
