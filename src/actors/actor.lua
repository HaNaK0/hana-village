local actor = {
    name = "Mina",
    position = {x = 100, y = 100},
    depth = 1,
    speed = 2,
    t = 0,
}

function actor:update(dt, messages)
    self.t = self.t + (dt / 5)
    if self.t >= 1 then
        self.t = 0
    end

    local dX = math.sin(math.pi * self.t * 2) * self.speed
    local dY = math.cos(math.pi * self.t * 2) * self.speed

    self.position.x = self.position.x + dX
    self.position.y = self.position.y + dY

    return GameResult.OK
end


function actor:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", self.position.x, self.position.y, 10, 10)
end

return actor