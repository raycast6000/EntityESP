local Vec2 = Vector2.new
local Col3 = Color3.new

_G.Box = {
    new = function ()
        local Box = Drawing.new("Square")
        
        Box.Visible = true
        Box.Filled = false
        Box.Thickness = 2
        Box.Position = Vec2(0, 0)
        Box.Size = Vec2(0, 0)

        return Box
    end
}

return _G.Box