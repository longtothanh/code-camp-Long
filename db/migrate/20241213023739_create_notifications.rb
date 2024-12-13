class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :notifiable, null: false, foreign_key: true
      t.string :action_type

      t.timestamps
    end
  end
end
