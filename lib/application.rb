# -*- coding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../../../cisco_acl_intp/lib', __FILE__)
puts $LOAD_PATH

require 'sinatra/base'
require 'haml'
require 'stringio'
require 'cisco_acl_intp'

class CiscoAclWebApp < Sinatra::Base
  set :bind, '0.0.0.0' # bind any addr when running WEBrick

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
    @search_opts = _gen_search_opts(params)
    _puts_term @search_opts
    haml :analyze
  end

  def _puts_term(str)
    puts '------------------------------'
    puts str
    puts '------------------------------'
  end

  def _default(value, default)
    value == '' ? default : value
  end
  def _gen_search_opts(params)
    opts = {}
    opts[:protocol] = params[:protocol]
    opts[:src_ip] = _default(params[:src_ip], '0.0.0.0')
    opts[:dst_ip] = _default(params[:dst_ip], '0.0.0.0')

    if ['tcp','udp'].include?(params[:protocol])
      opts[:src_port] = _default(params[:src_port], 0)
      opts[:dst_port] = _default(params[:dst_port], 0)
    end
    opts
  end
end

CiscoAclWebApp.run!

### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
