# frozen_string_literal: true

# Fact: :syslog_package
#
# Purpose: retrieve installed rsyslog version
#

Facter.add(:rsyslog_version) do
  setcode do
    osfamily = Facter.value('os')['family']
    case osfamily
    when 'Debian'
      command = '/usr/bin/dpkg-query -f \'${Status};${Version};\' -W rsyslog 2>/dev/null'
      version = Facter::Util::Resolution.exec(command)
      Regexp.last_match(1) if version =~ %r{.*[instal|hod] ok installed;([^;]+);.*}
    when 'RedHat', 'Suse'
      if File.exist? '/sbin/rsyslogd'
        # Query rsyslogd binary for the version
        Facter::Util::Resolution.exec("rsyslogd -v | sed -n '2q; s/^[^ ]* ([0-9][^ ]*).*/\1/; s/,//g;p'")
      else
        # Fall back to rpm to determine version
        command = 'rpm -q --qf "%{VERSION}" "rsyslog"'
        version = Facter::Util::Resolution.exec(command)
        Regexp.last_match(1) if version =~ %r{^(.+)$}
      end
    when 'FreeBSD'
      command = 'pkg query %v rsyslog8'
      version = Facter::Util::Resolution.exec(command)
      Regexp.last_match(1) if version =~ %r{^(.+)$}
    when 'Gentoo'
      command = 'equery -q -C list -F \'$version\' rsyslog'
      version = Facter::Util::Resolution.exec(command)
      Regexp.last_match(1) if version =~ %r{^(.+)$}
    end
  end
end
