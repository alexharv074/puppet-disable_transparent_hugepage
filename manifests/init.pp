# == Class: disable_transparent_hugepage
#
# Disables transparent hugepage according to documentation from
# https://docs.mongodb.org/manual/tutorial/transparent-huge-pages/
#
# === Parameters
#
# [*service_provider*]
#   A feature provided as a workaround to puppet bug PUP-5296.  Defaults to
#   undef.  You need to specify service_provider 'redhat' on RedHat/CentOS 7
#   if you are affected by PUP-5296.
#
class disable_transparent_hugepage (
  $service_provider = undef,
) {
  if $service_provider and ! $service_provider == 'redhat' {
    fail("service_provider can only be set to 'redhat'")
  }

  file { '/etc/init.d/disable-transparent-hugepages':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("${module_name}/disable-transparent-hugepages.erb"),
  }

  service { 'disable-transparent-hugepages':
    ensure   => running,
    enable   => true,
    provider => $service_provider,
  }

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

    File['/etc/tuned/custom/tuned.conf'] -> Exec['enable-tuned-profile']
  }
}
