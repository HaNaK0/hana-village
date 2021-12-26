--Main game table
local game = {
    --Contains all actors. If a table is added to this table
    --Update and Draw will be called on the table if they exist
    actors = {},
    --Set to true if actors are added or depth is changed
    dirty = false
}

local actors_mt = {
    __newindex = function (t, key, value)
        rawset(t, key, value)
        game.dirty = true

        if type(key) == "string" then
            table.insert(t, value)
        end
    end,
}
setmetatable(game.actors, actors_mt)

function game:load()
    self.actors.test = {depth = 0, name = "Hej"}
    self.actors.test_2 = {
        depth =  2, 
        name = "Nej",
        draw = function ()
            love.graphics.setColor(0, 1, 0, 1)
            love.graphics.rectangle("fill", 100, 100, 10, 10)
        end
    }

    self:sortActors()
end

-- Sorts the actors according to depth
-- Sorting will only run if game is set to dirty
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

function game:update(dt)
    for _, actor in ipairs(self.actors) do
        if type(actor.update) == "function" then
            actor:update(dt, self.actors)
        end
    end
end

function game:draw()
    self:sortActors()

    for _, actor in ipairs(self.actors) do
        if type(actor.draw) == "function" then
            actor:draw()
        end
    end
end

return game
