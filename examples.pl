% examples for functional prolog mini-lib

% FIXME: macro rewrite doesnt accur when importing as a module
% :- use_module(functional, [term_expansion/2, '<<'/2, '<-'/2]).
:- [functional].

%%%%%%%  EXAMPLES

% simple erlang-like erithmetic function
% the last statement is the value to be returned
fun(X) ->
	A <- X*2,
	B <- X+2,
	A*B.

:- V <- fun(3), assertion(V =@= 30). % 30

% multi-clause definitions and list matching
squaremap([]) -> [].
squaremap([H|T]) -> [(H*H) | squaremap(T)].

:- V <- squaremap([1,2,3,4,5]),
    assertion(V =@= [1, 4, 9, 16, 25]).

% built-in predicates that return result in last argument can be used as well...
:- A <- append( [1,2], [3,4] ),
    assertion(A =@= [1,2,3,4]).

% ... as can higher order functions. function calls can be nested.
add2(X) -> 2 + X.
listFun(X) -> append( maplist(add2, X), X ).

:- A <- listFun( [1,2,3] ),
    assertion(A =@= [3,4,5,1,2,3]).

% arithmetic expressions are computed even inside lists
listFun2(X) ->
	A <- [1,2],
	B <- append([1+2], [2*2]),
	append(A, append(B, append([5], X))).

:- A <- listFun2([6,7]),
    assertion(A =@=[1,2,3,4,5,6,7]).

% simple one argument facts can be retrieved with << operator
fact([prolog, 'is', cool]).
:-	Fact << fact,
	S <- append(['fact:'], Fact),
	assertion(S =@= ['fact:', prolog, is, cool]).

:- halt(0).
