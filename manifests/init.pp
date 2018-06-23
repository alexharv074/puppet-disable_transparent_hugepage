# == Class: disable_transparent_hugepage
#
# Disables transparent hugepage according to documentation from
# https://docs.mongodb.org/manual/tutorial/transparent-huge-pages/
#
class disable_transparent_hugepage {

  file { '/etc/init.d/disable-transparent-hugepage':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("${module_name}/disable-transparent-hugepage.erb"),
  }

  service { 'disable-transparent-hugepage':
    ensure   => running,
    enable   => true,
  }

  File['/etc/init.d/disable-transparent-hugepage']
  ->
  Service['disable-transparent-hugepage']

  if ($::osfamily == 'RedHat') and
    (versioncmp($::operatingsystemmajrelease, '6') >= 0) {

    file { '/etc/tuned/custom':
      ensure => directory,
    }

    file { '/etc/tuned/custom/tuned.conf':
      ensure  => file,
      content => template("${module_name}/tuned.conf.erb"),
    }

    exec { 'enable-tuned-profile':
      command => '/sbin/tuned-adm profile custom',
      unless  => '/sbin/tuned-adm active | grep -q "custom"',
    }

    File['/etc/tuned/custom/tuned.conf']
    ->
    Exec['enable-tuned-profile']
  }
}
