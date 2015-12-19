# get dns records with domain dns_ip and record_type
require 'dnsruby'
class DnsRecords
  include Dnsruby

  BEIJING_DNS_IP = '159.226.163.130'

  attr_accessor :dns_ip, :dns_location, :record_type

  def initialize(domain)
    @domain = domain
  end

  def search(opts = {})
    @dns_ip = opts[:ip] || BEIJING_DNS_IP
    @dns_location = opts[:location] || 'China'
    @record_type = opts[:record_type] || 'A'
    begin
      answers = Resolver.new({ nameserver: [dns_ip], do_caching: false })
                        .query(@domain, record_type).answer
    rescue Dnsruby::NXDomain
      return result_of(:invalid_domain,
                       message: "Fail, no records in #{record_type}")
    rescue Dnsruby::ResolvTimeout
      return result_of(:timeout,
                       message: "Timeout, while connecting #{dns_location}'s service")
    end
    data = data_of answers unless answers.empty?
    result_of(:ok, data: data, location: @dns_location)
  end

  private

  def data_of answers
    answers.map do |record| 
      { 
        record: @domain,
        type: record.type.to_s,
        ttl: record.ttl.to_s,
        value: record.rdata.to_s,
      }
    end 
  end

  def result_of(status, content = {})
    {
      status: status,
      location: content[:location],
      data: content[:data],
      message: content[:message]
    }
  end
end
