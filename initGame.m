function initGame
    createBoard(3);
    global GB;
    player = 1;
    while isWin() == 0
        position = input('Input position of next move [x y z]: ');
        setMove(position,player);
        player = ~(player-1) + 1;
        disp(GB);
    end 
    fprintf('Player %g wins!\n',isWin());
end