local logger = {
    log_time = 3,
    log_origin = { x = 0, y = 0},
    text_size = 12,
    font = love.graphics.setNewFont(12),
    logs = {},
    color = {
        log = {r = 1, g = 1, b = 1},
        error = {r = 1, g = 1, b = 1}
    }
}

---Write message to the screen
---@param message string
function logger:log(message)
    table.insert(self.logs, {message = message, time = 0, type = "log", color = self.color.log})
end

---Write an error message to the screen
---@param message string
function logger:error(message)
    table.insert(self.logs, {message = message, time = 0, type = "error", color = self.color.error})
end

---Function to calculate alpha of text that fades towards the end
---@param t number the time from 0 to 1
---@return number --alpah value
local function intensity(t)
    local unclampedOut = -3 * t + 3

    return math.min(unclampedOut, 1)
end

--- Updates the timers of the log entries and removes old entries
---@param dt number Time since last update
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

---Draws the log messages to the screen
function logger:draw()
    local x = self.log_origin.x

    for index, entry in ipairs(self.logs) do
        local color = {entry.color.r, entry.color.g, entry.color.b, intensity(entry.time / self.log_time)}
        love.graphics.setColor(color)
        local y = self.log_origin.y + (self.font:getAscent() * (index - 1))
        love.graphics.print(entry.message, x, y)
    end
end

---Write message to the console and to the screen
---@param message string
function Log(message)
    message = "LOG: " .. message
    print(message)
    logger:log(message)
end

---Write an error message to the console and the screen
---@param message string
function Error(message)
    message = "ERROR: " .. message
    print(message)
    logger:error(message)
end

return logger