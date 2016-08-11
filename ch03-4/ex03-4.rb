class Enquete
  include MongoMapper::Document

  key :name, String, :required => true
  timestamps!

  # 여러 questions 콜렉션을 포함(embed)한다
  many :questions
end

class Question
  include MongoMapper::EmbeddedDocument

  key :body, Array, :required => true
  key :type, String :required => true
  key :choices, Array	# 응답 시 선택항목
  key :required_column, Boolean, :default => false
end

