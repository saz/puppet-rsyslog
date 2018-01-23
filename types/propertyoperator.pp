# Enumerable custom type for rsyslog property operators
type Rsyslog::PropertyOperator = Enum[ 'contains',
  'isequal',
  'startswith',
  'regex',
  'ereregex',
  'startswith_i',
  'contains_i',
  '!contains',
  '!isequal',
  '!startswith',
  '!regex',
  '!ereregex',
  '!startswith_i',
  '!contain_i'
]
