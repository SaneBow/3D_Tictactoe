function [prevcube,undocube] = undoMove
global GB HISTORY PLAYER;
if HISTORY.last == 0
    undocube = [0 0 0];
    prevcube = [-1 -1 -1];
    return;
end

undocube = HISTORY.data(HISTORY.last,:);
HISTORY.last = HISTORY.last - 1; % Move back pointer
GB(undocube(1),undocube(2),undocube(3)) = 0;
PLAYER = ~(PLAYER-1) + 1; %Swith player

if HISTORY.last == 0
    prevcube = [0 0 0];
else
    prevcube = HISTORY.data(HISTORY.last,:);
end