% **** Declaration Part ****
boolean(t; f).




% **** \tau(Pi) ****

:- male(t), male(f).
:- recover(t), recover(f).
:- drug(t), drug(f).

1{male(B): boolean(B)}1 :- not intervene(male).
1{recover(B): boolean(B)}1 :- not intervene(recover).
1{drug(B): boolean(B)}1 :- not intervene(drug).




% **** Possible Atoms ****

poss(r(1), male(B)) :- not intervene(male), boolean(B).
poss(r(2), recover(B)) :- not intervene(recover), boolean(B).
poss(r(3), drug(B)) :- not intervene(drug), boolean(B).




% **** Assigned Probability ****

possWithAssPr(r(1), male(t)) :- poss(r(1), male(t)).

assPr(r(1), male(t)) :- male(t), possWithAssPr(r(1), male(t)).

possWithAssPr(male(t)) :- possWithAssPr(r(1), male(t)).


% ****

possWithAssPr(r(2), c(1), recover(t)) :- poss(r(2), recover(t)), male(t), drug(t).

assPr(r(2), c(1), recover(t)) :- recover(t), possWithAssPr(r(2), c(1), recover(t)).

possWithAssPr(recover(t)) :- possWithAssPr(r(2), c(1), recover(t)).


possWithAssPr(r(2), c(2), recover(t)) :- poss(r(2), recover(t)), male(t), drug(f).

assPr(r(2), c(2), recover(t)) :- recover(t), possWithAssPr(r(2), c(2), recover(t)).

possWithAssPr(recover(t)) :- possWithAssPr(r(2), c(2), recover(t)).


possWithAssPr(r(2), c(3), recover(t)) :- poss(r(2), recover(t)), male(f), drug(t).

assPr(r(2), c(3), recover(t)) :- recover(t), possWithAssPr(r(2), c(3), recover(t)).

possWithAssPr(recover(t)) :- possWithAssPr(r(2), c(3), recover(t)).


possWithAssPr(r(2), c(4), recover(t)) :- poss(r(2), recover(t)), male(f), drug(f).

assPr(r(2), c(4), recover(t)) :- recover(t), possWithAssPr(r(2), c(4), recover(t)).

possWithAssPr(recover(t)) :- possWithAssPr(r(2), c(4), recover(t)).


% ****

possWithAssPr(r(3), c(5), drug(t)) :- poss(r(3), drug(t)), male(t).

assPr(r(3), c(5), drug(t)) :- drug(t), possWithAssPr(r(3), c(5), drug(t)).

possWithAssPr(drug(t)) :- possWithAssPr(r(3), c(5), drug(t)).


possWithAssPr(r(3), c(6), drug(t)) :- poss(r(3), drug(t)), male(f).

assPr(r(3), c(6), drug(t)) :- drug(t), possWithAssPr(r(3), c(6), drug(t)).

possWithAssPr(drug(t)) :- possWithAssPr(r(3), c(6), drug(t)).





% **** Denominator for Default Probability ****

possWithDefPr(male(B)) :- poss(r(1), male(B)), not possWithAssPr(male(B)).

numDefPr(male, X) :- male(B), possWithDefPr(male(B)), X=#count{Y: possWithDefPr(male(Y))}.


% ****

possWithDefPr(recover(B)) :- poss(r(2), recover(B)), not possWithAssPr(recover(B)).

numDefPr(recover, X) :- recover(B), possWithDefPr(recover(B)), X=#count{Y: possWithDefPr(recover(Y))}.


% ****

possWithDefPr(drug(B)) :- poss(r(3), drug(B)), not possWithAssPr(drug(B)).

numDefPr(drug, X) :- drug(B), possWithDefPr(drug(B)), X=#count{Y: possWithDefPr(drug(Y))}.





% **** Numerator for Default Probability ****

remPr(male, X) :- male(B), possWithDefPr(male(B)), Y=#sum{500: possWithAssPr(r(1), male(t))}, X=1000-Y.

totalDefPr(male, X) :- remPr(male, X), X>0.

:- remPr(male, X), X<=0.


% ****

remPr(recover, X) :- recover(B), possWithDefPr(recover(B)), Y=#sum{600: possWithAssPr(r(2), c(1), recover(t)); 700: possWithAssPr(r(2), c(2), recover(t)); 200: possWithAssPr(r(2), c(3), recover(t)); 300: possWithAssPr(r(2), c(4), recover(t))}, X=1000-Y.

totalDefPr(recover, X) :- remPr(recover, X), X>0.

:- remPr(recover, X), X<=0.


% ****

remPr(drug, X) :- drug(B), possWithDefPr(drug(B)), Y=#sum{750: possWithAssPr(r(3), c(5), drug(t)); 250: possWithAssPr(r(3), c(6), drug(t))}, X=1000-Y.

totalDefPr(drug, X) :- remPr(drug, X), X>0.

:- remPr(drug, X), X<=0.





% **** Weak Constraints ****

:~ assPr(r(1), male(t)). [@minusln(500), 1] % -ln(0.5)
:~ assPr(r(2), c(1), recover(t)). [@minusln(600), 2] % -ln(0.6)
:~ assPr(r(2), c(2), recover(t)). [@minusln(700), 3] % -ln(0.7)
:~ assPr(r(2), c(3), recover(t)). [@minusln(200), 4] % -ln(0.2)
:~ assPr(r(2), c(4), recover(t)). [@minusln(300), 5] % -ln(0.3)
:~ assPr(r(3), c(5), drug(t)). [@minusln(750), 6] % -ln(0.75)
:~ assPr(r(3), c(6), drug(t)). [@minusln(250), 7] % -ln(0.25)

:~ numDefPr(A, X). [@minusln1over(X), A] % -ln(1/X)
:~ totalDefPr(A, X). [@minusln(X), A] % -ln(X)





#show male/1.
#show recover/1.
#show drug/1.
%#show totalDefPr/2.