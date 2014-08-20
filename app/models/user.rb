class User < ActiveRecord::Base
  validates_presence_of :name

  def redis_key(str)
    "user:#{self.id}:#{str}"
  end

  def follow!(user)
    $redis.multi do
      $redis.sadd(self.redis_key(:following), user.id)
      $redis.sadd(user.redis_key(:followed),self.id)
    end
  end

  def following
    user_ids = $redis.smembers(self.redis_key(:following))
    User.where(:id => user_ids)
  end
  
  def followed
    user_ids = $redis.smembers(self.redis_key(:followed))
    User.where(:id => user_ids)
  end

end
