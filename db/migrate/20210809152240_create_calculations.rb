class CreateCalculations < ActiveRecord::Migration[6.1]
  def change
    create_table :calculations do |t|
      t.json :element, null: false, default: '{}'
      t.decimal :total
      t.timestamps
    end
  end
end
