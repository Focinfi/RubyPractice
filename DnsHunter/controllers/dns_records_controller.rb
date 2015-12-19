require_relative '../const.rb'
require File.join(APP_ROOT_PATH, 'lib', 'dns_records.rb')
require 'yaml'

class DnsRecordsController

  def self.show(domain)
    dns_ips_yml_file_path = File.join(APP_ROOT_PATH, 'config', 'dns_ips.yml')
    dns_ips = YAML.load(File.open(dns_ips_yml_file_path, 'r'))['DNS_IPS']
    threads = []
    results = []
    dns_ips.each do |dns_ip|
      threads << Thread.new do
        otps = { ip: dns_ip['ip'], location: dns_ip['location'], record_type: 'ANY' }
        results << DnsRecords.new(domain).search(otps)
      end
    end
    threads.map(&:join)
    results
  end
end

