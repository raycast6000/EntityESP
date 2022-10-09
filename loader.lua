local textBuilder = game:HttpGet("https://raw.githubusercontent.com/raycast6000/EntityESP/main/builders/text.lua")
local boxBuilder = game:HttpGet("https://raw.githubusercontent.com/raycast6000/EntityESP/main/builders/box.lua")
local tracerBuilder = game:HttpGet("https://raw.githubusercontent.com/raycast6000/EntityESP/main/builders/tracer.lua")

local main = game:HttpGet("https://raw.githubusercontent.com/raycast6000/EntityESP/main/main.lua")

xpcall(function ()
    print("Compiling scripts...")
    makefolder("EntityESP")
    makefolder("EntityESP/builders")
    
    print("Compiling builders/text")
    writefile("EntityESP/builders/text.lua", textBuilder)
    
    print("Compiling builders/box")
    writefile("EntityESP/builders/box.lua", boxBuilder)

    print("Compiling builders/tracer")
    writefile("EntityESP/builders/tracer.lua", tracerBuilder)

    print("Compiling main script...")
    writefile("EntityESP/main.lua", main)

    print("Compilation successful! Starting script...")
    loadstring(readfile("EntityESP/main.lua"))()
end, function (err)
    print(err)
end)