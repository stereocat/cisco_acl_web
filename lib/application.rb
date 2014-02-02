# -*- coding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../../../cisco_acl_intp/lib', __FILE__)
puts $LOAD_PATH

require 'sinatra/base'
require 'haml'
require 'stringio'
require 'cisco_acl_intp'

class CiscoAclWebApp < Sinatra::Base
  get '/' do
    redirect '/analyze'
  end

  get '/analyze' do
    haml :analyze
  end

  post '/analyze' do
    @raw_acls = params[:acls]
    _puts_term @raw_acls
    @parser = CiscoAclIntp::Parser.new(color: :html)
    @parser.parse_file(StringIO.new(@raw_acls))
    @acl_table = @parser.acl_table
    @error_list = @parser.error_list
    haml :analyze
  end

  def _puts_term str
    puts '------------------------------'
    puts str
    puts '------------------------------'
  end
end

CiscoAclWebApp.run!

### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
