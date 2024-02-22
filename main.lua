function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setBackgroundColor(59/255, 32/255, 39/255)

    font = love.graphics.newFont('Lambda-Regular.ttf', 80)
    love.graphics.setFont(font)

    sprites = {}
    sprites.x = love.graphics.newImage('assets/x.png')
    sprites.xBorder = love.graphics.newImage('assets/xBorder.png')
    sprites.o = love.graphics.newImage('assets/o.png')
    sprites.oBorder = love.graphics.newImage('assets/oBorder.png')
    sprites.background = love.graphics.newImage('assets/background.png')

    sounds = {}
    sounds.coin = love.audio.newSource('sounds/coin.mp3', 'static')
    sounds.fail = love.audio.newSource('sounds/beep.mp3', 'static')
    sounds.music = love.audio.newSource('sounds/music.mp3', 'static')
    sounds.music:setVolume(.5)


    Object = require 'libraries/classic'
    anim8 = require 'libraries/anim8'
    flux = require 'libraries/flux'

    require 'scripts/coin'
    require 'scripts/effects'

    coin1 = Coin(love.graphics.getWidth()/2 - 200, love.graphics.getHeight() / 2)
    coin2 = Coin(love.graphics.getWidth()/2 + 200, love.graphics.getHeight() / 2)

    circle1 = effectCircle(coin1.x, coin1.y, 120, {59/255, 125/255, 75/255, .4})
    circle2 = effectCircle(coin2.x, coin2.y, 120, {59/255, 125/255, 75/255, .4})

    points = effectPoints(love.graphics.getWidth() / 2 + 110, 64, {1, 1, 1, 0})

    selected = 'none'
    selectedFace = 'x'
    score = 0
    bestScore = 0
    shake ={
        x = 0,
        y = 0,
    }
end

function screenshake()
    local table = {1, -1}
    local dir = table[math.random(1, 2)]

    flux.to(shake, .07, {x = 10*dir}):after(shake, .05, {x = -10*dir}):after(shake, .03, {x = 0*dir})
end

function love.update(dt)
    if not sounds.music:isPlaying() then
        sounds.music:play()
    end

    flux.update(dt)

    mx,my = love.mouse.getPosition()
    coin1:update(dt)
    coin2:update(dt)

    if coin1.state == 'static' and coin2.state == 'static' then
        if not coin1.scored and not coin2.scored then
            
            -- SCORE POINTS
            local s = 0
            print(selectedFace)
            if coin1.face == selectedFace then
                circle1:effect(.4, .1)
                s = s + 1
            end
            if coin2.face == selectedFace then
                circle2:effect(.4, .1)
                s = s + 1
            end
            score = score + s
            if s > 0 then
                points:effect(s)
                sounds.coin:play()
            else
                score = 0
                sounds.fail:play()
            end

            coin1.scored = true
            coin2.scored = true
        end
    end
    if score > bestScore then
        bestScore = score
    end
end

function love.draw()
    love.graphics.push()
    love.graphics.translate(shake.x, shake.y)
    love.graphics.draw(sprites.background, love.graphics.getWidth()/2, love.graphics.getHeight()/2, 1, 80, 80, sprites.background:getWidth()/2, sprites.background:getHeight()/2)
    
    circle1:draw()
    circle2:draw()

    coin1:draw()
    coin2:draw()

    
    local buttonX, buttonO = 0,0
    if selected == 'none' then
        if mx > love.graphics.getWidth() / 2 - 65 -16*4 and mx < love.graphics.getWidth() / 2 - 65 + 32*4 -16*4 then
            if my > love.graphics.getHeight() - 100 -16*4 and my < love.graphics.getHeight() - 100 + 32*4 -16*4 then
                buttonX = sprites.xBorder
            else
                buttonX = sprites.x
            end
        else
            buttonX = sprites.x
        end
        if mx > love.graphics.getWidth() / 2 + 65 -16*4 and mx < love.graphics.getWidth() / 2 + 65 + 32*4 -16*4 then
            if my > love.graphics.getHeight() - 100 -16*4 and my < love.graphics.getHeight() - 100 + 32*4 -16*4 then
                buttonO = sprites.oBorder
            else
                buttonO = sprites.o
            end
        else
            buttonO = sprites.o
        end
    elseif selected == 'x' then
        buttonX = sprites.xBorder
        buttonO = sprites.o
    elseif selected == 'o' then
        buttonO = sprites.oBorder
        buttonX = sprites.x
    end
    love.graphics.draw(buttonX, love.graphics.getWidth() / 2 - 65, love.graphics.getHeight() - 100, 0, 4, 4, 16, 16)
    love.graphics.draw(buttonO, love.graphics.getWidth() / 2 + 65, love.graphics.getHeight() - 100, 0, 4, 4, 16, 16)

    love.graphics.printf(tostring(bestScore)..' | '..tostring(score), love.graphics.getWidth()/2 - 256, 40, 512, 'center')
    points:draw('+'..points.value)
    love.graphics.pop()
end

function love.mousepressed( x, y, button, istouch, presses )
    if mx > love.graphics.getWidth() / 2 - 65 -16*4 and mx < love.graphics.getWidth() / 2 - 65 + 32*4 -16*4 then
        if my > love.graphics.getHeight() - 100 -16*4 and my < love.graphics.getHeight() - 100 + 32*4 -16*4 then
            if coin1.state == 'static' and coin2.state == 'static' then

                screenshake()

                selected = 'x'
                selectedFace = 'x'
                math.randomseed(1)
                coin1:flip()
                coin1.scored = false
                math.randomseed(2)
                coin2.scored = false
                coin2:flip()
            end
        end
    end
    if mx > love.graphics.getWidth() / 2 + 65 -16*4 and mx < love.graphics.getWidth() / 2 + 65 + 32*4 -16*4 then
        if my > love.graphics.getHeight() - 100 -16*4 and my < love.graphics.getHeight() - 100 + 32*4 -16*4 then
            if coin1.state == 'static' and coin2.state == 'static' then

                screenshake()

                selected = 'o'
                selectedFace = 'o'
                math.randomseed(1)
                coin1:flip()
                coin1.scored = false
                math.randomseed(2)
                coin2.scored = false
                coin2:flip()
            end
        end
    end
end