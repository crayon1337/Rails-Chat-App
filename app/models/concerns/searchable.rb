# frozen_string_literal: true

# Integrate Elastic Search with Model
module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
  end
end
