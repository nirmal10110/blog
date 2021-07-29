module ArticlesHelper
  def fetch_articles_redis
    keys = $redis.keys.select{|key| key.starts_with?("article") ? key : false}
    # p keys
    @articles = keys.map{|key| JSON.parse($redis.get(key))}
    # p @articles
    if @articles.length.eql?(0)
      @articles = Article.all
      @articles.each do|article|
        $redis.set("article"+article.id.to_s,article.to_json)
        $redis.expire("article"+article.id.to_s,5.hour.to_i)
      end
      return JSON.parse(@articles.to_json)
    end

    @articles
  end

  def save_to_redis(article)
    $redis.set("article"+article.id.to_s,article.to_json)
  end

  def get_article_from_redis(id)
    # print("article"+id.to_s)
    @article = $redis.get("article"+id.to_s)
    if @article.nil?
      @article = Article.find(id)
      save_to_redis(@article)
    end
    @article = JSON.parse($redis.get("article"+id.to_s))
  end

  def delete_from_redis(id)
    $redis.del("article"+id.to_s)
  end

end