Class = require 'lib/class'
push = require 'lib/push'
require 'functions'
require 'Bird'
require 'Pipe'

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

-- Pipe spawning
local pipes = {}
local spawnTimer = 0
local pipeDistance = 5 -- seconds

-- Classes
local bird
local pipe

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle("Flappy Bird")
    love.window.setIcon(love.image.newImageData('sprites/bird.png'))

    -- Seed 
    math.randomseed(os.time())

    fonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 14),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 28),
        ['flappy'] = love.graphics.newFont('fonts/flappy.ttf', 56)
    }

    images = {
        ['bird'] = love.graphics.newImage('sprites/bird.png'),
        ['pipe'] = love.graphics.newImage('sprites/pipe.png'),
        ['background'] = love.graphics.newImage('sprites/background.png'),
        ['ground'] = love.graphics.newImage('sprites/ground.png')
    }

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

    -- Input table (we need it for our own input handling)
    love.keyboard.keysPressed = {}

    -- Init objects
    bird = Bird(images['bird'], sounds['jump'])
    pipe = Pipe(images['pipe'])

    -- FPS toggle
    local fps = false;
end

function love.update(dt)
    -- Updates the background scroll position by incrementing it with a speed value scaled by delta time,
    -- then wraps the scroll position back to the start using modulo operator when it exceeds the looping point.
    -- This creates a seamless scrolling effect by cycling the background texture continuously.
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT

    -- Updates
    bird:update(dt)

    spawnTimer = spawnTimer + dt
    if spawnTimer > pipeDistance then -- Add pipes to table
        table.insert(pipes, Pipe(images['pipe']))
        spawnTimer = 0
    end
    
    for k, pipe in pairs(pipes) do -- Update every pipe positions
        pipe:update(dt)
    end

    -- Resets
    love.keyboard.keysPressed = {} -- Reset keys pressed table each frame (so the bird doesnt fly away :D)
end

function love.draw()
    push:start()  -- Using push to handle virtual resolution (pixel art style)
        love.graphics.draw(images['background'], -backgroundScroll, 0)
        love.graphics.draw(images['ground'], -groundScroll, VIRTUAL_HEIGHT - images['ground']:getHeight())

        -- Render
        bird:render()

        for k, pipe in pairs(pipes) do -- Render every pipe in table
            pipe:render()
        end

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

function love.resize(w, h)
    push:resize(w, h)
end