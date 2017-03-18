class { '::rsyslog::server':
  rules => [
    {
      selector => 'auth,authpriv.*',
      action   => '?dynAuthLog',
    },
    {
      selector => 'cron.*',
      action   => '?dynCronLog',
    },
    {
      selector => '*.*;auth,authpriv.none,mail.none,cron.none',
      action   => '-?dynSyslog',
    },
  ],
}
