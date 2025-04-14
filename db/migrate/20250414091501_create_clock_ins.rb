class CreateClockIns < ActiveRecord::Migration[8.0]
  def change
    create_table :clock_ins, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.integer :duration
      t.datetime :clock_in_at
      t.datetime :clock_out_at

      t.timestamps
    end

    add_index :clock_ins, [ :user_id, :clock_in_at, :duration ]
  end
end
