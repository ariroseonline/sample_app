class Micropost < ActiveRecord::Base
  attr_accessible :content
  
  belongs_to :user
  
  validates :content, :presence => true, :length => { :maximum => 140}
  validates :user_id, :presence => true
  
  default_scope :order => "microposts.created_at DESC"
  
  scope :from_users_followed_by, lambda { |user| followed_by(user) } #scopes are for performance...like defining a method
  
  private
    def self.followed_by(user) #class method cause there isn't a micropost object at this point
       following_ids = %(SELECT followed_id FROM relationships WHERE  
                        follower_id = :user_id) #this is an SQL subselect which is efficient
        self.where("user_id IN (#{following_ids}) OR user_id = :user_id", {:user_id => user })
    end

end
# == Schema Information
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

