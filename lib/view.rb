#!/usr/bin/env ruby
# Id$ nonnax 2022-03-01 15:27:49 +0800
require 'kramdown'

class View
  attr :params
  def self.render(page, **params) new(page, **params).render end

  def initialize(page, **params)
    @params = params
    dir, html, page = page.to_s.partition('#')
    if html=='#'
      pathname = File.join('public', dir, "#{page}.html")
      @file = File.expand_path(pathname, Dir.pwd)
    else
      page = dir
      @layout, @template = [:layout, page].map{ |f| File.expand_path("views/#{f}.erb", Dir.pwd)}
    end
  end

  def render()
    return File.read(@file) if @file
    [@template, @layout]
    .map{|f| File.read(f).then{|doc| f.match?(/_md\./) ? markdown(doc) : doc} }
    .inject(nil){ |prev, layout| _render(layout){ prev } }
  end

  def _render(f) ERB.new(f).result( binding ) end
  def markdown(f) Kramdown::Document.new(f).to_html end
end
