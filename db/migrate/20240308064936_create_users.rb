class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :username
      t.string :twofa
      t.boolean :twofa_on_off, default: false


      t.timestamps
    end
  end
end
