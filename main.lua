Class = require 'lib/class'
push = require 'lib/push'
require 'Bird'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- Scrolling variables
local backgroundScroll = 0
BACKGROUND_SCROLL_SPEED = 30
BACKGROUND_LOOPING_POINT = 568

local groundScroll = 0
GROUND_SCROLL_SPEED = 60
GROUND_LOOPING_POINT = 514

-- Classes
local bird = Bird()

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle("Flappy Bird")
    love.window.setIcon(love.image.newImageData('sprites/bird.png'))

    fonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 14),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 28),
        ['flappy'] = love.graphics.newFont('fonts/flappy.ttf', 56)
    }

    images = {
        ['background'] = love.graphics.newImage('sprites/background.png'),
        ['ground'] = love.graphics.newImage('sprites/ground.png')
    }

    -- Setting up virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = true,
        resizable = true
    })

    -- Init classes
    bird:init()

    -- FPS toggle
    local fps = false;
end

function love.update(dt)
    -- Updates the background scroll position by incrementing it with a speed value scaled by delta time,
    -- then wraps the scroll position back to the start using modulo operator when it exceeds the looping point.
    -- This creates a seamless scrolling effect by cycling the background texture continuously.
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT

    bird:update(dt)
end

function love.draw()
    -- Using push to handle virtual resolution (pixel art style)
    push:start()
        love.graphics.draw(images['background'], -backgroundScroll, 0)
        love.graphics.draw(images['ground'], -groundScroll, VIRTUAL_HEIGHT - images['ground']:getHeight())

        -- Render
        bird:render()

        if fps then
            showFps()
        end
    push:finish()
end

function love.resize(w, h)
    push:resize(w, h)
end

function showFps()
    love.graphics.setFont(fonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(1, 1, 1, 1)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "`" then
        fps = not fps
    end
end