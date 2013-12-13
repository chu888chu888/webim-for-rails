webim-for-rails
===============

webim for rails

webim static files
==================

public/static

configuration
=============

config/webim.yml

	webim:
	  isopen: true
	  domain: localhost
	  apikey: public 
	  host: nextal.im   
	  port: 8000
	  emot: default
	  theme: base
	  opacity: 80
	  local: zn-CN
	  enable_room: true
	  enable_chatlink: false
	  enable_shortcut: false
	  enable_menu: false
	  enable_noti: true
	  admin_uid: 0
	  visitor: false
	  show_unavailable: false
	  upload: false

config/initializers/load_webim_config.rb

	WEBIM_CONFIG = YAML.load_file("#{Rails.root}/config/webim.yml")['webim'] 
