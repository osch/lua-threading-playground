local llthreads = require("llthreads2.ex")

local THREAD_COUNT = 1000

local thread_code = function()

    local lpeg = require("lpeg") -- no crash without this line

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
    local thread = llthreads.new(thread_code)
    threads[i] = thread
    thread:start()
end

for i = 1, THREAD_COUNT do 
    local thread = threads[i]
    thread:join()
end
print("OK.")
