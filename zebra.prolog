%%% Zebra puzzle
%%%
%%% Copyright 2017 Tommy M. McGuire
%%%
%%%   This program is free software: you can redistribute it and/or modify
%%%   it under the terms of the GNU General Public License as published by
%%%   the Free Software Foundation, either version 3 of the License, or
%%%   (at your option) any later version.
%%%
%%%   This program is distributed in the hope that it will be useful,
%%%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%%%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%%%   GNU General Public License for more details.
%%%
%%%   You should have received a copy of the GNU General Public License
%%%   along with this program.  If not, see <http://www.gnu.org/licenses/>.

%%% See: https://en.wikipedia.org/wiki/Zebra_Puzzle, http://rosettacode.org/wiki/Zebra_puzzle

%%% A is the first house on the street.
first(A,[A|_]).

%%% A is the middle house on the street.
middle(A,S) :- append(L, [A|R], S), length(L,N), length(R,N).

%%% A is to the right of B on the street.
right_of(A,B,S) :- append(_, [B,A|_], S).

%%% A and B are next to each other.
next_to(A,B,S) :- right_of(A,B,S); right_of(B,A,S).

nationality(O,H) :- H = h(O,_,_,_,_).
color(C,H) :- H = h(_,C,_,_,_).
pet(P,H) :- H = h(_,_,P,_,_).
drinks(D,H) :- H = h(_,_,_,D,_).
smokes(S,H) :- H = h(_,_,_,_,S).

%%% HS: list of h(nation, color, pet, drink, smoke).
rules(HS) :-
    %% 1.  There are five houses.
    length(HS, 5),
    %% 2.  The Englishman lives in the red house.
    nationality(englishman,H2), color(red,H2), member(H2,HS),
    %% 3.  The Spaniard owns the dog.
    nationality(spaniard,H3), pet(dog,H3), member(H3,HS),
    %% 4.  Coffee is drunk in the green house.
    drinks(coffee, H4), color(green,H4), member(H4,HS),
    %% 5.  The Ukrainian drinks tea.
    nationality(ukranian,H5), drinks(tea,H5), member(H5,HS),
    %% 6.  The green house is immediately to the right of the ivory house.
    color(green,H6green), color(ivory,H6ivory), right_of(H6green,H6ivory,HS),
    %% 7.  The Old Gold smoker owns snails.
    pet(snails,H7), smokes(old_gold,H7), member(H7,HS),
    %% 8.  Kools are smoked in the yellow house.
    smokes(kools,H8), color(yellow,H8), member(H8,HS),
    %% 9.  Milk is drunk in the middle house.
    drinks(milk,H9), middle(H9,HS),
    %% 10. The Norwegian lives in the first house.
    nationality(norwegian,H10), first(H10,HS),
    %% 11. The man who smokes Chesterfields lives in the house next to the man
    %% with the fox.
    smokes(chesterfields,H11ch), pet(fox,H11fox), next_to(H11ch,H11fox,HS),
    %% 12. Kools are smoked in the house next to the house where the horse is
    %% kept.
    smokes(kools,H12kools), pet(horse,H12horse), next_to(H12kools,H12horse,HS),
    %% 13. The Lucky Strike smoker drinks orange juice.
    drinks(orange_juice,H13), smokes(lucky_strikes,H13), member(H13,HS),
    %% 14. The Japanese smokes Parliaments.
    nationality(japanese,H14), smokes(parliaments,H14), member(H14,HS),
    %% 15. The Norwegian lives next to the blue house.
    nationality(norwegian,H15nor), color(blue,H15blue), next_to(H15nor,H15blue,HS).

water(Drinks) :- rules(HS), drinks(water, H), member(H, HS), nationality(Drinks,H).
zebra(Owns) :- rules(HS), pet(zebra,H), member(H,HS), nationality(Owns,H).

?- time((water(D), write('drinks water: '), write(D), nl, fail ; write('done'))).
?- time((zebra(O), write('owns a zebra: '), write(O), nl, fail ; write('done'))).
