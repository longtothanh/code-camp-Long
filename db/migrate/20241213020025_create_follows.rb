class CreateFollows < ActiveRecord::Migration[7.2]
  def change
    create_table :follows do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :followed_id

      t.timestamps
    end

    add_index :follows, :followed_id
    add_index :follows, [:user_id, :followed_id], unique: true  # Đảm bảo mỗi user chỉ có 1 follow cho mỗi người
  end
end
