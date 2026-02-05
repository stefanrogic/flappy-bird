TitleScreenState = Class{ __includes = BaseState }

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.mouse.wasPressed(2) then
        gStateMachine:change('countdown')
    end
end

function TitleScreenState:render()
    love.graphics.setFont(fonts['flappy'])
    love.graphics.printf(
        'FLAPPY BIRD', 
        0, 
        VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH, 
        'center'
    )

    love.graphics.setFont(fonts['medium'])
    love.graphics.printf(
        'Press Enter or Right Click to Start!', 
        0, 
        VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 
        'center'
    )

    love.graphics.printf(
        'Space or Left Click to Flap', 
        0, 
        VIRTUAL_HEIGHT - 40,
        VIRTUAL_WIDTH, 
        'center'
    )
end