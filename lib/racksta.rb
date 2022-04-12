#!/usr/bin/env ruby
# Id$ nonnax 2022-03-01 15:24:22 +0800
require 'rack'
require_relative 'view'

module Racksta
  @map={"/" => :index }
  class << self
    attr :map, :stack
    def []=(*u,s) u.each{|x| @map[x]=s} end  
    def new()
      stack.run App.new
    end
    def stack()
      @stack ||= Rack::Builder.new do
        use Rack::Static,
            urls: %w[/images /js /css],
            root: 'public'
      end
    end
    def use(m, **params)
      stack.use(m, **params)
    end
  end
  
  class App 
    attr :path_file, :status

    def get_path_file(env) 
      if env["REQUEST_METHOD"] == "GET"
        @path_file = ::Racksta.map[env["PATH_INFO"]]
        @status = @path_file.nil?? 404 : 200
      end
      @path_file ||= :not_found_md
      [path_file, status] 
    end 

    def _call(env)
      catch(:halt){
        path_file, status = get_path_file(env)
        body = View.render(path_file, visit_count: parse_cookies(env))
        
        [status, {Rack::CONTENT_TYPE=>'text/html; charset=utf-8'}, [body]]
      }
    rescue
      [404, {}, ['Not Found']]    
    end
    def call(env) dup._call(env) end
    def parse_cookies(env) Rack::Utils.parse_cookies(env)["session_count"] end
    def halt(res) throw :halt, res end

  end
end
