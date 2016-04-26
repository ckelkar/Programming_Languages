--Author: Chinmay Kelkar
--Took a reference from internet to solve some problems.

--problem1
--Function which produces produces the infinite list containing the elements f n, f (n + 1), f (n + 2), ....
map_ints_from y id= y : (map_ints_from (succ y) id)

--problem2
--Function which produces an infinite list all of whose elements are equal to that given argument.
constant_list x = concat(repeat(take 1 (map_ints_from x id)))

--problem3
--Function which produces multiples of given argument
multiples x =  filter (\n ->  (n `mod` x == 0)) (map_ints_from x id)

--problem4
--Function which returns an infinite list containing all the rows of the Pascal Triangle
addwith function xs [] = xs
addwith function [] ys = ys
addwith function (x:xs) (y:ys) = function x y : addwith function xs ys
extendWith function [] = []
extendWith function xs@(x:ys) = x : addwith function xs ys
start=1
pascal = iterate (extendWith (+)) [start]

----problem6
--Function which maps the function to the given list and  displays list
my_map :: (a -> b) -> [a] -> [b]
my_map f xs   = foldr (\x xs -> (f x):xs) [] xs

--problem7
--Function which reduces the tree given by the first argument using the functions specified by the 2nd and 3rd arguments
data VTree a =
	VLeaf a 
	|VNode (VTree a) a (VTree a)
	deriving (Eq, Show)
reduce_tree :: VTree a -> (a -> b) -> (b -> a -> b -> b) -> b
reduce_tree (VNode lefttree root righttree) leaf_fn node_fn = node_fn (reduce_tree lefttree leaf_fn node_fn) root (reduce_tree righttree leaf_fn node_fn)
reduce_tree (VLeaf a) leaf_fn node_fn = leaf_fn (a)

-- Problem 8
-- Map function f to values stored in tree.
map_tree f tree =
  reduce_tree tree leaf_map node_map
  where
    leaf_map v = (VLeaf (f v))
    node_map t1 v t2 = (VNode t1 (f v) t2)


--problem9
--Function which produces list of values stored in the tree
tree_to_list (VLeaf x) = [x]
tree_to_list (VNode left root right) = tree_to_list left++[root]++tree_to_list right



