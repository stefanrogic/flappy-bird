PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

local pipeDistance = 5 -- Seconds

function PlayState:init()
    self.bird = Bird(images['bird'], sounds['jump'])
    self.pipePairs = {}
    self.timer = 0
    self.score = 0

    -- Initialize lastY to base our first pipe pair on
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    -- Update timer for pipe spawning
    self.timer = self.timer + dt

    -- Spawn a new pipe pair every pipeDistance in seconds
    if self.timer > pipeDistance or #self.pipePairs == 0 then
        -- Modify the lastY coordinate we placed so pipe gaps aren't too far apart
        local y = math.max(-PIPE_HEIGHT + 10,
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        -- Add a new pipe pair at the end of the screen at our new Y
        table.insert(self.pipePairs, PipePair(y))
        self.timer = 0
    end

    for k, pair in pairs(self.pipePairs) do
        -- Check to see if the pipe pair has gone past the bird to give score
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:setVolume(0.2)
                sounds['score']:play()
            end
        end

        pair:update(dt)
    end

    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- Check for collisions
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            -- Check for collision between bird and pipe
            if self.bird:collides(pipe) then
                sounds['explosion']:setVolume(0.2)
                sounds['explosion']:play()
                scrolling = false
                gStateMachine:change('score', {
                    score = self.score,
                    bird = self.bird,
                    pipePairs = self.pipePairs
                })
            end
        end
    end

    -- Check for collision between bird and ground
    if self.bird.y > VIRTUAL_HEIGHT - 40 then
        sounds['explosion']:setVolume(0.2)
        sounds['explosion']:play()
        scrolling = false
        gStateMachine:change('score', {
            score = self.score,
            bird = self.bird,
            pipePairs = self.pipePairs
        })
    end

    -- Update bird based on gravity and input
    self.bird:update(dt)
end

function PlayState:render()
    -- Render all pipe pairs
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(fonts['medium'])
    love.graphics.printf('Score: ' .. tostring(self.score), 8, 8,
        VIRTUAL_WIDTH, 'left')

    -- Render bird
    self.bird:render()
end