local luaproc = require("luaproc")

local THREAD_COUNT = 1000
luaproc.setnumworkers(THREAD_COUNT)

local thread_code = function()

    local lpeg = require("lfs") -- no crash without this line

    local loadstring = loadstring or load
    local x = 1
    while x < 1000 do 
        x = x + 1 
        -- do some work
        assert(x == loadstring("return "..x)())
    end
end

local threads = {}

for i = 1, THREAD_COUNT do 
    local thread = luaproc.newproc(thread_code)
    threads[i] = thread
end

luaproc.wait()

print("OK.\n")
