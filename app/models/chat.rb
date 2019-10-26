class Chat < ApplicationRecord
    #Setup relationship and remove it on DESTROY
    has_many :messages, dependent: :destroy

    #belongs to the application model
    belongs_to :application

    #validate the name input (Required from the client!)
    validates :name, presence: true, length: {minimum: 3}
end
