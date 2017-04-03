door(1..400).

% **** \tau(\Pi) ****

can_open(D,f) :- selected(D).
can_open(D,f) :- prize(D).
can_open(D,t) :- not can_open(D,f), door(D).

:- can_open(D,t), can_open(D,f).
:- prize(D1), prize(D2), D1!=D2.
:- selected(D1), selected(D2), D1!=D2.
:- open(D1), open(D2), D1!=D2.

1{prize(D): door(D)}1 :- not intervene(prize).
1{selected(D): door(D)}1 :- not intervene(selected).
1{open(D): door(D)}1 :- not intervene(open).
:- open(D), not can_open(D,t), not intervene(open).

obs(selected, 1).
:- obs(selected, 1), not selected(1).
obs(open, 2).
:- obs(open, 2), not open(2).
nobs(prize, 2).
:- nobs(prize, 2), prize(2).



% **** Possible Atoms ****

poss(prize, D) :- not intervene(prize), door(D).
poss(selected, D) :- not intervene(selected), door(D).
poss(open, D) :- not intervene(open), can_open(D,t), door(D).

% **** Assigned Probability ****

possWithAssPr(prize, 1) :- poss(prize, 1).
assPr(prize, 1) :- prize(1), possWithAssPr(prize, 1).

possWithAssPr(prize, 3) :- poss(prize, 3).
assPr(prize, 3) :- prize(3), possWithAssPr(prize, 3).


% **** Denominator for Default Probability ****

possWithDefPr(C, D) :- poss(C, D), not possWithAssPr(C, D).

numDefPr(prize, X) :- prize(D), possWithDefPr(prize, D), X=#count{Y: possWithDefPr(prize, Y)}.
numDefPr(selected, X) :- selected(D), possWithDefPr(selected, D), X=#count{Y: possWithDefPr(selected, Y)}.
numDefPr(open, X) :- open(D), possWithDefPr(open, D), X=#count{Y: possWithDefPr(open, Y)}.

% **** Numerator for Default Probability ****

remPr(prize, Y) :- prize(D), possWithDefPr(prize, D), X=#sum{300: possWithAssPr(prize, 1); 200: possWithAssPr(prize, 3)}, Y=1000-X.

totalDefPr(prize, X) :- remPr(prize, X), X>0.
:- remPr(prize, X), X<=0.


% **** weak constraints ****

:~ assPr(prize, 1). [@minusln(300), 1]
:~ assPr(prize, 3). [@minusln(200), 2]
:~ numDefPr(A, K). [@minusln1over(K), A,K,3]
:~ totalDefPr(prize, X). [@minusln(X), X,4]