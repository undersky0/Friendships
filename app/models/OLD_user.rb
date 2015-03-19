class User < ActiveRecord::Base
  has_many :friendship
  
  has_many :friends, -> { where  "friendships.status = 'accepted'" }, :through => :friendship, source: :friend
    
  has_many :requested_friends, -> { where "friendships.status = 'requested'"},
           through: :friendship, source: :friend
           
  has_many :pending_friends, -> { where "friendships.status = 'pending'" },
           through: :friendship, source: :friend
end