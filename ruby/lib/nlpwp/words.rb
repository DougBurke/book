require 'set'

module Words
  def self.palindrome?(str)
    str == str.reverse
  end
  
  def self.avgLength(items)
    lengths = items.map { |i| i.length }
    sum = lengths.reduce { |sum, e| sum + e }
    sum.to_f / items.length
  end
  
  def self.splitTokenize(text)
    sents = text.split("\n")
    sents.map {|s| s.split }
  end
  
  def self.wordSet(tokens)
    tokens.reduce(Set.new) { |words, token| words.add(token) }
  end
  
  def self.freqList(tokens)
    tokens.reduce(Hash.new(0)) { |freqs, token|
      freqs[token] += 1
      freqs
    }
  end
end

class String
  def palindrome?
    self == self.reverse
  end
end
