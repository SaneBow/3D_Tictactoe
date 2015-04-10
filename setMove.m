function setMove(pos)
    global GB PLAYER HISTORY;
    GB(pos(1),pos(2),pos(3)) = PLAYER;
    HISTORY.last = HISTORY.last+1;
    HISTORY.data(HISTORY.last,:) = [pos PLAYER];    
    HISTORY.top = HISTORY.last;
    
    PLAYER = ~(PLAYER-1) + 1; %Swith player
end