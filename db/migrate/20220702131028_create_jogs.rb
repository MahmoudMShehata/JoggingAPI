class CreateJogs < ActiveRecord::Migration[6.1]
  def change
    create_table :jogs do |t|
      t.integer :duration
      t.integer :distance
      t.datetime :date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
