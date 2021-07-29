class User < ApplicationRecord

  # include UsersHelper


  has_many :articles
  has_secure_password
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 25 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 105 }, uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }
  before_save { self.email = email.downcase }

  def self.find_user(user_id)
    user = $redis.get("user_id"+user_id.to_s)
    if(user.nil?)
      user = User.find(user_id)
      $redis.set("user_id"+user_id.to_s, user.to_json)
      $redis.expire("user_id"+user_id.to_s,5.hour.to_i)
      return user.to_json
    end
    return JSON.parse(user)
    # fetch_username_redis(user_id)
  end

  def self.find_username(user_id)
    user = find_user(user_id)
    return user["username"]
  end

end