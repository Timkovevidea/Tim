local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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
