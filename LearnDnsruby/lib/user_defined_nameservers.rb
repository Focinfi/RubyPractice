require 'dnsruby'

class MyResolvers
  include Dnsruby
  attr_reader :resolver

  def initialize nameservers = ['8.8.8.8']
    @resolver ||= Resolver.new({nameserver: nameservers})
  end

end



