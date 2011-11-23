
class subversion::base {
    package{'subversion':
        ensure => present,
    }

    file { '/etc/subversion':
        ensure  => directory,
        require => Package['subversion'],
    }

    file { "/usr/share/augeas/lenses/contrib/subversion.aug":
        ensure => present,
        source => "puppet:///modules/subversion/subversion.aug",
    }

    # only recent version of svn support the "store-password" option.
    augeas { "avoid svn password saving":
        load_path => "/usr/share/augeas/lenses/contrib/",
        context   => "/files/etc/subversion/config/auth/",
        require   => [File["/usr/share/augeas/lenses/contrib/subversion.aug"], File["/etc/subversion"]],
        changes   => $lsbdistcodename ? {
            default                     => "set store-auth-creds no",
            /^(Tikanga|lenny|squeeze)$/ => "set store-password no",
        },
    }
}
