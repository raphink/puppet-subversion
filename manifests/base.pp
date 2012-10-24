class subversion::base {
    package{'subversion':
        ensure => present,
    }

    file { '/etc/subversion':
        ensure  => directory,
        require => Package['subversion'],
    }

    augeas::lens {'subversion':
        ensure => present,
        lens_source => 'puppet:///modules/subversion/subversion.aug',
    }

    # only recent version of svn support the "store-password" option.
    augeas { "avoid svn password saving":
        incl      => '/etc/subversion/config',
        lens      => 'Subversion.lns',
        require   => [Augeas::Lens['subversion'], File["/etc/subversion"]],
        changes   => $lsbdistcodename ? {
            default                     => "set auth/store-auth-creds no",
            /^(Tikanga|lenny|squeeze)$/ => "set auth/store-password no",
        },
    }
}
