class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.references :user, foreign_key: true
      t.string :text

      t.timestamps
    end
  end
end
