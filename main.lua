Class = require 'lib/class'
push = require 'lib/push'
require 'functions'
require 'Bird'
require 'Pipe'
require 'PipePair'

-- State
require 'StateMachine'
require 'states/BaseState'
require 'states/TitleScreenState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/CountdownState'

-- Window constants
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- Scrolling
local backgroundScroll = 0
BACKGROUND_SCROLL_SPEED = 30
BACKGROUND_LOOPING_POINT = 568

local groundScroll = 0
GROUND_SCROLL_SPEED = 60
GROUND_LOOPING_POINT = 514

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle("Flappy Bird")
    love.window.setIcon(love.image.newImageData('sprites/bird.png'))

    -- Seed 
    math.randomseed(os.time())

    fonts = {
        ['small'] = love.graphics.newFont('fonts/flappy.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/flappy.ttf', 14),
        ['large'] = love.graphics.newFont('fonts/flappy.ttf', 28),
        ['flappy'] = love.graphics.newFont('fonts/flappy.ttf', 56)
    }
    love.graphics.setFont(fonts['flappy'])

    images = {
        ['bird'] = love.graphics.newImage('sprites/bird.png'),
        ['pipe'] = love.graphics.newImage('sprites/pipe.png'),
        ['background'] = love.graphics.newImage('sprites/background.png'),
        ['ground'] = love.graphics.newImage('sprites/ground.png')
    }
    images['bird']:setFilter('linear', 'linear')

    sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),   
        ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static')

    }

    -- Setting up virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = true,
        resizable = true
    })

    --- Initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
        ['countdown'] = function() return CountdownState() end
    }
    gStateMachine:change('title')

    -- Input table (we need it for our own input handling)
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}

    -- FPS toggle
    fps = false

    -- Global scrolling flag
    scrolling = true
end

function love.update(dt)
    if scrolling then
        -- Updates the background scroll position by incrementing it with a speed value scaled by delta time,
        -- then wraps the scroll position back to the start using modulo operator when it exceeds the looping point.
        -- This creates a seamless scrolling effect by cycling the background texture continuously.
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT
    end

    gStateMachine:update(dt)

    -- Resets
    love.keyboard.keysPressed = {} -- Reset keys pressed table each frame
    love.mouse.buttonsPressed = {} -- Reset mouse buttons pressed table each frame
end

function love.draw()
    push:start()  -- Using push to handle virtual resolution (pixel art style)
        love.graphics.draw(images['background'], -backgroundScroll, 0)
        love.graphics.draw(images['ground'], -groundScroll, VIRTUAL_HEIGHT - images['ground']:getHeight())

        gStateMachine:render()

        -- Show FPS
        if fps then
            showFps()
        end
    push:finish()
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true -- Add the key to table of keys pressed this frame

    if key == "escape" then
        love.event.quit()
    end

    if key == "`" then
        fps = not fps
    end
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasPressed(button)
    if love.mouse.buttonsPressed[button] then
        return true
    else
        return false
    end
end

function love.resize(w, h)
    push:resize(w, h)
end