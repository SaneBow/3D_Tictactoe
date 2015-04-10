function undocube = undoMove
global GB HISTORY PLAYER;
if HISTORY.last == 0
    undocube = [0 0 0];
    return;
end
undocube = HISTORY.data(HISTORY.last,:);
HISTORY.last = HISTORY.last - 1;
GB(undocube(1),undocube(2),undocube(3)) = 0;
PLAYER = ~(PLAYER-1) + 1; %Swith player