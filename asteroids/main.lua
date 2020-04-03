function love.load()
    width, height, flags = love.window.getMode()
    ship = {x = width/2, y = height/2, angle = 0, radius = 30}
    shipSpeed = {x = 0, y = 0}
    bullets = {}
    asteroids = {}
    asteroidStages = {
        {   
            speed = 20,
            radius = 100
        },
        {
           speed = 50,
           radius = 70 
        },
        {
            speed = 80,
            radius = 40
        }, 
        {
            speed = 120,
            radius = 20
        }, 
        {
            speed = 150,
            radius = 15
        }, 
        {
            speed = 170,
            radius = 10
        }
    }

    table.insert(asteroids, 
        {
            x = 100, 
            y = 100, 
            angle = 0, 
            radius = asteroidStages[1].radius,
            speed = asteroidStages[1].speed,
            stage = 1
        })
    table.insert(asteroids, 
        {
            x = width - 100,
            y = 100, 
            angle = 0, 
            radius = asteroidStages[1].radius,
            speed = asteroidStages[1].speed,
            stage = 1
        })
    table.insert(asteroids, 
        {
            x = 100,
            y = height - 100,
            angle = 0,
            radius = asteroidStages[1].radius,
            speed = asteroidStages[1].speed,
            stage = 1
        })
    for index, asteroid in ipairs(asteroids) do
        asteroid.angle = love.math.random() * 2 * math.pi   
    end
end

function love.draw()
    for y = -1, 1 do
        for x = -1, 1 do
            love.graphics.origin()
            love.graphics.translate(x * width, y * height)

            love.graphics.setColor(0.4, 0.4, 0.4)
            love.graphics.circle('fill', ship.x, ship.y, ship.radius)
            love.graphics.setColor(0.5, 0, 0)
            dotX = ship.x + math.cos(ship.angle) * 20
            dotY = ship.y + math.sin(ship.angle) * 20
            love.graphics.circle('fill', dotX, dotY, 5)

            for index, bullet in ipairs(bullets) do
                love.graphics.setColor(0.5, 0, 0)
                love.graphics.circle('fill', bullet.x, bullet.y, bullet.radius)
            end

            for index, asteroid in ipairs(asteroids) do
                love.graphics.setColor(0.2, 0.2, 0.2)
                love.graphics.circle('fill', asteroid.x, asteroid.y, asteroid.radius)
            end
        end
    end
end

function love.update(dt)
    if love.keyboard.isDown('d') then
        ship.angle = (ship.angle + 5 * dt) % (2 * math.pi)
    end
    if love.keyboard.isDown('a') then
        ship.angle = (ship.angle - 5 * dt) % (2 * math.pi)
    end
    if love.keyboard.isDown('w') then
        shipSpeed.x = shipSpeed.x + math.cos(ship.angle) * 100 * dt
        shipSpeed.y = shipSpeed.y + math.sin(ship.angle) * 100 * dt
    end
    if love.keyboard.isDown('s') then
        shipSpeed.x = shipSpeed.x - math.cos(ship.angle) * 100 * dt
        shipSpeed.y = shipSpeed.y - math.sin(ship.angle) * 100 * dt
    end
    ship.x = (ship.x + shipSpeed.x * dt) % width
    ship.y = (ship.y + shipSpeed.y * dt) % height

    local function checkCollision(first, second)
        local distSqr = (first.x - second.x) ^ 2 + (first.y - second.y) ^ 2
        return distSqr <= (first.radius + second.radius) ^ 2
    end

    for bulIndex = #bullets, 1, -1 do
        local bullet = bullets[bulIndex]
        bullet.time = bullet.time - dt
        if bullet.time <= 0 then
            table.remove(bullets, bulIndex)
        else
            bullet.x = (bullet.x + math.cos(bullet.angle) * 200 * dt) % width
            bullet.y = (bullet.y + math.sin(bullet.angle) * 200 * dt) % height
        end

        for astIndex = #asteroids, 1, -1 do
            local asteroid = asteroids[astIndex]
            if checkCollision(bullet, asteroid) then
                table.remove(bullets, bulIndex)

                local angle1 = love.math.random() * 2 * math.pi
                local angle2 = (angle1 + math.pi) % (2 * math.pi)

                if asteroid.stage ~= #asteroidStages then
                    table.insert(asteroids, 
                        {
                            x = asteroid.x,
                            y = asteroid.y,
                            angle = angle1,
                            radius = asteroidStages[asteroid.stage + 1].radius,
                            speed = asteroidStages[asteroid.stage + 1].speed,
                            stage = asteroid.stage + 1
                        })
                    table.insert(asteroids, 
                        {
                            x = asteroid.x,
                            y = asteroid.y,
                            angle = angle2,
                            radius = asteroidStages[asteroid.stage + 1].radius,
                            speed = asteroidStages[asteroid.stage + 1].speed,
                            stage = asteroid.stage + 1
                        })
                end

                table.remove(asteroids, astIndex)
                break
            end
        end
    end


    for index, asteroid in ipairs(asteroids) do
        asteroid.x = (asteroid.x + math.cos(asteroid.angle) * asteroid.speed * dt) % width
        asteroid.y = (asteroid.y + math.sin(asteroid.angle) * asteroid.speed * dt) % height
    
        if checkCollision(ship, asteroid) then
            love.load()
            break
        end
    end

    if #asteroids == 0 then
        love.load()
    end
end

function love.keypressed(key)
    if key == 'space' then
        bullet = {
            x = ship.x + math.cos(ship.angle) * ship.radius,
            y = ship.y + math.sin(ship.angle) * ship.radius,
            angle = ship.angle,
            radius = 5,
            time = 5}
        table.insert(bullets, bullet)
    end
end