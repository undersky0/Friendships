class Fixfriendship < ActiveRecord::Migration
  def change
    remove_column :friendships, :status
		add_column :friendships, :status, :boolean
  end
end
