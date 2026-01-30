Class = require 'class'
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local birdImage = love.graphics.newImage('sprites/bird.png')
local pipeImage = love.graphics.newImage('sprites/pipe.png')

local backgroundImage = love.graphics.newImage('sprites/background.png')
local backgroundScroll = 0
local BACKGROUND_SCROLL_SPEED = 30
local BACKGROUND_LOOPING_POINT = 568

local groundImage = love.graphics.newImage('sprites/ground.png')
local groundScroll = 0
local GROUND_SCROLL_SPEED = 60
local GROUND_LOOPING_POINT = 514

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle("Flappy Bird")
    love.window.setIcon(love.image.newImageData('sprites/bird.png'))
    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = true,
        resizable = true
    })
end

function love.update(dt)
    -- Updates the background scroll position by incrementing it with a speed value scaled by delta time,
    -- then wraps the scroll position back to the start using modulo operator when it exceeds the looping point.
    -- This creates a seamless scrolling effect by cycling the background texture continuously.
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT
end

function love.draw()
    -- Using push to handle virtual resolution (making it look pixelated)
    push:start()
        love.graphics.draw(backgroundImage, -backgroundScroll, 0)
        love.graphics.draw(groundImage, -groundScroll, VIRTUAL_HEIGHT - groundImage:getHeight())
    push:finish()
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end