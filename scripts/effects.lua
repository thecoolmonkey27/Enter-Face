effectCircle = Object.extend(Object)

function effectCircle:new(x, y, maxRadius, color)
    self.x,self.y = x,y
    self.maxRadius = maxRadius
    self.currentRadius = 0
    self.color = color
end

function effectCircle:effect(time, delay)
    flux.to(self, time/2, {currentRadius = self.maxRadius}):after(self, time/2, {currentRadius = 0}):delay(delay)
end

function effectCircle:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle('fill', self.x, self.y, self.currentRadius)
    love.graphics.setColor(1, 1, 1, 1)
end

effectPoints = Object.extend(Object)

function effectPoints:new(x, y)
    self.x,self.y = x,y
    self.opacity = 0
    self.returnX,self.returnY = x,y
    self.value = 1
end

function effectPoints:effect(value)
    flux.to(self, .1, {opacity = 1}):after(self, 1, {opacity = 0}):delay(1)
    self.value = value
end

function effectPoints:draw(points)
    love.graphics.setColor(1, 1, 1, self.opacity)
    love.graphics.printf(tostring(points), self.x, self.y, 128, 'center', 0, .5, .5)
    love.graphics.setColor(1, 1, 1, 1)
end