class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  
  has_many :microposts, :dependent => :destroy
  has_many :relationships, :dependent => :destroy, 
                           :foreign_key => "follower_id" #rails assumes user_id
  has_many :reverse_relationships, :dependent => :destroy,
                                   :foreign_key => "followed_id",
                                   :class_name => "Relationship"
  has_many :following, :through => :relationships, :source => :followed #plural given to rails explicitly
  has_many :followers, :through => :reverse_relationships,
                                   :source => :follower
  
  
  email_regex = /\A[\w+\-.]+@[a-z\d.\-]+\.[a-z]+\z/i
  
  validates :name, :presence => true,
                   :length => {:maximum => 50}
  validates :email, :presence => true,
                    :format => {:with => email_regex},
                    :uniqueness => {:case_sensitive => false}
  validates :password, :presence => true,
                      :confirmation => true,
                      :length => {:within => 6..40}
                      
  before_save :encrypt_password
  
  def has_password?(submitted_password)
    self.encrypted_password == encrypt(submitted_password)
  end
  
  def feed
    Micropost.where("user_id = ?", self.id) #ensure escaped id input with ? notation
  end
  
  def following?(followed)
    self.relationships.find_by_followed_id(followed)  #followed object gets turned into id by rails
  end
  
  def follow!(followed)
    self.relationships.create!(:followed_id => followed.id)
  end
  
  def unfollow!(followed)
    self.relationships.find_by_followed_id(followed).destroy
  end
  
  #class method
  def self.authenticate(email, submitted_password)
    user = User.find_by_email(email) #pull user out of database
    (user && user.has_password?(submitted_password)) ? user : nil
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = User.find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  private 
    def encrypt_password
      self.salt = make_salt if self.new_record?
      self.encrypted_password = encrypt(self.password) 
    end
    
    def encrypt(string)
      secure_hash("#{self.salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{self.password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
    
    
  
end
# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#

