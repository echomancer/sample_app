class AddNameShowToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nameshow, :boolean, default: false
  end
end
