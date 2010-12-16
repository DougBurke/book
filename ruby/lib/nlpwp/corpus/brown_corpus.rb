require 'nlpwp/corpus/tagged_corpus.rb'
require 'nlpwp/corpus/text_corpus.rb'
require 'nlpwp/tokenization/whitespace_tokenizer.rb'

module Corpus  
  class BrownCorpus
    include TaggedCorpus
    include TextCorpus
    
    def initialize(filename)
      @filename = filename
    end
    
    def each_sentence
      corpusFile = File.new(@filename, "r")
      
      corpusFile.each_line { |line|
        next if line.strip.length == 0
        
        tokens =
          Tokenization::WhitespaceTokenizer::tokenize(line).map { |tagToken|
            (token, _, _) = tagToken.rpartition('/')
            token
          }
          
          yield tokens
      }
    end
    
    def each_tagged_sentence
      corpusFile = File.new(@filename, "r")
      
      corpusFile.each_line { |line|
        next if line.strip.length == 0
        
        taggedTokens =
          Tokenization::WhitespaceTokenizer::tokenize(line).map { |tagToken|
            (token, _, tag) = tagToken.rpartition('/')
            TaggedWord.new(token, tag)
          }
          
          yield taggedTokens        
      }
    end
    
    def each_tagged_token
      each_tagged_sentence { |taggedSentence|
        taggedSentence.each { |taggedToken|
          yield taggedToken
        }
      }
    end
    
    def each_token
      each_sentence { |sentence|
        sentence.each { |token|
          yield token
        }
      }
    end
  end
end