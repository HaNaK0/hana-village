if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

Logger = require("src.logger")
local game = require("src.game")

function love.load()
    Log("Love load")
    game:load()
end

function love.update(dt)
    Logger:update(dt)

    game:update(dt)
end

function love.draw()
    Logger:draw()

    game:draw()
end

