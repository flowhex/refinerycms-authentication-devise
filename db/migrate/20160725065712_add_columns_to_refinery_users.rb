class AddColumnsToRefineryUsers < ActiveRecord::Migration
  def change
    add_column :refinery_authentication_devise_users, :provider, :string
    add_column :refinery_authentication_devise_users, :uid, :string
  end
end
