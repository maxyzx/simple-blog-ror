class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.string :area
      t.string :gender
      t.date :date_of_birth
      t.string :display_name
      t.string :menu
      t.text :hair_concerns
      t.string :status

      t.timestamps
    end
    add_index :requests, :display_name
  end
end
