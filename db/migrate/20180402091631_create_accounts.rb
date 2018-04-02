class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :access_token
      t.string :access_token_secret
      t.boolean :active

      t.timestamps
    end
  end
end
