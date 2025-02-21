require_relative 'network/curl'

a = Lurc::Lurc.new
a.get "https://google.com"
