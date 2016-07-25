class AddColumnsToRefineryUsers < ActiveRecord::Migration
  def change
    add_column :refinery_users, :provider, :string
    add_column :refinery_users, :uid, :string
  end
end
