module Corpus
  TaggedWord = Struct.new(:word, :tag)
  
  # Mixin for classes that read tagged corpora.
  module TaggedCorpus

    # Returns an enumerator over all tagged sentences in a corpus.
    def tagged_sentences
      Enumerable::Enumerator.new(self, :each_tagged_sentence)
    end
    
    # Returns an enumerator over all tagged tokens in a corpus.
    def tagged_tokens
      Enumerable::Enumerator.new(self, :each_tagged_token)
    end
  end
end