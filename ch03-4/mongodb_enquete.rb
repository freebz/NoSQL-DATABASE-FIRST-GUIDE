class Enquete
  include MongoMapper::Document

  key :name, String, :required => true
  timestamps!
  many :questions
end

