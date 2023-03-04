class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.bigint  :performer_id
      t.bigint  :customer_id
      t.integer :cost_cops
      t.string  :customer_email
      t.string  :address
      t.string  :front_door
      t.string  :floor
      t.string  :intercom
      t.boolean :no_hand
      t.integer :status
      t.timestamps
    end
  end
end
