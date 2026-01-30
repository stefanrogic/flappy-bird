Pipe = Class{}

local PIPE_SCROLL_SPEED = 60

function Pipe:init(img)
    self.image = img

    self.x = VIRTUAL_WIDTH
    self.y = math.random( VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - 10)

    self.width = self.image:getWidth()
end

function Pipe:update(dt)
    self.x = self.x - PIPE_SCROLL_SPEED * dt
end

function Pipe:render()
    love.graphics.draw(self.image, self.x, self.y)
end