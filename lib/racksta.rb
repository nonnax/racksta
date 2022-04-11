#!/usr/bin/env ruby
# Id$ nonnax 2022-03-01 15:24:22 +0800
require 'rack'
require_relative 'view'

class Racksta
  attr :path_file, :status
  @map={"/" => :index }
  class << self
    attr :map
    def []=(*u,s) u.each{|x| @map[x]=s} end  
  end

  def get_path_file(env) 
    if env["REQUEST_METHOD"] == "GET"
      @path_file = self.class.map[env["PATH_INFO"]]
      @status = @path_file.nil?? 404 : 200
    end
    [path_file, status] 
  end 

  def call(env)
    path_file, status = get_path_file(env)
    raise if status==404
    body = View.render(path_file, visit_count: parse_cookies(env))
    
    [status, {Rack::CONTENT_TYPE=>'text/html; charset=utf-8'}, [body]]
  rescue
    [404, {}, ['Not Found']]    
  end
  def parse_cookies(env)
    Rack::Utils.parse_cookies(env)["session_count"]
  end
end
