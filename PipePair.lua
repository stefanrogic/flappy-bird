PipePair = Class{}

local GAP_HEIGHT = 90

function PipePair:init(y)
    self.x = VIRTUAL_WIDTH + 32

    -- Y is for the topmost pipe gap is then y position for the second pipe
    self.y = y

    -- Initialize two pipes that make up the pair
    self.pipes = {
        ['upper'] = Pipe(images['pipe'], 'top', self.y),
        ['lower'] = Pipe(images['pipe'], 'bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    -- Is it ready to be removed from the scene (off the screen)
    self.remove = false
    self.scored = false
end

function PipePair:update(dt)
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SCROLL_SPEED * dt
        self.pipes['upper'].x = self.x
        self.pipes['lower'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end