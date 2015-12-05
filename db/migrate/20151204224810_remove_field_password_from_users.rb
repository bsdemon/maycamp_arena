class RemoveFieldPasswordFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :password, :text
  end
end
