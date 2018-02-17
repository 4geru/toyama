class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.float   :longitude # 経度
      t.float   :latitude  # 経度
      t.string  :name
      t.integer  :user_id
      t.timestamps null: false
    end
  end
end
