
require "webim"

class WebimController < ApplicationController

  before_action :init_client

  def run
	 respond_to do |format|
		format.js
	 end
  end

  def online
		#FIXME: read from model
    buddies = [{:id => "1", :nick => "user1", :show => "available", :status => "Online", :url => "#", :pic_url => "#"}]
		#FIXME: read from model
		groups = [{:id => "g1", :nick => "g1", :count => 0, :url => "#", :pic_url => "#"}]
    
		json = @client.online(buddies.map {|buddy| buddy[:id]}, groups.map {|group| group[:id]})

		conn = {:ticket => json['ticket'],
					  :domain => @client.domain,
					  :jsonpd => json['jsonpd'],
					  :server => json['server'],
		        :websocket => json['websocket']}

		

		online_uids = json['buddies'].map { |b| b['name'] }
		onlines = buddies.find_all { |b| online_uids.include? b[:id] }

		groups.each do |grp| 
		  rtgrp = json['groups'].find {|g| g['name'] == grp[:id]}
		  grp[:count] = rtgrp[:total] if rtgrp
		end

		data = {
			:success => true,
			:connection => conn,
			:buddies => buddies,
			:rooms => groups,
			:server_time => Time.now.to_f * 1000,
			:user => @client.user
		}
		respond_to do |format| 
			format.json { render json: data} 
		end
  end

  def offline
	  @client.offline
		respond_ok
  end

  def message
		type = params[:type]
		offline = params[:offline]
		to = params[:to]
		body = params[:body]
		style = params[:style]
		send = (offline == "true" or offline == "1") ? "0" : "1"
		timestamp = Time.now.to_f * 1000
		# current user
		
		# unless (body, "webim-event:") 
		#		WebimHistory.insert({
		#		  :send => send,
		#			:type => type,
		#			:to => to,
		#			:body => body,
		#			:style => style
		#			:timestamp => timestamp
		#		})
		#end
		#if(send == "1")
			@client.message(to, body, timestamp, type, style)
		#end
		respond_ok
  end

  def presence
	  show = params[:show]
		status = params[:status]
		@client.presence(show, status)
		respond_ok
  end

  def refresh
	  @client.offline
		respond_ok
  end

  def status
		to = params[:to]
	  show = params[:show]
	  @client.status(to, show)	
		respond_ok
  end

  def setting
	  uid = current_uid
		data = params[:data]
		#WebimSetting
		#$this->History_model->set($uid, $data);
		respond_to do |format| format.json { render json: "ok"} end
  end

  def history
	  uid = current_uid
		with = params[:id]
		type = params[:type]
		histories = []#WebimHistory.find(:uid => uid, :with => with, :type => type)
		respond_to do |format| 
			format.json { render json: histories} 
	  end
  end

  def clear_history
	  id = params[:id]
		#WebimHistory.clear(current_uid, id)
		respond_to do |format| format.json { render json: "ok"} end
  end

  def download_history
		uid = current_uid
		id = params[:id]
		type = params[:type]
		@date = params[:date]
		#TODO:
		#@histories = WebimHistory.recent(uid, id, type)
		respond_to do |format| 
		  format.html
		end
  end

  def members
	  gid = params[:id]
		res = @client.members(gid)
		res = "Not Found" unless res
		respond_to do |format|
			format.json { render json: res}
		end
  end

  def join
	  gid = params[:id]
		room =  nil #FIXME: FIND FROM DATABASE
		unless room
			room = {:id => gid, "nick" => params[:nick], :temporary => true, :pic_url => "/static/images/chat.pnp"}
		end
		res = @client.join(gid)
		room[:count] = res["count"]
		respond_to do |format|
			format.json { render json: room}
		end
  end

  def leave
		gid = params[:id]
		@client.leave(gid)
		respond_ok
  end

	def rooms
	  ids = params[:ids]
		rooms = []
		respond_to do |format|
			format.json { render json: @rooms}
		end
	end

  def buddies
    @buddies = []
		respond_to do |format|
			format.json { render json: @buddies}
		end
  end

  def notifications
		# read notifications
		@notifications = [{:text => "通知", :link => "#"}]
		respond_to do |format|
			format.json { render json: @notifications}
		end
  end

	private

	#FIXME
	def current_uid
			session[:current_uid] ? session[:current_uid] : "1"
	end

	def respond_ok
		respond_to do |format| format.json { render json: "ok"} end
	end

	def init_client
			ticket = params[:ticket] ? params[:ticket] : ""
			user = {:id => "1", :nick => "user1", :show => "available", :status => "Online", :url => "#", :pic_url => "#"}
			config = {:domain => "localhost", :apikey => "public", :host => "localhost"}
			@client = Webim::Client.new(user, ticket, config)
	end

end
