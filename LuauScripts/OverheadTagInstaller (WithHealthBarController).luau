# 모든 플레이어의 머리 위에 그 체력바 달기 (StarterCharacterScripts에 넣어두면 다른 플레이어들 체력바도 보임)
# ServerScript


local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- [1] ReplicatedStorage에 미리 만들어둔 UI 원본 가져오기
local tagTemplate = ReplicatedStorage:WaitForChild("PlayerTag") 

local function setupPlayer(player)
    -- 플레이어의 캐릭터가 나타날 때마다(리스폰 포함) 실행
    player.CharacterAdded:Connect(function(character)
        local head = character:WaitForChild("Head")

        -- [2] UI 원본을 복사해서 머리에 붙이기
        local newTag = tagTemplate:Clone()
        newTag.Name = "HealthAndNameTag" -- 아까 로컬 스크립트가 찾던 그 이름
        newTag.Parent = head
        newTag.Adornee = head -- UI가 머리를 따라다니도록 고정

        -- [3] 이름표에 플레이어의 이름을 적어줌
        local nameLabel = newTag:FindFirstChild("NameLabel", true)
        if nameLabel then
            nameLabel.Text = player.Name
        end
    end)
end

-- [4] 새로운 플레이어가 들어올 때 실행
Players.PlayerAdded:Connect(setupPlayer)

-- [5] 서버가 켜질 때 이미 접속해 있는 플레이어들도 챙겨주기
for _, plr in pairs(Players:GetPlayers()) do
    setupPlayer(plr)
end
