parent(hugh, sue).
parent(sue, andy).
parent(andy, joe).
parent(joe, peach).
parent(joe, plum).

% rules can have several definitions, only one of which must match - logical OR
ancestor(X, Y) :-
  parent(X, Y).

% recursive rules with proper tail calls
ancestor(X, Y) :-
  parent(X, Z),
  ancestor(Z, Y).

% We can query both sides of the relationship, so this
%  relation works for "ancestor" and "descendant".
% | ?- ancestor(joe, peach). % true
% | ?- ancestor(hugh, plum). % true
% | ?- ancestor(hugh, Who).  % sue, andy, joe, peach, plum
% | ?- ancestor(Who, joe).   % hugh, sue, andy


% factorial
% not tail-recursive - factorial(999999, W) causes a local stack overflow.
% factorial(35, W) causes integer overflow.
% factorial(34, W) is ~2^58.
% current_prolog_flag(max_integer, Max) and current_prolog_flag(min_integer, Min) 
%  show that, on this machine, Prolog uses 60bit signed integers.
factorial(0, 1).
factorial(N, Result) :-
  N > 0,                        % precondition
  N1 is N - 1,                   
  factorial(N1, NextFactorial), % recursively match the next step
  Result is N * NextFactorial.  % use the next step to compute result

% properly tail recursive factorial
% the second parameter is an accumulator
% it should be set to 1 at initial entry, but we can't
%  add a precondition because it's called recursively

% tail recursion eliminates the "local" stack overflow that factorial hits,
%  but factorial2(999999, 1, R) aborts with a global stack overflow at 32mb. In contrast
%  the non-tail-recursive form aborts with a "local" stack overflow at 16mb.
% TODO: find out why this happens. I don't know where the memory usage
%  comes from since the call is uses a proper tail call and integers
%  are fixed size.
factorial2(0, A, A).
factorial2(N, A, Result) :-
  N > 0,
  A1 is N * A,
  N1 is N - 1,
  factorial2(N1, A1, Result).

% A cleaner api for factorial2
factorial3(N, Result) :- factorial2(N, 1, Result).

% fibonacci
% my solution - not tail recursive
fib(0, 1).
fib(1, 1).
fib(N, Result) :-
  N > 1,
  N1 is N - 1,
  N2 is N - 2,
  fib(N1, Result1),
  fib(N2, Result2),
  Result is Result1 + Result2.

