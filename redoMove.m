function redocube = redoMove
global HISTORY PLAYER GB;
if HISTORY.top == HISTORY.last
    redocube = [0 0 0];
    return;
end
redocube = HISTORY.data(HISTORY.last+1,:);
HISTORY.last = HISTORY.last + 1;

GB(redocube(1),redocube(2),redocube(3)) = PLAYER;
PLAYER = ~(PLAYER-1) + 1; %Swith player