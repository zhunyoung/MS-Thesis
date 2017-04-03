% **** Declaration Part ****
dice(d1; d2).
number(1..6).

% **** \tau(Pi) ****
owner(d1, mike).
owner(d2, john).
even(D, t) :- roll(D, N), N\2=0.
even(D, f) :- not even(D, t), dice(D).

:- roll(D, N1), roll(D, N2), N1 != N2.
:- even(D, t), even(D, f).
:- owner(D, P1), owner(D, P2), P1 != P2.

1{roll(D, N): number(N)}1 :- not intervene(roll(D)), dice(D).

% **** Possible Atoms ****

poss(r(D), roll(D, N)) :- not intervene(roll(D)), dice(D), number(N).


% **** Assigned Probability ****

possWithAssPr(r(D), owner(D, mike), roll(D, 5)) :- poss(r(D), roll(D, 5)), owner(D, mike).

assPr(r(D), owner(D, mike), roll(D, 5)) :- roll(D, 5), possWithAssPr(r(D), owner(D, mike), roll(D, 5)).

possWithAssPr(roll(D, 5)) :- possWithAssPr(r(D), owner(D, mike), roll(D, 5)).


possWithAssPr(r(D), owner(D, mike), roll(D, 6)) :- poss(r(D), roll(D, 6)), owner(D, mike).

assPr(r(D), owner(D, mike), roll(D, 6)) :- roll(D, 6), possWithAssPr(r(D), owner(D, mike), roll(D, 6)).

possWithAssPr(roll(D, 6)) :- possWithAssPr(r(D), owner(D, mike), roll(D, 6)).


% **** Denominator for Default Probability ****

possWithDefPr(roll(D, N)) :- poss(r(D), roll(D, N)), not possWithAssPr(roll(D, N)).

numDefPr(roll(D), X) :- roll(D, N), possWithDefPr(roll(D, N)), X=#count{Y: possWithDefPr(roll(D, Y))}.


% **** Numerator for Default Probability ****

remPr(roll(D), X) :- roll(D, N), possWithDefPr(roll(D, N)), Y=#sum{250: possWithAssPr(r(D), owner(D, mike), roll(D, 5)); 200: possWithAssPr(r(D), owner(D, mike), roll(D, 6))}, X=1000-Y.

totalDefPr(roll(D), X) :- remPr(roll(D), X), X>0.

:- remPr(roll(D), X), X<=0.


% **** Weak Constraints ****

:~ assPr(r(D), owner(D, mike), roll(D, 5)). [@minusln(250), D] % -ln(0.25)
:~ assPr(r(D), owner(D, mike), roll(D, 6)). [@minusln(200), D] % -ln(0.2)
:~ numDefPr(roll(D), X). [@minusln1over(X), D]
:~ totalDefPr(roll(D), X). [@minusln(X), D]

%#show roll/2.
%#show totalDefPr/2.