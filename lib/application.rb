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

    # protool
    opts[:protocol] = params[:protocol]
    if params[:protocol] == 'user'
      opts[:protocol] = _default(params[:proto_id], 'ip')
    end

    # source ip
    opts[:src_ip] = _default(params[:src_ip], 'any')
    # source port operator
    opts[:src_operator]   = params[:src_operator] # save current select
    opts[:src_begin_port] = _default(params[:src_begin_port], nil)
    opts[:src_end_port]   = _default(params[:src_end_port],   nil)

    # destination ip
    opts[:dst_ip] = _default(params[:dst_ip], 'any')
    # destination port operator
    opts[:dst_operator]   = params[:dst_operator] # save current select
    opts[:dst_begin_port] = _default(params[:dst_begin_port], nil)
    opts[:dst_end_port]   = _default(params[:dst_end_port],   nil)

    # search type
    opts[:search_type]    = _default(params[:search_type], 'contains')

    # return
    opts
  end
end

CiscoAclWebApp.run!

### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
