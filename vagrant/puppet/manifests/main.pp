import 'apt.class.pp'
import 'apache.class.pp'
import 'php.class.pp'
import 'os-tools.class.pp'
import 'mysql.class.pp'

class groups {
  group { "puppet":
    ensure => present,
  }
}

#stage{pre:}->Stage[main]->stage{post:}

#node 'default' {
#  class{'php54dotdeb': stage => pre}->class{'apt':}->class{'os-tools':}->class{'groups':}
#  class {'apache': stage => post}->class{'mysql':}->class{'php5':}
#}

include apt
include os-tools
include groups
include apache
include php
include mysql
