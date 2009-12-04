class Bookmarks < ActiveRecord::Migration
  def self.up
    create_table :bookmarks do |t|
      t.integer :user_id, :null => false
      t.string :url,:null => false
      t.boolean :sent, :default => false
      t.timestamps
    end
  end
  
  def self.down
    drop_table :bookmarks
  end
end
