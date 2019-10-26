class Application < ApplicationRecord
    #Setup relationship and remove it on DESTROY
    has_many :chats, dependent: :destroy

    #validate the name input (Required from the client!)
    validates :name, presence: true, length: {minimum: 3}

    #Set the route param
    def to_param 
        token
    end
end
