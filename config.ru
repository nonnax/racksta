# Id$ nonnax 2022-02-26 17:19:12 +0800
# frozen_string_literal: true
require_relative 'lib/racksta'

get('/home', '/hq'){ :index_html }

Racksta['/about', '/info']  = :about_md

pp Racksta.map
run Racksta.new
