class CreateWebimHistories < ActiveRecord::Migration
  def change
    create_table :webim_histories do |t|

	  t.integer :send
	  t.string  :cls
	  t.string	:to
	  t.string	:from
	  t.string	:nick
	  t.string	:body
	  t.string	:style
	  t.float	:timestamp
	  t.integer	:todel
	  t.integer	:fromdel
      t.timestamps
    end
  end
end
