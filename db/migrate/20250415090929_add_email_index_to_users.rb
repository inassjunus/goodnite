class AddEmailIndexToUsers < ActiveRecord::Migration[8.0]
  def change
    add_index :users, [ :email ]
  end
end
