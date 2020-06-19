# Test Cases for multi threading Lua

This repository contains two test cases that are showing crashes 
using LuaJIT when native lua packages are loaded in other threads.

### Tests

   * [test01](#test01) - uses [lua-llthreads2] as threading library and
                         [lpeg] as native lua package

   * [test02](#test02) - uses [luaproc] as threading library and
                         [luafilesystem] as native lua package

#### Test Results for both tests:
   
   * no crash with Lua 5.1, 5.2 and 5.3
   * crash with LuaJIT 2.0 and 2.1 under Linux
   * see [Travis CI Results] for result details

```
*** Error in `lua': double free or corruption (fasttop): 0x00007f43400008c0 ***
```   

## [test01](test01.lua)

```lua
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

```

## [test02](test02.lua)

```lua
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
```


[lua-llthreads2]:    https://luarocks.org/modules/moteus/lua-llthreads2
[luaproc]:           https://luarocks.org/modules/askyrme/luaproc
[lpeg]:              https://luarocks.org/modules/gvvaughan/lpeg
[luafilesystem]:     https://luarocks.org/modules/hisham/luafilesystem
[Travis CI Results]: https://travis-ci.com/github/osch/lua-threading-playground
   
