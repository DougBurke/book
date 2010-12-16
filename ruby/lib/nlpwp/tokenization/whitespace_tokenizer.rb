module Tokenization

  class WhitespaceTokenizer
    private_class_method :new
  
    def self.tokenize(sentence)
      Enumerable::Enumerator.new(sentence.strip.split(/\s+/))
    end
end

end