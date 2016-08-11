class Question
  include MongoMapper::EmbeddedDocument

  key :body, Array, :required => true
  key :type, String, :required => true
  key :choices, Array
  key :required_column, Boolean, :default => false
end

