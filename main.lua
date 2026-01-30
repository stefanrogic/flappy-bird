Class = require 'class'
push = require 'push'

function love.load()
    -- Initialize game variables and assets here
end

function love.update(dt)
    -- Update game logic here
    -- dt is the time elapsed since the last frame
end

function love.draw()
    -- Draw everything here
end

function love.keypressed(key)
    -- Handle key presses
    if key == "escape" then
        love.event.quit()
    end
end