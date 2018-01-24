# Enumerable custom type for rsyslog property operators
type Rsyslog::PropertyOperator = Enum[ 'contains',
  'isequal',
  'startswith',
  'regex',
  'ereregex',
  '!contains',
  '!isequal',
  '!startswith',
  '!regex',
  '!ereregex',
]
