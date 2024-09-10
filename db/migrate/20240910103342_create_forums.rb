class CreateForums < ActiveRecord::Migration[7.2]
  def change
    create_table :forums do |t|
      t.string :name
      t.boolean :admin_only
      t.boolean :admin_only_view

      t.timestamps
    end
  end
end
