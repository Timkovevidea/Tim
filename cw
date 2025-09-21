local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TrainingMenu"
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 300)
mainFrame.Position = UDim2.new(0, 20, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Visible = true

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Training Menu"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = mainFrame

-- Function to create toggles
local function createToggle(name, parent, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = UDim2.new(0, 10, 0, (#parent:GetChildren()-1)*45)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.3, -10, 0.6, 0)
    button.Position = UDim2.new(0.7, 5, 0.2, 0)
    button.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    button.Text = default and "ON" or "OFF"
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 16
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.Parent = frame

    local state = default

    button.MouseButton1Click:Connect(function()
        state = not state
        button.Text = state and "ON" or "OFF"
        button.BackgroundColor3 = state and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    end)

    return function() return state end
end

-- Create toggles
local silentAimToggle = createToggle("Silent Aim", mainFrame, true)
local killAuraToggle = createToggle("Kill Aura", mainFrame, true)
local hitboxToggle = createToggle("Hitbox Extender", mainFrame, true)
local espToggle = createToggle("ESP", mainFrame, true)

-- Connect toggles to functionality
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

RunService.RenderStepped:Connect(function()
    local target
    if silentAimToggle() or killAuraToggle() or hitboxToggle() or espToggle() then
        -- Get closest target
        target = nil
        local shortestDistance = 100
        for _, tPlayer in pairs(Players:GetPlayers()) do
            if tPlayer ~= player and tPlayer.Character and tPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (tPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then
                    target = tPlayer
                    shortestDistance = distance
                end
            end
        end
    end

    if target then
        if silentAimToggle() then
            local targetPos = target.Character.HumanoidRootPart.Position
            local dir = (targetPos - camera.CFrame.Position).Unit
            camera.CFrame = camera.CFrame:Lerp(CFrame.lookAt(camera.CFrame.Position, camera.CFrame.Position + dir*50), 0.2)
        end

        if killAuraToggle() then
            print("Attacking:", target.Name)
        end

        if hitboxToggle() then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp and not hrp:FindFirstChild("Hitbox") then
                local hitbox = Instance.new("Part")
                hitbox.Size = Vector3.new(2,2,2)
                hitbox.Transparency = 1
                hitbox.CanCollide = false
                hitbox.Anchored = false
                hitbox.Name = "Hitbox"
                hitbox.CFrame = hrp.CFrame
                hitbox.Parent = target.Character
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = hrp
                weld.Part1 = hitbox
                weld.Parent = hitbox
            end
        end

        if espToggle() then
            if not target.Character:FindFirstChild("ESPHighlight") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESPHighlight"
                highlight.Parent = target.Character
                highlight.FillColor = Color3.fromRGB(255,0,0)
                highlight.OutlineColor = Color3.fromRGB(0,0,255)
            end
        end
    end
end)
