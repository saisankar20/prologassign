/* SB23BB SAI THARUN  */

investment(savings) :- savings_account(inadequate).
investment(stocks) :- savings_account(adequate), income(adequate).
investment(combination) :- savings_account(adequate), income(inadequate).

savings_account(adequate) :- amount_saved(X), dependents(Y), minsavings(Y, B), X > B.
savings_account(inadequate) :- amount_saved(X), dependents(Y), minsavings(Y, B), not(X > B).

income(adequate) :- earnings(X, steady), dependents(Y), minincome(Y, B),Y > B.
income(inadequate) :- earnings(X, steady), dependents(Y), minincome(Y, B), not(X > B).
income(inadequate) :- earnings(_, unsteady).

minsavings(A, B) :- B is 5000 * A.
minincome(A, B) :- B is 15000 + (4000 * A).

amount_saved(22000).
earnings(25000, steady).
dependents(3).
