    print_separator(N),
    print_rows(Tour, 1, N).

print_column_labels(N, N) :-
    format(' ~d |', [N]), nl.

print_column_labels(Col, N) :-
    Col < N,
    format(' ~d ', [Col]),
    NextCol is Col + 1,
    print_column_labels(NextCol, N).

print_separator(1) :-
    format('\n'), nl.

print_separator(N) :-
    N > 1,
    format('---+', []),
    NextN is N - 1,
    print_separator(NextN).

print_rows([], _, _).

print_rows([Pos | Rest], Row, N) :-
    format('\n ~d |', [Row]),
    print_row(Pos, 1, N),
    NextRow is Row + 1,
    print_rows(Rest, NextRow, N).

print_row(_, N, N) :-
    format(' K |', []), nl.

print_row(Pos, Col, N) :-
    Col < N,
    format_cell(Pos, (Col, _)),
    NextCol is Col + 1,
    print_row(Pos, NextCol, N).

format_cell(Pos, Pos) :-
    format(' K |', []).

format_cell(_, _) :-
    format(' . |', []).

% Example usage:
?- knight_tour_solve(Tour).
