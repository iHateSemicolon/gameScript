# 내 캐릭터 머리 위에 떠 있는 체력바(Health Bar)를 실시간으로 부드럽게 업데이트해주는 스크립트 (단독시 내 머리에서만)
# LocalScript


local player = game.Players.LocalPlayer
local character = script.Parent -- 이 스크립트가 캐릭터 안에 들어있다고 가정함
local humanoid = character:WaitForChild("Humanoid")
local TweenService = game:GetService("TweenService") -- 부드러운 움직임을 위한 서비스

-- [1] 캐릭터 머리(Head) 안에 있는 UI 찾기
local head = character:WaitForChild("Head")
local billboard = head:WaitForChild("HealthAndNameTag") -- 서버에서 미리 넣어둔 BillboardGui 이름

-- [2] 그 UI 안에서 실제 초록색 막대기(Frame) 찾기
local bar = billboard:FindFirstChild("GreenBar", true)

if bar then
    -- [3] 체력바 길이를 업데이트하는 함수
    local function updateHealthBar(currentHealth)
        -- 현재 체력을 비율(0~1)로 계산 
        local percent = math.clamp(currentHealth / humanoid.MaxHealth, 0, 1)
        
        -- TweenService를 이용해 Size를 부드럽게 변경 (0.3초 동안)
        -- UDim2.new(percent, 0, 1, 0) -> 가로 길이를 남은 체력 비율만큼 조절
        TweenService:Create(bar, TweenInfo.new(0.3), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
    end

    -- [4] 이벤트 연결: 체력이 변할 때마다 함수 실행
    humanoid.HealthChanged:Connect(updateHealthBar)
    
    -- 처음에 한 번 실행해서 현재 체력에 맞게 바 설정
    updateHealthBar(humanoid.Health)
end
