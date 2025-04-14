class CreateFollowings < ActiveRecord::Migration[8.0]
  def change
    create_table :followings, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :target, null: false, foreign_key: { to_table: :users }, type: :uuid

      t.timestamps
    end
  end
end
