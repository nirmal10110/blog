require 'faker'
1000.times do
  Article.create(title: Faker::Book.title, body: Faker::Movies::StarWars.quote, user_id: rand(1..15))
end


# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# articles = Dir[ Rails.root + 'db/seeds/*.txt' ]
# p Rails.root + 'db/seeds/*.txt'
# p articles
# articles.each do |page|
#   text = File.open(page).read
#   text.gsub!(/\r\n?/, "\n")
#
#   line_num = 0
#
#   title = ''
#   body = ''
#
#   text.each_line do |line|
#     if line_num == 0
#       title = line
#     else
#       body += line
#     end
#     line_num += 1
#   end
#   # p title.strip
#   # p body.strip
#   @article = Article.new( title: title.strip, body: body.strip , user_id: rand(2..5))
#   if @article.save
#     p "done"
#   else
#     p "not done"
#   end
# end

