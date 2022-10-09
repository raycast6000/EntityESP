local Vec2 = Vector2.new
local Col3 = Color3.new

_G.Tracer = {
    new = function ()
        local line = Drawing.new("Line")
        line.Visible = true
        line.From = Vec2(0, 0)
        line.To = Vec2(0, 0)
        line.Color = Col3(255,255,255)
        line.Thickness = 2

        return line
    end
}

return _G.Tracer