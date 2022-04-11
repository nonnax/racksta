#!/usr/bin/env ruby
# Id$ nonnax 2022-03-01 15:27:49 +0800
require 'kramdown'

class View
  def self.render(page, **data) new(page, **data).render end 
  
  def initialize(page, **data)
    @data = data
    @layout, @template = 
    [:layout, page].map{ |f| 
      File.expand_path("public/views/#{f}.erb", Dir.pwd)
      .then{|f| File.read(f) }
      .then{|doc| f.match?(/_md$/) ? markdown(doc) : doc} 
    }
  end
  
  def render() [@template, @layout].inject(nil){ |prev, layout| _render(layout){ prev } } end
  
  def _render(f) ERB.new(f).result( binding ) end
  def markdown(f) Kramdown::Document.new(f).to_html end
  def visit_count() @data[:visit_count] end
end
