# 버튼을 눌렀을 때 플레이어에게 게임패스 구매 창을 띄워줌
# LocalScript


-- [1] 변수 설정
local MarketService = game:GetService("MarketplaceService") 
local GamePassID = 1234567 -- 여기에 실제 게임패스 ID 숫자

-- [2] 마우스가 버튼 영역을 벗어났을 때 (MouseLeave)
script.Parent.MouseLeave:Connect(function()
    script.Parent.Visible = false -- 현재 버튼(창)을 숨김
    script.Parent.Parent.ImageButton.Visible = true -- 원래 있던 버튼을 다시 보여줌
end)

-- [3] 버튼을 클릭했을 때 구매 창 띄우기 (MouseButton1Click)
script.Parent.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    
    -- 게임패스 구매 창을 띄우는 명령어
    MarketService:PromptGamePassPurchase(player, GamePassID)
end)
