--Main game table
local game = {
    --Contains all actors. If a table is added to this table
    --Update and Draw will be called on the table if they exist
    actors = {},
    --Set to true if actors are added or depth is changed
    dirty = false,
    messages = {},
}

GameResult = {
    OK = 0,
    DELETE = 1,
}

---Meta table for the actors table
local actors_mt = {
    __newindex = function (t, key, value)
        if type(key) == "string" then
            rawset(t, key, value)
            value.__id = key
            game.dirty = true
            table.insert(t, value)
        else
            Error("Cannot add an actor only with index, It needs to use a key")
        end
    end,
}
setmetatable(game.actors, actors_mt)

---Called first and should be the method that adds all the starting actors
function game:load()
    self.actors.Mina = require("src.actors.actor");
    assert(self.actors.Mina)

    self:sortActors()
end

---If game is marked as dirty then the objects get sorted according to depth
function game:sortActors()
    if self.dirty == false then
        return
    end
    Log("Actors dirty")
    Log("Sorting actors based on depth")

    table.sort(self.actors, function (a, b)
        return (a.depth or 0) > (b.depth or 0)
    end)

    self.dirty = false
end

---Update all the actors added to the game
---@param dt number the time since last update
function game:update(dt)
    local i = 1
    while i <= #self.actors do
        local actor = self.actors[i]
        if type(actor.update) == "function" then
            local result = actor:update(dt, self.messages)

            -- If result is delete remove the actor
            if result == GameResult.DELETE then
                table.remove(self.actors, i)
                self.actors[actor.__id] = nil
                i = i - 1
            end
        else
            Error("Actor without an update function, actor will be removed. Actor: " .. actor.__id)
            table.remove(self.actors, i)
            self.actors[actor.__id] = nil
            i = i - 1
        end
        i = i + 1
    end
end

---Draw all the actors with a draw function
function game:draw()
    self:sortActors()

    for _, actor in ipairs(self.actors) do
        if type(actor.draw) == "function" then
            actor:draw()
        end
    end
end

return game
