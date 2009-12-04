class Bookmark < ActiveRecord::Base
  has_one :user
end
