/*

==Class: subversion::backup

This class will add a shell script based on the utility hot-backup.py to make
consitent backups each night.

Parameters:
 $subversion_backupdir:
   this global variable is used to set the backup directory

*/
class subversion::backup {

  if ( ! $subversion_backupdir ) {
    $subversion_backupdir = "/var/backups/subversion"
  }

  file {$subversion_backupdir:
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => 755,
    require => [Package["subversion-tools"]],
  }

  file { "/usr/local/bin/subversion-backup.sh":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 755,
    content => template("subversion/subversion-backup.sh.erb"),
    require => File[$subversion_backupdir],
  }

  cron { "subversion-backup":
    command => "/usr/local/bin/subversion-backup.sh",
    user    => "root",
    hour    => 2,
    minute  => 0,
    require => [File["/usr/local/bin/subversion-backup.sh"]],
  }

}
