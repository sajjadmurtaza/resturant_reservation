class CreateJoinTableForUsersAndZipCodes < ActiveRecord::Migration
  def change
    create_table :users_zip_codes do |t|
      t.integer :user_id
      t.integer :zip_code_id
    end
  end
end
