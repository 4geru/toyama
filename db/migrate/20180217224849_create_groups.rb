class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string  :group_id
      t.string  :photo_id
      t.timestamps null: false
    end
  end
end
