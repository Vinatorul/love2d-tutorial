function love.draw()
    function drawEye(eyeX, eyeY)
        love.graphics.setColor(1, 1, 1)
        local distanceX = love.mouse.getX() - eyeX
        local distanceY = love.mouse.getY() - eyeY
        local distance = math.sqrt(distanceX^2 + distanceY^2)
        local angle = math.atan2(distanceY, distanceX)


        local eyeBallX = eyeX + math.cos(angle) * math.min(distance, 30)
        local eyeBallY = eyeY + math.sin(angle) * math.min(distance, 30)
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle('fill', eyeX, eyeY, 50)

        local r = math.min(15*math.max(150/math.max(distance, 0.1), 1), 40)

        love.graphics.setColor(0.1, 0.6, 0.2)
        love.graphics.circle('fill', eyeBallX, eyeBallY, r)
    end
    
    drawEye(200, 200)
    drawEye(325, 200)
end