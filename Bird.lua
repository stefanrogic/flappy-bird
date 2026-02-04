Bird = Class{}

local GRAVITY = 20

function Bird:init(img, sound)
    self.image = img
    self.sound = sound
    self.sound:setVolume(0.1)

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    
    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2

    self.dy = 0
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:collides(pipe)
    -- AABB collision detection
    -- The 2's are left and top padding to make collision feel better
    -- The 4's are right and bottom padding to make collision feel better
    -- Both offsets are used to shrink the collision box to give a player some leeway
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = -3

        self.sound:play()
    end

    self.y = self.y + self.dy
end