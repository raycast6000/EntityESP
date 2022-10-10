local Vec2 = Vector2.new
local Col3 = Color3.new
local floor = math.floor

-- // VFX //
local TweenService = game:GetService("TweenService")
local In = Enum.EasingDirection.In
local Quint = Enum.EasingStyle.Quint

-- // Builders //
local TrBuilder = loadstring(readfile('EntityESP/builders/tracer.lua'))()
local BxBuilder = loadstring(readfile('EntityESP/builders/box.lua'))()
local TxtBuilder = loadstring(readfile('EntityESP/builders/text.lua'))()

-- // Player //
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Camera = workspace.CurrentCamera
local ScreenCenterX, ScreenCenterY = Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2

-- // Render //
local RunService = game:GetService("RunService")
local RenderStepped = RunService.RenderStepped
local Heartbeat = RunService.Heartbeat

-- // Whitelist //
local whitelist = {}

function checkExists(plr)
    local found = false
    
    for k,v in pairs(whitelist) do
        if v.player == plr then
            found = true
            break
        end
    end

    if found then
        return true
    else
        return false
    end
end

function hasHead(i)
    return i:FindFirstChild("Head")
end

function UpdateRender(tracer, tI, plr)
    local vector, onScreen = Camera:WorldToViewportPoint(plr.Head.Position)

    if onScreen and checkExists(plr) then
        tracer.Visible = true
        tI.Visible = true
        tI.Text = plr.Name .. " (" .. floor((Player.Character.HumanoidRootPart.Position - plr.HumanoidRootPart.Position).Magnitude) .. " studs)"
        tracer.To = Vec2(vector.X, vector.Y)
        tI.Position = Vec2(vector.X, vector.Y - 25)
    else
        tracer.Visible = false
        tI.Visible = false
    end
end

workspace.ChildRemoved:Connect(function (c)
    for k,v in pairs(whitelist) do
        if v.player == c then
            v.tracer:Remove()
            v.tInfo:Remove()
            table.remove(whitelist, k)
        end
    end
end)

workspace.ChildAdded:Connect(function (v)
    delay(1, function ()
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= Player.Character then
            print("Assigning a tracer to", v.Name)
    
            if hasHead(v) then
                local targetInfo = TxtBuilder.new(v.Name)
                targetInfo.Color = Col3(255,255,255)
        
                local Tracer = TrBuilder.new()
                Tracer.From = Vec2(ScreenCenterX, ScreenCenterY)
                Tracer.To = Vec2(0, 0)
    
                table.insert(whitelist, {player = v, tracer = Tracer, tInfo = targetInfo})
    
                local PlrRenderCycle = RenderStepped:Connect(function ()
                    if v ~= Character and checkExists(v) and hasHead(v) then
                        UpdateRender(Tracer, targetInfo, v)
                    end
                end)
    
            end
        end
    end)
end)

for _,v in pairs(workspace:GetChildren()) do
    if v:isA("Model") and v:FindFirstChild("Humanoid") and v ~= Player.Character then

        if hasHead(v) then
            local targetInfo = TxtBuilder.new(v.Name)
            targetInfo.Color = Col3(255,255,255)
    
            local Tracer = TrBuilder.new()
            Tracer.From = Vec2(ScreenCenterX, ScreenCenterY)
            Tracer.To = Vec2(0, 0)

            table.insert(whitelist, {player = v, tracer = Tracer, tInfo = targetInfo})

            local PlrRenderCycle = RenderStepped:Connect(function ()
                if v ~= Character and checkExists(v) and hasHead(v) then
                    UpdateRender(Tracer, targetInfo, v)
                end
            end)

        end
    end
end