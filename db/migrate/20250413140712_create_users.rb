class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false, default: ""
      t.string :name, null: false, default: ""
      t.string :password_digest, null: false
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
