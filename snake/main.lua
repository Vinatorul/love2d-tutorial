function love.draw()
    local cellSize = 20

    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle(
        'fill',
        0,
        0,
        gridWidth * cellSize,
        gridHeight * cellSize)
    if gameover then
        love.graphics.setColor(0.5, 0.5, 0.5)
    else
        love.graphics.setColor(0.1, 0.6, 0.2)
    end
    for index, segment in ipairs(snake) do
        love.graphics.rectangle(
            'fill',
            (segment.x - 1) * cellSize,
            (segment.y - 1) * cellSize,
            cellSize - 2,
            cellSize - 2)
    end
    love.graphics.setColor(0.8, 0.1, 0.1)
    love.graphics.rectangle(
        'fill',
        (foodposition.x - 1) * cellSize,
        (foodposition.y - 1) * cellSize,
        cellSize - 2,
        cellSize - 2)

end

function love.load()
    gridWidth = 25
    gridHeight = 20
    timer = 0
    snake = {
        {x = 3, y = 1},
        {x = 2, y = 1},
        {x = 1, y = 1}
    }
    moves = {
        ["w"] = {x = 0, y = -1},
        ["a"] = {x = -1, y = 0},
        ["s"] = {x = 0, y = 1},
        ["d"] = {x = 1, y = 0}
    }
    delta = moves["d"]
    foodposition = {
        x = love.math.random(1, gridWidth), 
        y = love.math.random(1, gridHeight)}
    gameover = false
end

function love.update(dt)
    timer = timer + dt
    local timerLimit = 0.15
    if gameover and timer >= 2 then
        love.load()
    elseif (not gameover) and timer >= timerLimit then
        timer = timer - timerLimit

        local nextPos = {x = (snake[1].x + delta.x), 
                         y = (snake[1].y + delta.y)}
        
        if nextPos.x > gridWidth then
            nextPos.x = 1
        elseif nextPos.x < 1 then
            nextPos.x = gridWidth
        end
        if nextPos.y > gridHeight then
            nextPos.y = 1
        elseif nextPos.y < 1 then
            nextPos.y = gridHeight
        end

        for index, segment in ipairs(snake) do
            if index ~= #snake and segment.x == nextPos.x and segment.y == nextPos.y then
                gameover = true
                break
            end
        end

        if (not gameover) then
            table.insert(snake, 1, nextPos)
            if nextPos.x == foodposition.x and nextPos.y == foodposition.y then
                foodposition.x = love.math.random(1, gridWidth)
                foodposition.y = love.math.random(1, gridHeight)
            else
                table.remove(snake)
            end
        end
    end
end

function love.keypressed(key)
    if key == "w" or key == "a" or key == "s" or key == "d" then
        delta = moves[key]
    end
end