class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.integer :kind
      t.integer :cost_cops
      t.integer :weight
      t.integer :remainder
      t.string  :title
      t.string  :description

      t.timestamps
    end
  end
end
