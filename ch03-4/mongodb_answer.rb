class Answer
  include MongoMapper::Document

  key :user_id, Integer, :required => true
  key :enquete_id, String, :required => true
  timestamps!
end

