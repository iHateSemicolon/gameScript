# 특정 조건을 달성한 플레이어에게 뱃지(Badge)지급
# ServerScript


local BadgeService = game:GetService("BadgeService") -- 뱃지 관리 도구함

local Id = 6767667 -- 뱃지의 고유 번호 (로블록스 사이트에서 만든 뱃지 ID)

-- [1] 뱃지를 줄지 말지 판단하는 함수
function GiveBadge(Player)

    -- 플레이어의 레벨 값을 찾음
    local Level = Player:WaitForChild("leaderstats").Level

    -- 만약 레벨이 10 이상이라면
    if Level.Value >= 10 then

        -- 플레이어가 이미 이 뱃지를 가지고 있는지 확인 (중복 지급 방지)
        if not BadgeService:UserHasBadgeAsync(Player.UserId, Id) then

            -- 뱃지 지급!
            BadgeService:AwardBadge(Player.UserId, Id)
        end
    end
end

-- [2] 플레이어가 들어왔을 때 이벤트 연결
game.Players.PlayerAdded:Connect(function(Player)

    -- 들어오자마자 이미 레벨 10 이상인지 체크
    GiveBadge(Player)

    -- 레벨이 바뀔 때(업할 때)마다 체크
    Player:WaitForChild("leaderstats").Level.Changed:Connect(function()
        GiveBadge(Player)
    end)
end)
