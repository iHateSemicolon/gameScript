# 좌클릭 감지(히트박스 용)
# LocalScript


local S = require(game.ReplicatedStorage.S)
local mouse = S.Players.LocalPlayer:GetMouse()
local character = script.Parent
local remoteEvent = game.ReplicatedStorage:WaitForChild("AttackEvent") 

local COOLDOWN_TIME = 1
local lastAttack = 0

mouse.Button1Down:Connect(function()
	if tick() - lastAttack >= COOLDOWN_TIME then
		lastAttack = tick()
		remoteEvent:FireServer() 
	end
end)
