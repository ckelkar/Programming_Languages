
-module(bst_dict).
-export([bst_dict/0]).
-include("dict.hrl").
-include("iterator.hrl").
-define(EMPTY,empty).

bst_dict() ->
    #dict{get = fun get/2, update = fun update/3, iterator = fun iterator/1, 
	  data = ?EMPTY }.


get(?EMPTY , _ ) -> [];

get(BST_TREE, KEY) ->
  case BST_TREE of
     ?EMPTY  -> {};
	{ROOT,VALUE, LHS, RHS} ->
      if
        KEY == ROOT -> VALUE;
        KEY < ROOT -> get(LHS, KEY);
        KEY > ROOT -> get(RHS, KEY)
      end
  end.



update(BST_TREE, KEY ,Update) ->
  case BST_TREE of
    ?EMPTY  -> {KEY,Update([]),?EMPTY ,?EMPTY  };
    {ROOT,VALUE, LHS,RHS} ->
      if
        KEY == ROOT -> BST_TREE;
        KEY < ROOT -> {ROOT,VALUE, update(LHS,KEY ,Update),RHS };
        KEY > ROOT -> {ROOT,VALUE, LHS, update(RHS, KEY ,Update)}
      end
  end.


iterator(List) ->
    #iterator{has_next = fun has_next/1, get_next = fun get_next/1,advance = fun advance/1, state = List}.

has_next([]) ->
    false;
has_next([_|_]) ->
    true.

get_next([Pair|_]) ->
    Pair.

advance([_|Rest]) ->
    Rest.

