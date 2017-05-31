class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :restaurant_id
      t.integer :user_id
      t.string :party_name
      t.string :number_of_people

      t.boolean :confirmed

      t.datetime :estimated_time
      t.datetime :party_time

      t.string :wait_time
      t.boolean :active

      t.timestamps null: false
    end
  end
end
