class User < ActiveRecord::Base
  
  #NEW WAY
  has_many :friendships
  has_many :pending_requests, -> {where 'friendships.status' => true}, :through => :friendships, :source => :friend
  has_many :requested, -> {where 'friendships.status' => false}, :through => :friendships, :source => :friend
  
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :pending_invites, ->  {where 'friendships.status' => true}, :through => :inverse_friendships, :source => :user
  has_many :invites, ->  {where 'friendships.status' => false}, :through => :inverse_friendships, :source => :user
  
  
  def request(user)
    return false if user == self || friends?(user)
    Friendship.create(user_id:self.id,friend_id:user.id,status:true)
  end
  
  def accept(user)
    friendship = friends?(user)
    return false if friendship.nil? || request_received?(user)
    friendship.update_attribute(:status, false)
  end
  
  def remove_friendship(user)
    friendship = friends?(user)
    return false if friendship.nil?
    friendship.destroy
  end
  
  def friends
    approved_friendship = Friendship.where(user_id: self.id, status: false).select(:friend_id).to_sql
    approved_inverse_friendship = Friendship.where(friend_id: self.id, status: false).select(:user_id).to_sql
    self.class.where("id in (#{approved_friendship}) OR id in (#{approved_inverse_friendship})")
  end
  
  def friend_count
    self.requested(false).count + self.invites(false).count
  end
  
  def friends?(user)
    friendship = Friendship.where(:user_id => self.id, :friend_id => user.id).first
    if friendship.nil?
      friendship = Friendship.where(:user_id => user.id, :friend_id => self.id).first
    end
    friendship
  end
  
  def befriended?(user)
    friends?(user).present?
  end

  def request_received?(user)
    friendship = friends?(user)
    return false if friendship.nil?
    friendship.user_id == user.id
  end

  def requested_friendship?(user)
    friendship = friends?(user)
    return false if friendship.nil?
    friendship.friend_id == user.id
  end
end
