Coin = Object.extend(Object)

function Coin:new(x, y)
    self.x,self.y = x,y
    self.state = 'static'
    self.face = 'x'
    self.spritesheet = love.graphics.newImage('assets/coin_spritesheet.png')
    self.grid = anim8.newGrid(64, 64, self.spritesheet:getWidth(), self.spritesheet:getHeight())
    self.animation = anim8.newAnimation(self.grid('1-10',1), 0.02)
    self.xQuad = love.graphics.newQuad(320, 0, 64, 64, self.spritesheet)
    self.yQuad = love.graphics.newQuad(0, 0, 64, 64, self.spritesheet)
    self.speed = 0
    self.scored = true
end

function Coin:update(dt)
    self.animation:update(dt*self.speed)
    if self.speed > 0 then
        self.speed = self.speed - .008
    else
        self.speed = 0
    end
    if self.state == 'flip' then 
        if self.speed == 0 then
            self.state = 'static'
            selected = 'none'
            local a = self.animation.position
            if a==1 or a==2 or a==3 or a==9 or a==10 then
                self.face = 'o'
            else
                self.face = 'x'
            end
        end
    end
end

function Coin:flip()
    self.state = 'flip'
    self.speed = math.random(8, 12) / 10
end

function Coin:draw()
    local x,y = self.x, self.y
    if self.state == 'static' then
        local quad = self.xQuad
        if self.face == 'x' then
            quad = self.xQuad
        else 
            quad = self.yQuad
        end
        love.graphics.draw(self.spritesheet, quad, x, y, 0, 4, 4, 32, 32)
    elseif self.state == 'flip' then
        self.animation:draw(self.spritesheet, x, y, 0, 4, 4, 32, 32)
    end
end