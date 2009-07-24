#!/usr/bin/env ruby
require 'rubygems'
require 'pez'

if __FILE__ == $0
  include Pez
  pez_init
  
  m = mark
  
  pez_eval ": foo 4 5 3 + . cr ;"
  
  puts lookup("foo")[:wname]
  
  unwind(m)
  
  # loop {
  #   print "-> " if $stdin.tty?
  #   $stdout.flush
  #   pez_eval(gets || break)
  # }
  
end

puts
