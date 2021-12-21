if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

Logger = require("src.logger")

function love.load()
    Log("Love load")
    Log("Hello world")
end

function love.update(dt)
    Logger:update(dt)
end

function love.draw()
    Logger:draw()
end

