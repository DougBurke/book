module Corpus
  
  # Mixin for classes that read text corpora.
  module TextCorpus

    # Returns an enumerator over all tokenized sentences in a corpus.
    def sentences
      Enumerable::Enumerator.new(self, :each_sentence)
    end

    # Returns an enumerator over all tokens in a corpus.
    def tokens
      Enumerable::Enumerator.new(self, :each_token)
    end
  end
end