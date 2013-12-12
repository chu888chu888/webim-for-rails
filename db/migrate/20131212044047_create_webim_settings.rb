class CreateWebimSettings < ActiveRecord::Migration
  def change
    create_table :webim_settings do |t|

      t.timestamps
    end
  end
end
