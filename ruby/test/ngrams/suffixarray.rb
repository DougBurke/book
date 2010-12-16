require 'nlpwp/ngrams/suffixarray'
require 'test/unit'

class TestSuffixArray < Test::Unit::TestCase
  def test_empty
    sa = NGrams::SuffixArray.new([])
    assert_equal(0, sa.size)
  end
  
  def test_equal_elems
    sa = NGrams::SuffixArray.new(["check", "check", "check"])
    assert_equal(3, sa.size)
    assert_equal(["check"], sa[0])
    assert_equal(["check", "check"], sa[1])
    assert_equal(["check", "check", "check"], sa[2])    
  end
  
  def test_to_be
    sa = NGrams::SuffixArray.new("to be or not to be".split)
    assert_equal(6, sa.size)
    assert_equal(["be"], sa[0])
    assert_equal("be or not to be".split, sa[1])
    assert_equal("not to be".split, sa[2])
    assert_equal("or not to be".split, sa[3])
    assert_equal("to be".split, sa[4])
    assert_equal("to be or not to be".split, sa[5])
  end
end