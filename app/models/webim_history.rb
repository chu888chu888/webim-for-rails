class WebimHistory < ActiveRecord::Base
	
  #self.inheritance_column = nil
  
  def self.recent(uid, with, type="chat", limit=30)	
    if( type == "chat" ) 
	  where = "`cls` = 'chat' AND ((`to`='$with' AND `from`='$uid' AND fromdel != 1) OR (send = 1 AND `from`='$with' AND `to`='$uid' AND todel != 1))"
    else 
      where = "`to`='$with' AND `cls`='grpchat' AND send = 1"
	end
	histories = self.where(where).order('timestamp DESC').limit(limit)
	histories.each {|h| h['type'] = h['cls'], h}
	histories.reverse
  end

  def self.clear(uid, with)
	 self.update_all("fromdel = 1", "from = #{uid} and to = #{with}")
	 self.update_all("todel = 1", "from = #{with} and to = #{uid}")
  end

end
