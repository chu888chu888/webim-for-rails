
require "webim"

class WebimController < ApplicationController

  before_action :init_client

  def run
    @user = current_user
	@setting = WebimSetting.find_by(uid: current_uid)
	if @setting
	  @setting = @setting[:data]
	else
	  @setting = "{}"
	end
    respond_to do |format|
      format.js
    end
  end

  def online
    #TODO: 应从model读取用户好友列表 
    buddies = [{:id => "1", 
                :nick => "user1", 
                :show => "available", 
				:status => "Online", 
				:url => "#", 
				:pic_url => "#"}]
    #TODO: 应从model读取用户群组列表
    groups = [{:id => "g1", 
               :nick => "g1", 
			   :count => 0, 
			   :url => "#", 
			   :pic_url => "#"}]
    
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
    send = (offline == "true" or offline == "1") ? 0 : 1
    timestamp = Time.now.to_f * 1000
    unless body.start_with?("webim-event:") 
	  #WebimHistory.create(
	  #  send: send,
	  #  cls: type,
	  #  to: to,
	  #  from: current_user[:id],
	  #  nick: current_user[:nick],
      #  body: body,
	  #  style: style,
	  #  timestamp: timestamp)
	  #	.save
    end
    @client.message(to, body, timestamp, type, style) if send
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
	setting = WebimSetting.find_by(uid: uid)
    if setting
	  setting.data = data 
	else
	  setting = WebimSetting.create(uid: uid, data: data)
	end
	seting.save
	respond_ok
  end

  def history
    histories = WebimHistory.recent(current_uid, params[:id], params[:type])
    respond_to do |format| 
      format.json { render json: histories } 
    end
  end

  def clear_history
    WebimHistory.clear(current_uid, params[:id])
    respond_ok
  end

  def download_history
    uid = current_uid
    id = params[:id]
    type = params[:type]
    @date = params[:date] ? params[:date] : Time.now
    @histories = WebimHistory.recent(uid, id, type, 1000)
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
    room = nil #FIXME: 从模型读取room
    room = {:id => gid, "nick" => params[:nick], :temporary => true, :pic_url => "/static/images/chat.pnp"} unless room
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
    #TODO: 应从模型读取通知列表
    @notifications = [{:text => "通知", :link => "#"}]
    respond_to do |format|
      format.json { render json: @notifications}
    end
  end

  private

  def init_client
    #读取ticket
    ticket = params[:ticket] ? params[:ticket] : ""
    config = {:domain => WEBIM_CONFIG["domain"], 
              :apikey => WEBIM_CONFIG["apikey"],
              :host => WEBIM_CONFIG["host"],
              :port => WEBIM_CONFIG["port"]}
    #创建client对象
    @client = Webim::Client.new(current_user, ticket, config)
  end

  #TODO:读取当前用户uid
  def current_uid
    session[:current_uid] ? session[:current_uid] : "1"
  end

  #TODO:当前用户对象
  def current_user
    uid = current_uid
    { :id => uid, 
      :nick => "user"+uid, 
      :show => "available", 
      :status => "Online", 
      :url => "#", 
      :pic_url => "#"}
  end

  def respond_ok
    respond_to do |format| format.json { render json: "ok"} end
  end

end

