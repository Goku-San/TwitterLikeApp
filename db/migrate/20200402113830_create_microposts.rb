class CreateMicroposts < ActiveRecord::Migration[5.2]
  def change
    create_table :microposts do |t|
      t.references :user, foreign_key: true, null: false

      t.text :content, null: false

      t.timestamps
    end

    add_index :microposts, %i[user_id created_at]
  end
end
