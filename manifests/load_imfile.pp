# == Define: rsyslog::load_imfile
#
# This class creates a configuration file to load the imfile module.
#
class rsyslog::load_imfile {

  rsyslog::snippet{ '01-load_imfile':
    content => template('rsyslog/load_imfile.erb'),
  }
}
