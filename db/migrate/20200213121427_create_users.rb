class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name,            limit: 50
      t.string :email,           index: { unique: true }, limit: 100, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
