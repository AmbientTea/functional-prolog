% :- module(functional, [term_expansion/2, '<-'/2, '<<'/2]).

% assignment from expression
:- op(700, xfy, <-).
<-(X, Y) :- fexpCompute(Y, X).

% assignment from single-argument fact clauses
:-op(700, xfy, <<).
<<(X,Y) :- call(Y, X).

% this macro translates -> function notation into normal clauses
:- multifile(term_expansion).
:- dynamic(term_expansion).
term_expansion( X -> Body , Clause ) :-
	X =.. [Func | Args],
	append( [Func | Args], [Ret], ClauseL ),
	ClauseF =.. ClauseL,
	putReturn(Body, Ret, NewBody),
	Clause = :-(ClauseF, NewBody).

% (internal) substitutes last statement in a clause with an assignment
putReturn( Body, Ret, ','(H, NewBody) ) :-
	Body = ','(H, T),
	putReturn(T, Ret, NewBody).
putReturn(Stmt, Ret, Ret <- Stmt).


% fexpCompute( Expression, Value )
% computes value for a given term represented expression
% we cut after each match because next ones produce either garbage or errors

% built in types are already computed
fexpCompute( Exp, Exp ) :- (integer(Exp) ; float(Exp); atom(Exp)), !.

% need to manualy map the list, since listmap behaves weirdly
fexpCompute([], []) :- !.
fexpCompute([InH | InT], [OutH | OutT]) :- fexpCompute(InH, OutH), fexpCompute(InT, OutT), !.

% function application
fexpCompute( Exp, Val ) :-
	Exp =.. [Func | Args],
    current_predicate(Func, _),
	maplist(fexpCompute, Args, ArgVals ),
	append(ArgVals, [Val], FArgs),
	apply(Func, FArgs), !.

% anything else is either an arithmetic expression or garbage
fexpCompute(Exp, Val) :- Val is Exp, !.

