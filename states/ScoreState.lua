ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
    self.score = params.score
    self.bird = params.bird
    self.pipePairs = params.pipePairs
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.mouse.wasPressed(2) then
        scrolling = true
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- Render frozen pipes
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    -- Render frozen bird
    self.bird:render()

    -- Render score overlay
    love.graphics.setFont(fonts['flappy'])
    love.graphics.printf(
        'Oof! You lost!', 
        0, 
        VIRTUAL_HEIGHT / 4, 
        VIRTUAL_WIDTH, 
        'center'
    )

    love.graphics.setFont(fonts['medium'])
    love.graphics.printf(
        'Score: ' .. tostring(self.score), 
        0, 
        VIRTUAL_HEIGHT / 2 - 20, 
        VIRTUAL_WIDTH, 
        'center'
    )

    love.graphics.printf(
        'Press Enter or Right Click to Play Again!', 
        0, 
        VIRTUAL_HEIGHT / 2 + 20, 
        VIRTUAL_WIDTH, 
        'center'
    )
end