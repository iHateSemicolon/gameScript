# 점프 비활성화
# ServerScript

local player = game.Players.LocalPlayer

player.CharacterAdded:Connect(function(char)
	local humanoid = char:WaitForChild("Humanoid")
	humanoid.JumpHeight = 0
end)
