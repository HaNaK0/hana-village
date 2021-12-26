local logger = {
    log_time = 3,
    log_origin = { x = 0, y = 0},
    text_size = 12,
    font = love.graphics.setNewFont(12),
    logs = {},
}

function logger:log(message)
    table.insert(self.logs, {message = message, time = 0})
end

local function intensity(t)
    -- This function controlls intesity
    -- t is the time from 0 to 1
    -- the function returns an intensity value from 0 to 1
    local unclampedOut = -3 * t + 3

    return math.min(unclampedOut, 1)
end

function logger:update(dt)
    local old_logs = {}

    for index, value in ipairs(self.logs) do
        value.time =  value.time + dt

        if value.time > self.log_time then
            table.insert(old_logs, 1, index)
        end
    end

    for index, value in ipairs(old_logs) do
        table.remove(self.logs, value)
    end
end

function logger:draw()
    local x = self.log_origin.x

    for index, value in ipairs(self.logs) do
        love.graphics.setColor(1,1,1, intensity(value.time / self.log_time))
        local y = self.log_origin.y + (self.font:getAscent() * (index - 1))
        love.graphics.print(value.message, x, y)
    end
end

function Log(message)
    print(message)
    logger:log(message)
end

return logger