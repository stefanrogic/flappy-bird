CountdownState = Class{__includes = BaseState}

-- We set 0.75 seconds for each countdown number because it feels right
COUNTDOWN_TIME = 0.75

function CountdownState:enter(params)
    self.count = 3
    self.timer = 0
end

function CountdownState:update(dt)
    self.timer = self.timer + dt

    if self.timer >= COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        if self.count == 0 then
            gStateMachine:change('play')
        end
    end
end

function CountdownState:render()
    -- Draw bird in center
    love.graphics.draw(images['bird'], 
        VIRTUAL_WIDTH / 2 - BIRD_WIDTH / 2, 
        VIRTUAL_HEIGHT / 2 - BIRD_HEIGHT / 2)

    love.graphics.setFont(fonts['flappy'])
    love.graphics.printf(tostring(self.count), 0, VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH, 'center')
end