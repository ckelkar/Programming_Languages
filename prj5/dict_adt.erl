-module(dict_adt).
-export([get/2, update/3, iterator/1, add_all/2, to_list/1]).
-include("dict.hrl").
-include("iterator.hrl").

%Return value stored for Key in dictionary Dict.
get(Dict, Key) ->
    Get = Dict#dict.get,
    Get(Dict#dict.data, Key).

%Update value stored for Key in dictionary Dict, returning updated
%data representation.  Update1 is a function which takes the current
%value stored for Key and returns the new value.  If the Key is not
%present, then Update1 will be called with value [].
update(Dict, Key, Update1) ->
    Update = Dict#dict.update,
    Dict#dict{data=Update(Dict#dict.data, Key, Update1)}.

%Returns a iterator for Dict which produces {Key, Value} pairs.
iterator(Dict) ->
    Iterator = Dict#dict.iterator,
    Iterator(Dict#dict.data).


%A convenience function function which adds all {Key, Value} pairs in
%2nd argument to Dict.  The 2nd argument can be either a list of {Key,
%Value} pairs or a iterator which produces {Key, Value} pairs.
add_all(Dict, []) ->
    Dict;
add_all(Dict, [{K, V}|Rest]) ->
  add_all(update(Dict, K, fun(_) -> V end), Rest);
add_all(Dict, Iterator) when is_record(Iterator, iterator) ->
    add_all_iterator(Dict, Iterator).

add_all_iterator(Dict, Iterator) ->
    case iterator:has_next(Iterator) of
	true ->
	    {K, V} = iterator:get_next(Iterator),
	    add_all_iterator(update(Dict, K, fun(_) -> V end),
			     iterator:advance(Iterator));
	false -> Dict
     end.
						      
%A convenience function which produces a list of all {Key, Value} pairs
%contained in Dict.
to_list(Dict) ->
    I = iterator(Dict),
    iterator:to_list(I).

				  
