local Vec2 = Vector2.new

_G.Text = {
    new = function (content)
        local text = Drawing.new("Text")
        text.Visible = true
        text.Text = content
        text.Size = 16
        text.Center = true
        text.Position = Vec2(0,0)

        return text
    end
}

return _G.Text