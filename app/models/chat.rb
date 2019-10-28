class Chat < ApplicationRecord
    #Setup relationship and remove it on DESTROY
    has_many :messages, dependent: :destroy

    #belongs to the application model
    belongs_to :application, counter_cache: true

    #validate the name input (Required from the client!)
    validates :name, presence: true, length: {minimum: 3}

    #Set the route param
    def to_param 
        token
    end
end
