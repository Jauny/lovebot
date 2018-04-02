class AddLastLovedToAccount < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :last_loved, :bigint
  end
end
