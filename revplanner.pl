%:- reconsult('prolog adts').
%:-[adts].
:-[adts].

/* Updated initial and goal states */
initial_state([handempty, on(a, b), on(b, c), on(c, d), ontable(d), clear(a)]).

goal_state([handempty, on(d, c), on(c, b), on(b, a), ontable(a)]).

plan(State, Goal, _, Moves) :-
    equal_set(State, Goal),
    write('moves are'), nl,
    reverse_print_stack(Moves).
plan(State, Goal, Been_list, Moves) :-
    move(Name, Preconditions, Actions),
    conditions_met(Preconditions, State),
    change_state(State, Actions, Child_state),
    not(member_state(Child_state, Been_list)),
    stack(Child_state, Been_list, New_been_list),
    stack(Name, Moves, New_moves),
    plan(Child_state, Goal, New_been_list, New_moves),!.

change_state(S, [], S).
change_state(S, [add(P)|T], S_new) :-
    change_state(S, T, S2),
    add_to_set(P, S2, S_new), !.
change_state(S, [del(P)|T], S_new) :-
    change_state(S, T, S2),
    remove_from_set(P, S2, S_new), !.
conditions_met(P, S) :- subset1(P, S).

member_state(S, [H|_]) :-
    equal_set(S, H).
member_state(S, [_|T]) :-
    member_state(S, T).

reverse_print_stack([]).
reverse_print_stack([H|T]) :-
    reverse_print_stack(T),
    write(H), nl.

/* Updated sample moves for inversion */

move(stack(X, Y), [handempty, clear(X), on(X, Z), clear(Y)],
    [del(handempty), del(clear(X)), del(on(X, Z)),
                add(handempty), add(clear(Y)), add(on(Y, X))]).

move(unstack(X, Y), [handempty, on(Y, X), clear(X)],
    [del(handempty), del(on(Y, X)), del(clear(X)),
                add(handempty), add(clear(Y)), add(on(X, Y))]).

go :-
    initial_state(InitialState),
    goal_state(GoalState),
    plan(InitialState, GoalState, [InitialState], []).

test :- go.
