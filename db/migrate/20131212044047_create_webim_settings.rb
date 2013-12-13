class CreateWebimSettings < ActiveRecord::Migration
  def change
    create_table :webim_settings do |t|
	  t.string :uid
	  t.text :data
      t.timestamps
    end
  end
end
