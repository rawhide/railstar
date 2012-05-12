class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :project_id
      t.string :status
      t.integer :price

      t.timestamps
    end
  end
end
