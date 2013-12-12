class CreateWebimHistories < ActiveRecord::Migration
  def change
    create_table :webim_histories do |t|

      t.timestamps
    end
  end
end
