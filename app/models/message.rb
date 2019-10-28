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
          query: {
                multi_match: {
                    query: query,     
                    fields: ['body']
                }
            }
        })
    end

    # Delete the previous Messages index in Elasticsearch
    Message.__elasticsearch__.client.indices.delete index: Message.index_name rescue nil

    # Create the new index with the new mapping
    Message.__elasticsearch__.client.indices.create \
    index: Message.index_name,
    body: { settings: Message.settings.to_hash, mappings: Message.mappings.to_hash }

    # Index all Message records from the DB to Elasticsearch
    Message.import
end