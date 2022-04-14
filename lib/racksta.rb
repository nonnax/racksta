#!/usr/bin/env ruby
# Id$ nonnax 2022-03-01 15:24:22 +0800
require 'rack'
require_relative 'view'

module Racksta
  @map={"/" => :index }
  @stack = Rack::Builder.new do use Rack::Static, urls: %w[/img /media /js /css /.], root: 'public' end

  class << self
    attr :stack, :map
    def []=(*u,s) u.each{|x| @map[x]=s} end  
    def new() stack.tap{|s| s.run App.new } end
  end
  
  class App 
    attr :path_file, :status, :res, :req

    def eval_path_file(env) 
      if env["REQUEST_METHOD"] == "GET"
        @path_file = ::Racksta.map[env["PATH_INFO"]]
        @status = @path_file.nil?? 404 : 200
      end
      @path_file ||= :not_found_md
    end 

    def _call(env)
      @req=Rack::Request.new(env)
      @res=Rack::Response.new
      catch(:halt){
        eval_path_file(env)
        body = View.render(path_file, **req.params.transform_keys(&:to_sym))
        [status, {Rack::CONTENT_TYPE=>'text/html; charset=utf-8'}, [body]]
      }
    rescue Exception => e
      [500, {}, ['Internal Error: ' + e.message.partition('@').first]]    
    end
    def call(env) dup._call(env) end
    def halt(res) throw :halt, res end
  end
end

module Kernel
  def get(*u, &block) u.each{|x| Racksta.map[x]=block.call } end
end
