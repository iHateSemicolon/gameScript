# 원거리 혹은 근접 공격을 할 때 사용하는 히트박스(Hitbox) 판정 시스템 (GetPartBoundsInBox_ver.)
# ServerScirpt

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService") 
local attackEvent = ReplicatedStorage:WaitForChild("AttackEvent")

attackEvent.OnServerEvent:Connect(function(player)
    local character = player.Character
    if not character then return end

    -- [1] 캐릭터 안에 미리 만들어둔 "Hitbox" 파트를 찾음
    local hitbox = character:FindFirstChild("Hitbox", true)
    if not hitbox then return end

    -- [2] 시각 효과: 공격할 때 히트박스를 살짝 보여줌 (빨간색)
    hitbox.Transparency = 0.5
    hitbox.Color = Color3.fromRGB(255, 0, 0) 

    -- [3] 트윈 애니메이션: 히트박스가 서서히 투명해지게 만듦
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local goal = {
        Transparency = 1,
        Color = Color3.fromRGB(165, 0, 0)
    }
    local tween = TweenService:Create(hitbox, tweenInfo, goal)
    tween:Play()

    -- [4] 판정 설정: 공격자 본인은 데미지를 입지 않도록 제외함
    local overlapParams = OverlapParams.new()
    overlapParams.FilterDescendantsInstances = {character}
    overlapParams.FilterType = Enum.RaycastFilterType.Exclude

    -- [5] 범위 체크: 히트박스 영역 안에 들어온 파트들을 싹 다 긁어모음
    local hitParts = workspace:GetPartBoundsInBox(hitbox.CFrame, hitbox.Size, overlapParams)
    local hitHumans = {} -- 중복 데미지 방지용 명단

    for _, part in ipairs(hitParts) do
        -- 부딪힌 파트의 부모 모델(캐릭터)을 찾음
        local targetChar = part:FindFirstAncestorOfClass("Model")

        if targetChar and targetChar ~= character then
            local targetHuman = targetChar:FindFirstChild("Humanoid")

            if targetHuman and not hitHumans[targetChar] then
                hitHumans[targetChar] = true -- 명단에 추가 (한 번만 맞게 함)
                targetHuman:TakeDamage(20) -- 20 데미지
                
                
            end
        end
    end
end)
