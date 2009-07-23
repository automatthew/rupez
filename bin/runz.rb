#!/usr/bin/env ruby
require 'rubygems'
require 'pez'

if __FILE__ == $0
  include Pez
  pez_init

  loop {
    print "-> " if $stdin.tty?
    $stdout.flush
    pez_eval(gets || break)
  }
end

puts
