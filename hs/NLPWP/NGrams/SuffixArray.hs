import qualified Data.Bits as B
import qualified Data.List as L
import qualified Data.Vector as V
import qualified Data.Vector ((!))

data SuffixArray a = SuffixArray (V.Vector a) (V.Vector Int)
                     deriving Show

fromList :: Ord a => [a] -> SuffixArray a
fromList = suffixArray . V.fromList

toList :: SuffixArray a -> [[a]]
toList (SuffixArray d i) = V.foldr vecAt [] i
    where vecAt idx l = V.toList (V.drop idx d) : l 

elems :: SuffixArray a -> V.Vector (V.Vector a)
elems (SuffixArray d i) = V.map vecAt i
    where vecAt idx = V.drop idx d

suffixArray :: Ord a => V.Vector a -> SuffixArray a
suffixArray = suffixArrayBy compare

suffixArrayBy :: Ord a => (V.Vector a -> V.Vector a -> Ordering) ->
                 V.Vector a -> SuffixArray a
suffixArrayBy cmp d = SuffixArray d (V.fromList srtIndex)
    where uppBound = V.length d - 1
          usrtIndex = [0..uppBound]
          srtIndex = L.sortBy (saCompare cmp d) usrtIndex

saCompare :: Ord a => (V.Vector a -> V.Vector a -> Ordering) ->
             V.Vector a -> Int -> Int -> Ordering
saCompare cmp d a b = cmp (V.drop a d) (V.drop b d)

binarySearch :: (Ord a) => V.Vector a -> a -> Maybe Int
binarySearch v e = binarySearchBounded v e 0 (V.length v - 1)

binarySearchBounded :: (Ord a) => V.Vector a -> a -> Int -> Int -> Maybe Int
binarySearchBounded = binarySearchByBounded compare

binarySearchBy :: (Ord a) => (a -> a -> Ordering) -> V.Vector a -> a ->
                  Maybe Int
binarySearchBy cmp v n = binarySearchByBounded cmp v n 0 (V.length v - 1)

binarySearchByBounded :: (Ord a) => (a -> a -> Ordering) -> V.Vector a ->
                         a -> Int -> Int -> Maybe Int
binarySearchByBounded cmp v e lower upper
    | V.null v      = Nothing
    | upper < lower = Nothing
    | otherwise     = case cmp e (v V.! middle) of
                        LT -> binarySearchByBounded cmp v e lower (middle - 1)
                        EQ -> Just middle
                        GT -> binarySearchByBounded cmp v e (middle + 1) upper
    where middle    = (lower + upper) `div` 2

contains :: Ord a => SuffixArray a -> V.Vector a -> Bool
contains s e = case binarySearch (restrict eLen s) e of
                 Just _  -> True
                 Nothing -> False
    where eLen = V.length e
          restrict len = V.map (V.take len) . elems

lowerBoundByBounds :: Ord a => (a -> a -> Ordering) -> V.Vector a -> a ->
                      Int -> Int -> Maybe Int
lowerBoundByBounds cmp v e lower upper
    | V.null v = Nothing
    | upper == lower = case cmp e (v V.! lower) of
                         EQ -> Just lower
                         _  -> Nothing
    | otherwise = case cmp e (v V.! middle) of
                    GT -> lowerBoundByBounds cmp v e (middle + 1) upper
                    _  -> lowerBoundByBounds cmp v e lower middle
    where middle = (lower + upper) `div` 2

lowerBoundBounds :: Ord a => V.Vector a -> a -> Int -> Int -> Maybe Int
lowerBoundBounds = lowerBoundByBounds compare

lowerBoundBy :: Ord a => (a -> a -> Ordering) -> V.Vector a -> a -> Maybe Int
lowerBoundBy cmp v e = lowerBoundByBounds cmp v e 0 (V.length v - 1)

lowerBound :: Ord a => V.Vector a -> a -> Maybe Int
lowerBound = lowerBoundBy compare

upperBoundByBounds :: Ord a => (a -> a -> Ordering) -> V.Vector a -> a ->
                      Int -> Int -> Maybe Int
upperBoundByBounds cmp v e lower upper
    | V.null v       = Nothing
    | upper <= lower = case cmp e (v V.! lower) of
                         EQ -> Just lower
                         _  -> Nothing
    | otherwise      = case cmp e (v V.! middle) of
                         LT -> upperBoundByBounds cmp v e lower (middle - 1)
                         _  -> upperBoundByBounds cmp v e middle upper
    where middle     = ((lower + upper) `div` 2) + 1

upperBoundBounds :: Ord a => V.Vector a -> a -> Int -> Int -> Maybe Int
upperBoundBounds = upperBoundByBounds compare

upperBoundBy :: Ord a => (a -> a -> Ordering) -> V.Vector a -> a -> Maybe Int
upperBoundBy cmp v e = upperBoundByBounds cmp v e 0 (V.length v - 1)

upperBound :: Ord a => V.Vector a -> a -> Maybe Int
upperBound = upperBoundBy compare

frequencyByBounds :: Ord a => (a -> a -> Ordering) -> V.Vector a -> a ->
                     Int -> Int -> Maybe Int
frequencyByBounds cmp v e lower upper = do
  lower <- lowerBoundByBounds cmp v e lower upper
  upper <- upperBoundByBounds cmp v e lower upper
  return $ upper - lower + 1

frequencyBy :: Ord a => (a -> a -> Ordering) -> V.Vector a -> a ->
               Maybe Int
frequencyBy cmp v e = frequencyByBounds cmp v e 0 (V.length v - 1)

frequencyBounds :: Ord a => V.Vector a -> a -> Int -> Int -> Maybe Int
frequencyBounds = frequencyByBounds compare

frequency :: Ord a => V.Vector a -> a -> Maybe Int
frequency = frequencyBy compare

containsWithFreq :: Ord a => SuffixArray a -> V.Vector a -> Maybe Int
containsWithFreq s e = frequency (restrict eLen s) e
    where eLen = V.length e
          restrict len = V.map (V.take len) . elems

