require_relative 'network/curl'
require 'byebug'

a = Lurc::Lurc.new
a.get "https://google.com"
p a.hisotry
