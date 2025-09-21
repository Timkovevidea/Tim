local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local character = player.Character or player.CharacterAdded:Wait()
local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- ====================
-- Fly settings
-- ====================
local flying = false
local flySpeed = 14

-- Toggle fly on key F
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.F and not gameProcessed then
		flying = not flying
		if flying then
			HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
		end
	end
end)

-- Fly movement
RunService.RenderStepped:Connect(function()
	if flying then
		local moveDirection = Vector3.new()
		local cam = workspace.CurrentCamera.CFrame

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			moveDirection += cam.LookVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			moveDirection -= cam.LookVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			moveDirection -= cam.RightVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then
			moveDirection += cam.RightVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			moveDirection += Vector3.new(0,1,0)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
			moveDirection -= Vector3.new(0,1,0)
		end

		if moveDirection.Magnitude > 0 then
			HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + moveDirection.Unit * (flySpeed/60)
		end
	end
end)

-- ====================
-- ESP (Highlight all players)
-- ====================
local function addESP(character)
	if character:FindFirstChild("ESP_Highlight") then return end
	local highlight = Instance.new("Highlight")
	highlight.Name = "ESP_Highlight"
	highlight.FillColor = Color3.fromRGB(255,0,0) -- red fill
	highlight.OutlineColor = Color3.fromRGB(0,0,255) -- blue outline
	highlight.FillTransparency = 0.5
	highlight.OutlineTransparency = 0
	highlight.Adornee = character
	highlight.Parent = character
end

-- Add ESP when a player joins
Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		addESP(char)
	end)
end)

-- Add ESP for players already in the game
for _,plr in ipairs(Players:GetPlayers()) do
	if plr.Character then
		addESP(plr.Character)
	end
end
