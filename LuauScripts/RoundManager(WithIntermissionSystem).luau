# Gui 에 숫자를 띄워주는 역할 (인터미션, 게임 진행 등등)
# LocalScript


-- 서비스 및 변수 설정
local PS = game:GetService("Players")
local CoreEvent = game.ReplicatedStorage:WaitForChild("CoreEvent") -- 서버의 신호를 받는 안테나
local Player = game.Players.LocalPlayer -- '나'
local CoreGui = Player.PlayerGui:WaitForChild("CoreGui") -- 내가 보고 있는 화면 UI 폴더
local BreakLoop = false -- 카운트다운을 중간에 강제로 멈추게 하는 스위치

-- [1] 서버에서 "CoreEvent"를 통해 신호를 보낼 때마다 실행
CoreEvent.OnClientEvent:Connect(function(eventtype, Arg1, Arg2)

    -- 이벤트 종류가 "Round" 인지 확인 (라운드 관련 신호인지)
    if eventtype == "Round" then
        local RoundType = Arg1 -- "Start"(대기), "Clear"(취소), "In progress"(진행)

        -- [2] "Start": 라운드 시작 전 대기 화면 (인터미션)
        if RoundType == "Start" then
            local Duration = Arg2 -- 서버가 정해준 시간 (예: 30초)
            CoreGui.RoundFrame.RoundTextLabel.Text = "Round starts in : "

            -- 카운트다운 반복문
            for i = Duration, 0, -1 do
                -- 인원 부족 등으로 서버가 "Clear" 신호를 주면 여기서 반복문 종료
                if BreakLoop then
                    CoreGui.RoundFrame.RoundTextLabel.Text = "Waiting for more players.."
                    CoreGui.RoundFrame.CountdownTextLabel.Text = "HEllo"
                    BreakLoop = false
                    break 
                end

                CoreGui.RoundFrame.RoundTextLabel.Text = i -- 화면에 남은 초 표시
                task.wait(1)
            end

        -- [3] "Clear": 인원이 부족하거나 문제가 생겨서 카운트다운을 멈춰야 할 때
        elseif RoundType == "Clear" then
            BreakLoop = true -- 위에서 돌아가던 for문을 멈추게 만듦

        -- [4] "In progress": 실제 게임이 시작되어 남은 시간 표시
        elseif RoundType == "In progress" then
            local Duration = Arg2 -- 게임 제한 시간 (예: 180초)
            CoreGui.RoundFrame.RoundTextLabel.Text = "Round ends in : "

            for i = Duration, 0, -1 do
                if BreakLoop then
                    CoreGui.RoundFrame.RoundTextLabel.Text = "Intermission"
                    CoreGui.RoundFrame.CountdownTextLabel.Text = "Hello"
                    BreakLoop = false
                    break
                end

                --초 단위를 "분:초"로
                local minutes = math.floor(i/60) -- 60으로 나눈 몫 (분)
                local seconds = i%60 -- 60으로 나눈 나머지 (초)

                -- string.format("%02d:%02d"): 숫자가 1자리면 앞에 0을 붙여서 "01:05" 처럼 만듦
                local time = string.format("%02d:%02d", minutes, seconds)

                CoreGui.RoundFrame.RoundTextLabel.Text = time
                task.wait(1)    
            end
        end
    end
end)
