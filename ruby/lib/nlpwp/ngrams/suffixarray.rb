module NGrams
  # This class holds a suffix array. A suffix array is a sorted array
  # of suffixes within a data array. For instance, the suffix array
  # constructed from <tt>['to', 'be', 'or', 'not', 'to', 'be']</tt>
  # contains the following elements:
  #
  # * <tt>["be"]</tt>
  # * <tt>["be", "or", "not", "to", "be"]</tt>
  # * <tt>["not", "to", "be"]</tt>
  # * <tt>["or", "not", "to", "be"]</tt>
  # * <tt>["to", "be"]</tt>
  # * <tt>["to", "be", "or", "not", "to", "be"]</tt>
  #
  class SuffixArray
    include Enumerable
    
    # Construct a suffix array from a data array.
    def initialize(data)
      @data = data
      @indices = (0...data.size).to_a
      
      @indices.sort! { |a, b|
        data[a..-1] <=> data[b..-1]
      }
    end
    
    # Extract a suffix from the suffix array.
    def [](idx)
      @data[@indices[idx]..-1]
    end
    
    # Calls _block_ once for each suffix in the suffix array, passing
    # that suffix as a parameter.
    def each # :yields: suffix
      @indices.each { |i|
        yield @data[i..-1]
      }
    end
    
    def size
      @data.size
    end
  end
end