function redocube = redoMove
global HISTORY;
if HISTORY.top == HISTORY.last
    redocube = [0 0 0 0];
    return;
end
redocube = HISTORY.data(HISTORY.last+1,:);
HISTORY.last = HISTORY.last + 1;
setMove(redocube(1:3));