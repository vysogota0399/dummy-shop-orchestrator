class CreateOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :order_items do |t|
      t.belongs_to  :order
      t.belongs_to  :item

      t.integer     :cost_cops
      t.timestamps
    end
  end
end
