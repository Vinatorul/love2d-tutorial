function love.load()
    fieldWidth = 20
    fieldHeight = 15
    totalBombs = 50
    field = {}
    for y = 1, fieldHeight do
        field[y] = {}
        for x = 1, fieldWidth do
            field[y][x] = {type = 0, subType = 0}
        end
    end
    cellSize = 30

    cellTypes = {
        [-1] = {data = "B", color = {0, 0, 0}},
        [0] = {data = "", color = {0, 0, 0}},
        [1] = {data = "1", color = {0, 0, 0.8}},
        [2] = {data = "2", color = {0, 0.8, 0}},
        [3] = {data = "3", color = {0.8, 0.8, 0}},
        [4] = {data = "4", color = {0.8, 0, 0}},
        [5] = {data = "5", color = {0, 0, 0.6}},
        [6] = {data = "6", color = {0, 0.6, 0}},
        [7] = {data = "7", color = {0.6, 0.6, 0}},
        [8] = {data = "8", color = {0.6, 0, 0}}
    }

    function checkPosition(x, y)
        return x > 0 and x <= fieldWidth and
           y > 0 and y <= fieldHeight
    end

    function generateField()
        fieldGenerated = true
        local positions = {}
        for y = 1, fieldHeight do
            for x = 1, fieldWidth do
                if x ~= currentX or y ~= currentY then
                    table.insert(positions, {x = x, y = y})
                end
            end
        end
        for i = 1, totalBombs do
            local posIdx = love.math.random(#positions)
            local position = table.remove(positions, posIdx)
            field[position.y][position.x].type = -1
            for y = -1, 1 do
                for x = -1, 1 do
                    local tempX = position.x + x
                    local tempY = position.y + y
                    if checkPosition(tempX, tempY) and
                       field[tempY][tempX].type ~= -1 then
                        field[tempY][tempX].type = field[tempY][tempX].type + 1
                    end
                end
            end
        end 
    end

    gameOver = false
    fieldGenerated = false
    flagsCounter = 0
end

function love.draw()
    local function draw_cell(x, y, cell)
        if cell.subType == 1 then
            love.graphics.setColor(0.9, 0.9, 0.9)
        elseif cell.subType == 4 then
            love.graphics.setColor(0.8, 0, 0)
        else
            if (love.mouse.isDown(1) or love.mouse.isDown(2)) and 
               x == currentX and y == currentY then
                love.graphics.setColor(0.3, 0.3, 0.3)
            else
                love.graphics.setColor(0.6, 0.6, 0.6)
            end
        end
        love.graphics.rectangle(
            'fill',
            (x - 1) * cellSize,
            (y - 1) * cellSize,
            cellSize - 1,
            cellSize - 1
        )
        if cell.subType == 1 then
            love.graphics.setColor(cellTypes[cell.type].color)
            love.graphics.print(
                cellTypes[cell.type].data, 
                (x - 1) * cellSize + cellSize/4, 
                (y - 1) * cellSize)
        elseif cell.subType == 2 then     
            love.graphics.setColor(0.4, 0, 0)
            love.graphics.print(
                "F", 
                (x - 1) * cellSize + cellSize/4, 
                (y - 1) * cellSize)
        elseif cell.subType == 3 then 
            love.graphics.setColor(0, 0, 0)
            love.graphics.print(
                "?", 
                (x - 1) * cellSize + cellSize/4, 
                (y - 1) * cellSize)       
        elseif gameOver and cell.type == -1 then
            love.graphics.setColor(cellTypes[cell.type].color)
            love.graphics.print(
                cellTypes[cell.type].data, 
                (x - 1) * cellSize + cellSize/4, 
                (y - 1) * cellSize)
        end
    end
    love.graphics.setNewFont(24)
    for y = 1, fieldHeight do
        for  x = 1, fieldWidth do
            draw_cell(x, y, field[y][x])
        end
    end
    love.graphics.setNewFont(32)
    love.graphics.print("Bombs: "..totalBombs, 615, 100)
    love.graphics.print("Flags: "..flagsCounter, 615, 150)
end

function love.update(dt)
    if not gameOver then
        currentX = math.ceil(love.mouse.getX() / 30)
        currentY = math.ceil(love.mouse.getY() / 30)
    end
end

function love.mousereleased(mouseX, mouseY, button)
    local function dfs(cellX, cellY)
        for y = -1, 1 do
            for x = -1, 1 do
                local tempX = cellX + x
                local tempY = cellY + y
                if checkPosition(tempX, tempY) and
                   field[tempY][tempX].subType == 0 then
                    if field[tempY][tempX].type == -1 then
                        gameOver = true
                        field[tempY][tempX].subType = 4
                    else
                        field[tempY][tempX].subType = 1
                    end
                    if field[tempY][tempX].type == 0 then
                        dfs(tempX, tempY)
                    end
                end
            end
        end
    end

    local function countFlags(cellX, cellY)
        local ans = 0
        for y = -1, 1 do
            for x = -1, 1 do           
                local tempX = cellX + x
                local tempY = cellY + y
                if checkPosition(tempX, tempY) and
                   field[tempY][tempX].subType == 2 then
                    ans = ans + 1
                end
            end
        end
        return ans
    end


    if not gameOver then
        if button == 1 then
            if not fieldGenerated then
                generateField()
            end
            if checkPosition(currentX, currentY) then
                local cell = field[currentY][currentX]
                if cell.subType == 0 then
                    if cell.type == -1 then
                        gameOver = true
                        cell.subType = 4
                    else
                        cell.subType = 1
                        if cell.type == 0 then
                            dfs(currentX, currentY)
                        end
                    end
                end
            end
        elseif button == 2 then
            if checkPosition(currentX, currentY) then
                local cell = field[currentY][currentX]
                if cell.subType == 0 then
                    cell.subType = 2
                    flagsCounter = flagsCounter + 1
                elseif cell.subType == 2 then
                    cell.subType = 3
                    flagsCounter = flagsCounter - 1
                elseif cell.subType == 3 then
                    cell.subType = 0
                end
            end 
        elseif button == 3 then
            if checkPosition(currentX, currentY) then
                local cell = field[currentY][currentX]
                if cell.subType == 1 and cell.type > 0 and 
                   countFlags(currentX, currentY) == cell.type then
                    dfs(currentX, currentY)                    
                end
            end
        end
    end
end

function love.keypressed(key)
    if gameOver and key == "r" then
        love.load()
    end
end