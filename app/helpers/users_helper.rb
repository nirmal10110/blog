module UsersHelper

  def update_user_redis(user)
    $redis.set("user_id"+user.__id__.to_s, user.username)
  end

  def fetch_username_redis(user_id)
    username = $redis.get("user_id"+user_id.to_s)
    if(username.nil?)
      username = User.find(user_id).username
      $redis.set("user_id"+user_id.to_s, username)
      $redis.expire("user_id"+user_id.to_s,5.hour.to_i)
    end
    username
  end

end