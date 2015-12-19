require 'json'
require 'rubygems'
require 'sinatra'
require './controllers/dns_records_controller.rb'

get '/home' do 
  haml :dns_records, layout: :layout
end

get '/dns_records/:domain' do
  content_type :json
  @results = DnsRecordsController.show(params['domain'])
  render_json_response 200, data: @results
end

def render_json_response(status, data)
  status status
  data.to_json  
end


