# 특정 파트에 닿았을 때 다른 게임(플레이스)으로 이동시켜주는 텔레포트 스크립트
# ServerScript


local TeleportService = game:GetService("TeleportService") -- 텔레포트 기능을 담당하는 도구함
local part = script.Parent -- 이 스크립트가 들어있는 파트 (텔레포트 발판)

-- 텔레포트할 때 함께 보낼 데이터 (예: 앉아있는 상태인지 등)
local teleportData = {
    isPlayerCrouching = false
}

part.Touched:Connect(function(hit)

    -- 발판에 닿은 대상에게 'Humanoid'가 있는지 확인
    local human = hit.Parent:FindFirstChild("Humanoid")
    
    if human then 
        local char = hit.Parent

        -- 캐릭터를 통해 플레이어 객체를 가져옴
        local player = game.Players:GetPlayerFromCharacter(char)
        
        if player then
            -- Teleport(이동할 맵 ID, 플레이어, 보낼 데이터)
            -- 676767 부분에 실제 이동할 게임의 ID 숫자를 넣어야함
            TeleportService:Teleport(676767, player, teleportData)
        end
    end
end)
