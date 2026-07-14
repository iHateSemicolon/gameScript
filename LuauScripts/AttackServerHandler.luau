# 실제 히트박스 판정 + 데미지
# ServerScript


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local attackEvent = ReplicatedStorage:WaitForChild("AttackEvent")

attackEvent.OnServerEvent:Connect(function(player)
	local character = player.Character
	if not character then return end
	local hitbox = character:FindFirstChild("Hitbox", true)
	if not hitbox then return end

	-- 서버에서 히트박스 영역 스캔
	local overlapParams = OverlapParams.new()
	overlapParams.FilterDescendantsInstances = {character}
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude

	local hitParts = workspace:GetPartBoundsInBox(hitbox.CFrame, hitbox.Size, overlapParams)
	local hitHumans = {}

	for _, part in ipairs(hitParts) do
		local targetChar = part:FindFirstAncestorOfClass("Model")
		if targetChar and targetChar ~= character then
			local targetHuman = targetChar:FindFirstChild("Humanoid")
			if targetHuman and not hitHumans[targetChar] then
				hitHumans[targetChar] = true
				targetHuman:TakeDamage(20) -- 실제 데미지 입힘
			end
		end
	end
end)
