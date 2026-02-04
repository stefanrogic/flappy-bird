TitleScreenState = Class{ __includes = BaseState }

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function TitleScreenState:render()
    love.graphics.setFont(fonts['flappy'])
    love.graphics.printf('FLAPPY BIRD', 0, VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(fonts['medium'])
    love.graphics.printf('Press Enter to Start!', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
end