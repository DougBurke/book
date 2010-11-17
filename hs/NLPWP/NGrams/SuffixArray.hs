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

contains :: Ord a => SuffixArray a -> V.Vector a -> Bool
contains a n = restrict V.! index == n
    where index = binarySearch restrict n
          restrict = V.map (V.take needleLength) $ elems a
          needleLength = V.length n

binarySearch :: (Ord a) => V.Vector (V.Vector a) -> V.Vector a -> Int
binarySearch v n = binarySearchBounded v n 0 (V.length v - 1)

binarySearchBounded :: (Ord a) => V.Vector (V.Vector a) -> V.Vector a ->
                       Int -> Int -> Int
binarySearchBounded = binarySearchByBounded compare

binarySearchByBounded :: (Ord a) => (V.Vector a -> V.Vector a -> Ordering) ->
                         V.Vector (V.Vector a) -> V.Vector a -> Int -> Int ->
                         Int
binarySearchByBounded cmp v e lower upper
    | upper <= lower = lower
    | otherwise = case cmp e (v V.! middle) of
                    LT -> binarySearchByBounded cmp v e lower middle
                    EQ -> middle
                    GT -> binarySearchByBounded cmp v e (middle + 1) upper
    where middle = (lower + upper) `div` 2