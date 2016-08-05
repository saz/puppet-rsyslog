# Fact: :syslog_package
#
# Purpose: retrieve installed rsyslog version
#

Facter.add(:rsyslog_version) do
  setcode do
    osfamily = Facter.value('osfamily')
    case osfamily
    when 'Debian'
      command = '/usr/bin/dpkg-query -f \'${Status};${Version};\' -W rsyslog 2>/dev/null'
      version = Facter::Util::Resolution.exec(command)
      if version =~ %r{.*[install|hold] ok installed;([^;]+);.*}
        Regexp.last_match(1)
      end
    when 'RedHat', 'Suse'
      command = 'rpm -qa --qf "%{VERSION}" "rsyslog"'
      version = Facter::Util::Resolution.exec(command)
      Regexp.last_match(1) if version =~ %r{^(.+)$}
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
