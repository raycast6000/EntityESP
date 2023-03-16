local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

function Draw(entity: Model, line, info_label)
    local vector, screen = Camera:WorldToViewportPoint(entity.HumanoidRootPart.Position)

    if screen then
        line.Visible = true
        line.To = Vector2.new(vector.X, vector.Y)
        info_label.Position = Vector2.new(vector.X, vector.Y - 25)
        info_label.Visible = true

        if Player.Character:FindFirstChild("Humanoid") ~= nil then info_label.Text = ("%s (%d studs)"):format(entity.Name, (Player.Character.HumanoidRootPart.Position - entity.HumanoidRootPart.Position).Magnitude) end
    else
        line.Visible = false
        info_label.Visible = false
    end
end

function Link(entity: Model)
    print("Setting linker for", entity)

    local Highlight = Instance.new("Highlight", entity)
    Highlight.FillColor = Color3.fromRGB(166,166,166)
    Highlight.OutlineColor = Color3.fromRGB(255,255,255)
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    local Line = Drawing.new("Line")
    Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    Line.To = Vector2.new(0, 0)
    Line.Color = Color3.fromRGB(255, 255, 255)
    Line.Visible = true
    Line.Thickness = 2

    local info_label = Drawing.new("Text")
    info_label.Text = ""
    info_label.Visible = true
    info_label.Center = true
    info_label.Outline = true
    info_label.Color = Color3.fromRGB(255,255,255)
    info_label.Position = Vector2.new(0, 0)

    local Render = RunService.RenderStepped:Connect(function()
        if entity:FindFirstChild("HumanoidRootPart") ~= nil then
            Draw(entity, Line, info_label) 
        end
    end)

    workspace.ChildRemoved:Connect(function(child)
        if child == entity then
            Render:Disconnect()
            info_label:Remove()
            Line:Remove()
        end
    end)
end

for _,v in pairs(workspace:GetChildren()) do
    if v ~= Player.Character and v:isA("Model") and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
        Link(v)
    end
end

workspace.ChildAdded:Connect(function(child)
    if not Player.Character then Player.CharacterAdded:Wait() end
    if child.Name == Player.Name and child:WaitForChild("Humanoid", 1) ~= nil then return end

    if child ~= Player.Character and child:isA("Model") and child:FindFirstChildOfClass("Humanoid") or child:WaitForChild("Humanoid", 1) ~= nil and child:FindFirstChild("HumanoidRootPart") then
        Link(child)
    end
end)
