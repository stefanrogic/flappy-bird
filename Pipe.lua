Pipe = Class{}

PIPE_HEIGHT = 288
PIPE_WIDTH = 70
PIPE_SCROLL_SPEED = 60

function Pipe:init(img, orientation, y)
    self.image = img

    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = self.image:getWidth()
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end

function Pipe:update(dt)
    -- self.x = self.x - PIPE_SCROLL_SPEED * dt
end

function Pipe:render()
    love.graphics.draw(
        self.image, 
        self.x, 
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), -- Sets y position based on orientation
        0, 
        1, 
        self.orientation == 'top' and -1 or 1 -- Flips the pipe if it's the top one (-1)
    )
end