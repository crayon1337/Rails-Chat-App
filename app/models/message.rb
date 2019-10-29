class Message < ApplicationRecord
    #Import Searchable module
    include Searchable
    
    #Each message belongs to a chat
    belongs_to :chat, counter_cache: true

    #Validate the sender & body
    validates :sender, presence: true, length: {minimum: 3}
    validates :body, presence: true, length: {minimum: 3}

    #Set the route param
    def to_param 
        token
    end

    #Search method
    def self.search(query)
		__elasticsearch__.search({
            _source: ['sender', 'body', 'created_at'],
			query: {
				wildcard: {
					body: {
                        value: "*#{query}*",
                        boost: 1.0,
                    }
                }
            }
        })
    end
end