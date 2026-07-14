# 몬스터(몹)의 몸체에 닿았을 때 플레이어에게 데미지를 주는 접촉 데미지 스크립트
# ServerScript


local damage = 10 -- 몬스터가 주는 데미지 양
local damagecool = 1 -- 다음 데미지를 주기까지의 대기 시간(초)

local value = false -- 현재 쿨타임 중인지 확인하는 변수 (중복 데미지 방지)

-- [1] 몬스터 모델 안에 있는 모든 부품(Part)을 찾아서 만지면 데미지를 주게 설정
for i, v in pairs(script.Parent:GetChildren()) do

    -- 부품이 Part이거나 MeshPart일 때만 작동
    if v:IsA("BasePart") then 
        v.Touched:Connect(function(hit)

            -- 부딪힌 대상에게 'Humanoid'(체력바)가 있는지 확인
            local h = hit.Parent:FindFirstChild("Humanoid")

            -- 조건: 쿨타임이 아니고(false), 휴머노이드가 있고, 몬스터 본인이 살아있을 때
            if value == false and h and script.Parent:FindFirstChild("mob") and script.Parent.mob.Health > 0 then
                value = true -- 쿨타임 시작

                h:TakeDamage(damage) -- 데미지 입힘

                task.wait(damagecool) -- 1초 기다림

                value = false -- 쿨타임 끝! (다시 문을 엶)
            end
        end) -- Touched 함수 끝
    end -- if문 끝
end -- for문 끝
