class CreateScientists < ActiveRecord::Migration
  def change
    create_table :scientists do |t|
      t.text :name
      t.text :username
      t.text :email
      t.text :password_digest
    end
  end
end
