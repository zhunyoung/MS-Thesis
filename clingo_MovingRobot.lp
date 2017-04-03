% **** Declaration Part ****
room(r1; r2; r3).

% **** \tau(Pi) ****
open(R, t) :- not open(R, f), room(R).
in(R) :- goIn(R), not ab(t).
ab(t) :- break(t).
goIn(r1).
break(t).

:- open(R, t), open(R, f).
:- in(R1), in(R2), R1!=R2.
:- goIn(R1), goIn(R2), R1!=R2.
:- ab(t), ab(f).
:- break(t), break(f).

in(r1); in(r2); in(r3) :- goIn(R), break(t), not intervene(in).
:- in(R1), not open(R1, t), goIn(R2), break(t), not intervene(in).


% **** Possible Atoms ****

poss(1, in(R1)) :- goIn(R2), break(t), open(R1, t), not intervene(in).


% **** Assigned Probability ****

possWithAssPr(1, c(1), in(R)) :- poss(1, in(R)), goIn(R), break(t).

assPr(1, c(1), in(R)) :- in(R), possWithAssPr(1, c(1), in(R)).

possWithAssPr(in(R)) :- possWithAssPr(1, c(1), in(R)).



% **** Denominator for Default Probability ****

possWithDefPr(in(R)) :- poss(1, in(R)), not possWithAssPr(in(R)).

numDefPr(in, X) :- in(R), possWithDefPr(in(R)), X=#count{Y: possWithDefPr(in(Y))}.


% **** Numerator for Default Probability ****

remPr(in, X) :- in(R), possWithDefPr(in(R)), Y=#sum{500: possWithAssPr(1, c(1), in(R1))}, X=1000-Y.

totalDefPr(in, X) :- remPr(in, X), X>0.

:- remPr(in, X), X<=0.


% **** Weak Constraints ****

:~ assPr(1, c(1), in(R)). [@minusln(500)] % -ln(0.5)
:~ numDefPr(in, X). [@minusln1over(X), numDefPr]
:~ totalDefPr(in, X). [@minusln(X), totalDefPr]

%#show in/1.
%#show totalDefPr/2.