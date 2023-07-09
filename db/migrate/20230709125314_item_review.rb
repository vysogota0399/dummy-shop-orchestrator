class ItemReview < ActiveRecord::Migration[7.0]
  def change
    create_table(:item_reviews) do |t|
      t.references :item, foreign_key: true
    end
  end
end
