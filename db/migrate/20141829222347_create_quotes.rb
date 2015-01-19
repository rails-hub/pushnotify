class CreateQuotes < ActiveRecord::Migration
  def change
    create_table(:quotes) do |t|
      t.string :title, null: false, default: ""
      t.timestamps
    end

    add_index :quotes, :title, unique: true
  end
end
