Class = require 'class'
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local birdImage = love.graphics.newImage('sprites/bird.png')
local pipeImage = love.graphics.newImage('sprites/pipe.png')
local backgroundImage = love.graphics.newImage('sprites/background.png')
local groundImage = love.graphics.newImage('sprites/ground.png')

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle("Flappy Bird")
    love.window.setIcon(love.image.newImageData('sprites/bird.png'))
    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = false
    })
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