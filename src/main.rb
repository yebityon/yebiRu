require_relative 'network/curl'
require 'byebug'

a = Lurc::Lurc.new
a.get "https://google.com"
a.get "https://cnmeirh5ep.ap-northeast-1.awsapprunner.com/api/v1/5/companies"
a.get "https://cnmeirh5ep.ap-northeast-1.awsapprunner.com/api/v1/5/companies"
a[0].res.pretty_print
a.pretty_print
