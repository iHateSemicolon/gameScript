# 제로 캐릭터의 속도를 60으로 바꿈
# LocalScript


local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local Running = false

-- 쉬프트 입력을 감지해서 속도 조절 (ContextActionService 사용 시)
function Handler(BindName, InputState)
    if InputState == Enum.UserInputState.Begin and BindName == 'RunBind' then
        Running = true
        Humanoid.WalkSpeed = 60
    elseif InputState == Enum.UserInputState.End and BindName == 'RunBind' then
        Running = false
        Humanoid.WalkSpeed = 16
    end
end

game:GetService('ContextActionService'):BindAction('RunBind', Handler, true, Enum.KeyCode.LeftShift)
