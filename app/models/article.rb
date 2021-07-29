require 'elasticsearch/model'

class Article < ApplicationRecord

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :user
  validates :title, presence: true, length: { minimum: 3, maximum: 50 }
  validates :body, presence: true, length: { minimum: 10, maximum: 300 }
  validates :user_id, presence: true

  settings index: { number_of_shards: 1 } do
    mapping dynamic: false do
      indexes :title,type: :text, analyzer: 'english'
      indexes :body, type: :text, analyzer: 'english'
      indexes :user_id, type: :integer
    end
  end


  def self.search(query)
    __elasticsearch__.search (
                               {
                                 query: {
                                   multi_match: {
                                     query: query,
                                     fields: ['title^5', 'body']
                                   }
                                 },
                                 highlight: {
                                   pre_tags: ['<mark>'],
                                   post_tags: ['</mark>'],
                                   fields: {
                                     title: {},
                                     body: {},
                                   }
                                 },
                                 suggest: {
                                   text: query,
                                   title: {
                                     term: {
                                       size: 1,
                                       field: :title
                                     }
                                   },
                                   body: {
                                     term: {
                                       size: 1,
                                       field: :body
                                     }
                                   }
                                 }
                               }
                             )
  end

end
