# 히트박스 클릭 감지 + 쿨타임 + 시각 효과 + 서버 신호
# LocalScript


local player = game.Players.LocalPlayer
local character = script.Parent
local hitbox = character:WaitForChild("Hitbox")
local mouse = player:GetMouse()
local remoteEvent = game.ReplicatedStorage:WaitForChild("AttackEvent")
local TweenService = game:GetService("TweenService")

local COOLDOWN_TIME = 1
local lastAttack = 0

-- 공격 실행 함수 (시각 효과 + 신호 전송)
local function performAttack()
	if tick() - lastAttack < COOLDOWN_TIME then return end
	lastAttack = tick()

	-- 1. 서버에 공격 신호 전송 (데미지 처리는 서버가!)
	remoteEvent:FireServer()

	-- 2. 내 화면에만 보이는 시각 효과 (빨간색 반짝)
	hitbox.Transparency = 0.4
	hitbox.Color = Color3.fromRGB(255, 0, 0)

	local tween = TweenService:Create(hitbox, TweenInfo.new(0.5), {
		Transparency = 1,
		Color = Color3.fromRGB(163, 162, 165)
	})
	tween:Play()
end

-- 마우스 클릭 시 실행
mouse.Button1Down:Connect(performAttack)
