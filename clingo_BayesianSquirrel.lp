% **** Declaration Part ****
patch(p1;p2).
day(1..5).
boolean(t;f).

% **** \tau(Pi) ****
found(P,D,f) :- not found(P,D,t), patch(P), day(D).

:- found(P,D,t), found(P,D,f).
:- hiddenIn(p1), hiddenIn(p2).
:- look(D,p1), look(D,p2).

hiddenIn(p1); hiddenIn(p2) :- not intervene(hiddenIn).
found(P,D,t); found(P,D,f) :- hiddenIn(P), look(D,P), not intervene(found(P,D)).

do(look(1,p1)).
look(1,p1) :- do(look(1,p1)).
intervene(look(1)) :- do(look(1,p1)).



% **** Possible Atoms ****

poss(r(1), hiddenIn(P)) :- not intervene(hiddenIn), patch(P).
poss(r(2), found(P,D,B)) :- hiddenIn(P), look(D,P), not intervene(found(P,D)), boolean(B).




% **** Assigned Probability ****

possWithAssPr(r(1), hiddenIn(p1)) :- poss(r(1), hiddenIn(p1)).

assPr(r(1), hiddenIn(p1)) :- hiddenIn(p1), possWithAssPr(r(1), hiddenIn(p1)).

possWithAssPr(hiddenIn(p1)) :- possWithAssPr(r(1), hiddenIn(p1)).


possWithAssPr(r(2), found(P,D,t)) :- poss(r(2), found(P,D,t)).

assPr(r(2), found(P,D,t)) :- found(P,D,t), possWithAssPr(r(2), found(P,D,t)).

possWithAssPr(found(P,D,t)) :- possWithAssPr(r(2), found(P,D,t)).




% **** Denominator for Default Probability ****

possWithDefPr(hiddenIn(P)) :- poss(r(1), hiddenIn(P)), not possWithAssPr(hiddenIn(P)).

numDefPr(hiddenIn, X) :- hiddenIn(P), possWithDefPr(hiddenIn(P)), X=#count{Y: possWithDefPr(hiddenIn(Y))}.

possWithDefPr(found(P,D,B)) :- poss(r(2), found(P,D,B)), not possWithAssPr(found(P,D,B)).

numDefPr(found(P,D), X) :- found(P,D,B), possWithDefPr(found(P,D,B)), X=#count{Y: possWithDefPr(found(P,D,Y))}.


% **** Numerator for Default Probability ****

remPr(hiddenIn, X) :- hiddenIn(P), possWithDefPr(hiddenIn(P)), Y=#sum{800: possWithAssPr(r(1), hiddenIn(p1))}, X=1000-Y.

totalDefPr(hiddenIn, X) :- remPr(hiddenIn, X), X>0.

:- remPr(hiddenIn, X), X<=0.

remPr(found(P,D), X) :- hiddenIn(P), look(D,P), found(P,D,B), possWithDefPr(found(P,D,B)), Y=#sum{200: possWithAssPr(r(2), found(P,D,t))}, X=1000-Y.

totalDefPr(found(P,D), X) :- remPr(found(P,D), X), X>0.

:- remPr(found(P,D), X), X<=0.

% **** Weak Constraints ****

:~ assPr(r(1), hiddenIn(p1)). [@minusln(800)] %-ln(0.8)
:~ assPr(r(2), found(P,D,t)). [@minusln(200), P,D] %-ln(0.2)
:~ numDefPr(hiddenIn, X). [@minusln1over(X), numDefPr]
:~ numDefPr(found(P,D), X). [@minusln1over(X), P,D, numDefPr]
:~ totalDefPr(hiddenIn, X). [@minusln(X), totalDefPr]
:~ totalDefPr(found(P,D), X). [@minusln(X), P,D, totalDefPr]