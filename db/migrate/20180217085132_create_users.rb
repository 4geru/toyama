class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :status
      # settingPlace : ユーザーの場所の登録
      t.string  :user_id
      t.timestamps null: false
    end
  end
end
