:- [adts].

% Define the initial state and goal state for the 8-puzzle problem
initial_state([1, 2, 3, 4, 5, 6, 7, 8, 0]).
goal_state([1, 2, 3, 8, 0, 4, 7, 6, 5]).

% Define the moves predicate for the 8-puzzle problem
moves(State, _, _, ChildState) :-
    select(0, State, V, State1),
    select(V, State1, 0, ChildState).

% Define the precedes predicate for the priority queue
precedes([_, _, Cost1], [_, _, Cost2]) :- Cost1 < Cost2.

% Define breadth-first search
breadth_first_search(StartState, GoalState, Solution) :-
    empty_queue(Empty_open),
    enqueue([StartState, nil, 0], Empty_open, Open_queue),
    empty_set(Closed_set),
    path_bfs(Open_queue, Closed_set, GoalState, Solution).

path_bfs(Open_queue, _, _, _) :-
    empty_queue(Open_queue),
    write('No solution found with these rules'), nl.

path_bfs(Open_queue, Closed_set, GoalState, Solution) :-
    dequeue([State, Parent, Cost], Rest_open_queue, Open_queue),
    State = GoalState,
    write('A Solution is Found!'), nl,
    build_solution([State, Parent, Cost], Closed_set, Solution).

path_bfs(Open_queue, Closed_set, GoalState, Solution) :-
    dequeue([State, Parent, Cost], Rest_open_queue, Open_queue),
    get_children_bfs(State, Cost, Rest_open_queue, Closed_set, Children),
    enqueue_list(Children, Rest_open_queue, New_open_queue),
    union1([[State, Parent, Cost]], Closed_set, New_closed_set),
    path_bfs(New_open_queue, New_closed_set, GoalState, Solution), !.

get_children_bfs(State, Cost, Rest_open_queue, Closed_set, Children) :-
    bagof([ChildState, State, NewCost],
          (moves(State, Cost, Rest_open_queue, ChildState), NewCost is Cost + 1),
          Children);
    empty_set(Children).

build_solution([State, nil, Cost], _, [State, nil, Cost]) :- !.
build_solution([State, Parent, Cost], Closed_set, [[State, Parent, Cost] | RestSolution]) :-
    member_set([Parent, Grandparent, _], Closed_set),
    build_solution([Parent, Grandparent, _], Closed_set, RestSolution).

% Run the breadth-first search
solve_breadth_first :-
    initial_state(InitialState),
    goal_state(GoalState),
    breadth_first_search(InitialState, GoalState, Solution),
    write('Solution Path: '), nl,
    print_solution_path(Solution).

print_solution_path([]).
print_solution_path([[State, _, _] | Rest]) :-
    write(State), nl,
    print_solution_path(Rest).

% Call solve_breadth_first to test
