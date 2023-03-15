local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

function Draw(entity: Model, line)
    local vector, screen = Camera:WorldToViewportPoint(entity.HumanoidRootPart.Position)

    if screen then
        line.Visible = true
        line.To = Vector2.new(vector.X, vector.Y)
    else
        line.Visible = false
    end
end

function Link(entity: Model)
    print("Setting linker for", entity)

    local Line = Drawing.new("Line")
    Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    Line.To = Vector2.new(0, 0)
    Line.Color = Color3.fromRGB(255, 255, 255)
    Line.Visible = true
    Line.Thickness = 2

    local Render = RunService.RenderStepped:Connect(function()
        if entity:FindFirstChild("HumanoidRootPart") ~= nil then
            Draw(entity, Line) 
        end
    end)

    workspace.ChildRemoved:Connect(function(child)
        if child == entity then
            Render:Disconnect()
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
    if child ~= Player.Character and child:isA("Model") and child:FindFirstChildOfClass("Humanoid") or child:WaitForChild("Humanoid", 1) ~= nil and child:FindFirstChild("HumanoidRootPart") then
        Link(child)
    end
end)
