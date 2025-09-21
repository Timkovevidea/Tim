local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local flying = false
local speed = 14 -- tvoja požadovaná rýchlosť

userInputService.InputBegan:Connect(function(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.F and not gameProcessed then
		flying = not flying
	end
end)

runService.RenderStepped:Connect(function()
	if flying then
		local moveDirection = Vector3.new()
		if userInputService:IsKeyDown(Enum.KeyCode.W) then
			moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector
		end
		if userInputService:IsKeyDown(Enum.KeyCode.S) then
			moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector
		end
		if userInputService:IsKeyDown(Enum.KeyCode.A) then
			moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector
		end
		if userInputService:IsKeyDown(Enum.KeyCode.D) then
			moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector
		end
		if userInputService:IsKeyDown(Enum.KeyCode.Space) then
			moveDirection = moveDirection + Vector3.new(0,1,0)
		end
		if userInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
			moveDirection = moveDirection - Vector3.new(0,1,0)
		end

		if moveDirection.Magnitude > 0 then
			humanoidRootPart.Velocity = moveDirection.Unit * speed
		else
			humanoidRootPart.Velocity = Vector3.new(0,0,0)
		end
	else
		-- ak nelieta, nechá prirodzenú gravitáciu
		humanoidRootPart.Velocity = Vector3.new(0, humanoidRootPart.Velocity.Y, 0)
	end
end)
