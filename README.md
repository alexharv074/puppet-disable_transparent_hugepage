# disable_transparent_hugepage

[![Build Status](https://img.shields.io/travis/alexharv074/puppet-disable_transparent_hugepage.svg)](https://travis-ci.org/alexharv074/puppet-disable_transparent_hugepage)

##Overview

This module disables Transparent Hugepages (THP) on Linux platforms as required by applications such as MongoDB and Redis.  The procedure is based on recommendations published at [mongodb.org](https://docs.mongodb.org/manual/tutorial/transparent-huge-pages/).

The module changes the `/sys/kernel/mm/transparent_hugepage/enabled` and `/sys/kernel/mm/transparent_hugepage/defrag` settings, adds an init service to ensure the changes persist across reboots, and if applicable, configures tuned.

##Usage

Basic use:

```puppet
include disable_transparent_hugepage
```

##Known issues

This module has not been designed to interact with any of the known `tuned` modules and it could cause problems.  The assumption is that your provisioning system delivered a default `tuned` config, and this module adds a custom profile.

Also, as a result of Puppet bug [PUP-5296](https://tickets.puppetlabs.com/browse/PUP-5296) (fixed in Puppet 4.5.0) it will be necessary for affected users to set the service provider to 'redhat'.  To do that pass the `service_provider` parameter:

```puppet
class { 'disable_transparent_hugepage':
  service_provider => 'redhat',
}
```

This feature has been deprecated now, and will be removed soon.  See Issue #1.

##Development

Please read CONTRIBUTING.md before contributing.

###Testing

Make sure you have:

* rake
* bundler

Install the necessary gems:

    bundle install

To run the tests from the root of the source code:

    bundle exec rake spec

To run the acceptance tests:

To run the acceptance tests:

    RS_SET=centos-66-x64 bundle exec rake spec/acceptance
    RS_SET=centos-72-x64 bundle exec rake spec/acceptance

etc.
