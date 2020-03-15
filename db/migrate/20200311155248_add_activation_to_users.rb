class AddActivationToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users, bulk: true do |t|
      t.string :activation_digest

      t.boolean :activated, null: false, default: false

      t.datetime :activated_at
    end
  end
end
