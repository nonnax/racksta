# Id$ nonnax 2022-02-26 17:19:12 +0800
# frozen_string_literal: true
require_relative 'lib/racksta'

Racksta['/'] = :index
Racksta['/about', '/info']  = :about_md
Racksta.map.merge!('/first' => :first, '/next'=> :next )

p Racksta.map
run Racksta.new
