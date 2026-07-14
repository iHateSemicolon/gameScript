# 기본 리더보드 스크립트
# ServerScript


local Players = game:GetService("Players")

local LN = "leaderstats"
local CN = "Test(money ig..)"

local function onPlayerAdded(plr)
    
    local LS = Instance.new("Folder") -- IntValue -> Folder
    LS.Name = LN
    LS.Parent = plr 
    
    local money = Instance.new("IntValue")
    money.Name = CN
    money.Value = 0
    money.Parent = LS
end

Players.PlayerAdded:Connect(onPlayerAdded)
