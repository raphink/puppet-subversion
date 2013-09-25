class subversion::params {
  $dir = $subversion_dir ? {
    ''      => '/srv/svn',
    default => $subversion_dir,
  }

  $backupdir = $subversion_backupdir ? {
    ''      => '/var/backups/subversion',
    default => $subversion_backupdir,
  }
}
