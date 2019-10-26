class Message < ApplicationRecord
    #Import Searchable module
    include Searchable
    
    #Each message belongs to a chat
    belongs_to :chat

    #Validate the sender & body
    validates :sender, presence: true, length: {minimum: 3}
    validates :body, presence: true, length: {minimum: 3}

    #Set the route param
    def to_param 
        token
    end

    #Search method
    def self.search(query)
        __elasticsearch__.search(
            {
                query: {
                    multi_match: {
                        query: query,
                        fields: ['body']
                    }
                },
                highlight: {
                    pre_tags: ['<em>'],
                    post_tags: ['</em>'],
                    fields: {
                        body: {}
                    }
                }
            }
        )
    end
end