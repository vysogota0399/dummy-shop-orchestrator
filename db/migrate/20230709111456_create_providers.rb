class CreateProviders < ActiveRecord::Migration[7.0]
  def change
    create_table :providers do |t|
      t.string :name
      t.string :email
    
      t.timestamps
    end
    
    add_index :providers, :email, if_not_exists: true, unique: true
  end
end
