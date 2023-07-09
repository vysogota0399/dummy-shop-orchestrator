class AddProviderIdToItems < ActiveRecord::Migration[7.0]
  def change
    change_table(:items) do |t|
      t.references :provider, foreign_key: true
    end
  end
end
