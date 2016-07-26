class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string :name
      t.string :email
      t.string :username
      t.string :password_digest
      t.string :country_code
      t.string :phone
      t.integer :authy_id
      t.boolean :verified

      t.timestamps 

    end
  end
end
