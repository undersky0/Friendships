class Friendship < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :friend, :class_name => "User"
  
  def approved?
    !self.pending
  end
  
  def pending?
    self.pending
  end
end
