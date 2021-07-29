module UsersHelper

  def update_user_to_redis(user)
    $redis.set("user_id"+user.id.to_s, user)
  end

  def fetch_username_redis(user_id)
    username = $redis.get("user_id"+user_id.to_s)
    if(username.nil?)
      username = User.find(user_id).username
      $redis.set("user_id"+user_id.to_s, user)
      $redis.expire("user_id"+user_id.to_s,5.hour.to_i)
    end
    username
  end

end