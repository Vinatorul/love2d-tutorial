function love.load()
    love.graphics.setNewFont(32)
    cellSize = 30
    gridWidth = 10
    gridHeight = 18
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    grid = {}
    for y = 1, gridHeight do
        grid[y] = {}
        for x = 1, gridWidth do
            grid[y][x] = 0
        end
    end

    pieces = {
        [1] = {
            {
                {0, 0, 0, 0},
                {1, 1, 1, 1},
                {0, 0, 0, 0},
                {0, 0, 0, 0}
            },
            {
                {0, 1, 0, 0},
                {0, 1, 0, 0},
                {0, 1, 0, 0},
                {0, 1, 0, 0}
            }
        },
        [2] = {
            {
                {0, 0, 0, 0},
                {2, 2, 2, 0},
                {0, 0, 2, 0},
                {0, 0, 0, 0}
            },
            {
                {0, 2, 0, 0},
                {0, 2, 0, 0},
                {2, 2, 0, 0},
                {0, 0, 0, 0}
            },
            {
                {2, 0, 0, 0},
                {2, 2, 2, 0},
                {0, 0, 0, 0},
                {0, 0, 0, 0}
            },
            {
                {0, 2, 2, 0},
                {0, 2, 0, 0},
                {0, 2, 0, 0},
                {0, 0, 0, 0}
            },
        },
        [3] = {
            {
                {0, 0, 0, 0},
                {3, 3, 3, 0},
                {3, 0, 0, 0},
                {0, 0, 0, 0}
            },
            {
                {0, 3, 0, 0},
                {0, 3, 0, 0},
                {0, 3, 3, 0},
                {0, 0, 0, 0}
            },
            {
                {0, 0, 3, 0},
                {3, 3, 3, 0},
                {0, 0, 0, 0},
                {0, 0, 0, 0}
            },
            {
                {3, 3, 0, 0},
                {0, 3, 0, 0},
                {0, 3, 0, 0},
                {0, 0, 0, 0}
            }
        },
        [4] = {
            {
                {0, 0, 0, 0},
                {0, 4, 4, 0},
                {0, 4, 4, 0},
                {0, 0, 0, 0}
            }
        },
        [5] = {
            {
                {0, 0, 0, 0},
                {5, 5, 5, 0},
                {0, 5, 0, 0},
                {0, 0, 0, 0}
            },
            {
                {0, 5, 0, 0},
                {0, 5, 5, 0},
                {0, 5, 0, 0},
                {0, 0, 0, 0}
            },
            {
                {0, 5, 0, 0},
                {5, 5, 5, 0},
                {0, 0, 0, 0},
                {0, 0, 0, 0}
            },
            {
                {0, 5, 0, 0},
                {5, 5, 0, 0},
                {0, 5, 0, 0},
                {0, 0, 0, 0}
            }
        },
        [6] = {
            {
                {0, 0, 0, 0},
                {0, 6, 6, 0},
                {6, 6, 0, 0},
                {0, 0, 0, 0}
            },
            {
                {6, 0, 0, 0},
                {6, 6, 0, 0},
                {0, 6, 0, 0},
                {0, 0, 0, 0}
            }
        },
        [7] = {
            {
                {0, 0, 0, 0},
                {7, 7, 0, 0},
                {0, 7, 7, 0},
                {0, 0, 0, 0}
            },
            {
                {0, 7, 0, 0},
                {7, 7, 0, 0},
                {7, 0, 0, 0},
                {0, 0, 0, 0}
            }
        }
    }

    
    timer = 0

    function checkMove(tempX, tempY, tempTurn)
        for y = 1, 4 do
            for x = 1, 4 do
                if pieces[pieceIdx][tempTurn][y][x] ~= 0 then
                    if tempX + x < 1 then
                        return false
                    elseif tempX + x > gridWidth then
                        return false
                    elseif tempY + y > gridHeight then
                        return false
                    elseif tempY + y > 0 and grid[tempY + y][tempX + x] ~= 0 then
                        return false
                    end
                end
            end
        end
        return true
    end

    nextPieceIdx = love.math.random(1, 7)
    nextPieceTurn = love.math.random(1, #pieces[nextPieceIdx])


    function newPiece()
        pieceIdx = nextPieceIdx
        pieceTurn = nextPieceTurn
        pieceX = 3
        pieceY = -2       
        nextPieceIdx = love.math.random(1, 7)
        nextPieceTurn = love.math.random(1, #pieces[nextPieceIdx])
    end
    newPiece()

    level = 1
    levelLimits = {1000, 3000, 6000, 10000}
    speed =       {0.5,  0.4,   0.3, 0.2, 0.1}
    timerLimit = speed[level]
    score = 0
end

function love.draw()
    local colors = {
        [0] = {0.4, 0.4, 0.4},
        [1] = {0.1, 0.1, 0.8},
        [2] = {1, 1, 0.1},
        [3] = {0.9, 0.1, 0.1},
        [4] = {0.98, 0.53, 0.321},
        [5] = {0.63, 0.34, 0.81},
        [6] = {0.1, 0.8, 0.1},
        [7] = {0.56, 0.9, 0.95}
    }

    function drawBlock(block, x, y)
        if y < 0 then
            return
        end
        love.graphics.setColor(colors[block])
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize,
            (y - 1) * cellSize,
            cellSize - 1,
            cellSize - 1
            )
    end

    for y = 1, gridHeight do
        for x = 1, gridWidth do
           drawBlock(grid[y][x], x, y)
        end
    end

    
    local piece = pieces[pieceIdx][pieceTurn]
    for y = 1, 4 do
        for x = 1, 4 do
            if piece[y][x] ~= 0 then
                drawBlock(piece[y][x], x + pieceX, y + pieceY)
            end
        end
    end

    local piece = pieces[nextPieceIdx][nextPieceTurn]
    for y = 1, 4 do
        for x = 1, 4 do
            if piece[y][x] ~= 0 then
                drawBlock(piece[y][x], x + 11, y + 1)
            end
        end
    end
    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.print("Score: "..score, 320, 200)
    love.graphics.print("Level: "..level, 320, 250)
end

function love.keypressed(key)
    if key == "w" then
        local tempTurn = pieceTurn + 1
        if tempTurn > #pieces[pieceIdx] then
            tempTurn = 1
        end
        if checkMove(pieceX, pieceY, tempTurn) then
            pieceTurn = tempTurn
        end
    elseif key == "d" then
        local tempX = pieceX + 1
        if checkMove(tempX, pieceY, pieceTurn) then
            pieceX = tempX
        end
    elseif key == "a" then
        local tempX = pieceX - 1
        if checkMove(tempX, pieceY, pieceTurn) then
            pieceX = tempX
        end
    end
end

function love.update(dt)
    timer = timer + dt
    if love.keyboard.isDown("s") then
        timer = timerLimit
    end
    if timer >= timerLimit then
        timer = timer - timerLimit
        local tempY = pieceY + 1
        if checkMove(pieceX, tempY, pieceTurn) then
            pieceY = pieceY + 1
        else
            local piece = pieces[pieceIdx][pieceTurn]
            for y = 1, 4 do
                for x = 1, 4 do
                    if piece[y][x] ~= 0 and pieceY + y > 0 then
                        grid[pieceY + y][pieceX + x] = piece[y][x]
                    end
                end
            end

            local fullRows = 0
            for y = 1, gridHeight do
                local fullRow = true
                for x = 1, gridWidth do
                    if grid[y][x] == 0 then
                        fullRow = false
                        break
                    end
                end

                if fullRow then
                    fullRows = fullRows + 1
                    for tmpY = y - 1, 1, -1 do
                        for tmpX = 1, gridWidth do
                            grid[tmpY + 1][tmpX] = grid[tmpY][tmpX]
                        end
                    end 

                    for tmpX = 1, gridWidth do
                        grid[1][tmpX] = 0
                    end
                end
            end
            if fullRows == 1 then
                score = score + 100
            elseif fullRows == 2 then
                score = score + 300
            elseif fullRows == 3 then
                score = score + 700
            elseif fullRows == 4 then
                score = score + 1500
            end
            if level <= #levelLimits then
                if score >= levelLimits[level] then
                    level = level + 1
                    timerLimit = speed[level]
                end
            end

            newPiece()

            if not checkMove(pieceX, pieceY, pieceTurn) then
                love.load()
            end
            timer = timerLimit
        end
    end
end