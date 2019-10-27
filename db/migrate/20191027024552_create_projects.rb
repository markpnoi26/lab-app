class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.text :title
      t.text :content
      t.text :date
      t.integer :scientist_id
    end
  end
end
