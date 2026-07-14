# 라운드 기반 게임 시스템
# ServerScript


local PS = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreEvent = ReplicatedStorage:WaitForChild("CoreEvent") -- 클라이언트와 통신할 리모트 이벤트

local RoundStarted = false -- 현재 라운드가 진행 중인지 확인하는 변수

-- [1] 라운드 시작 및 관리 함수
local function StartRound()
    -- 모든 플레이어에게 "라운드 대기 시작(30초)" 신호를 보냄
    CoreEvent:FireAllClients("Round", "Start", 30)

    for i = 30, 0, -1 do -- 30초부터 0초까지 카운트다운
        local AllPlayers = PS:GetPlayers()
        local NumberOfPlayers = #AllPlayers

        -- 인원 부족 체크 (최소 2명이 안 되면 중단)
        if NumberOfPlayers < 2 then 
            CoreEvent:FireAllClients("Round", "Clear") -- 화면의 타이머 지우기 신호
            RoundStarted = false
            return -- 함수를 즉시 종료
        end

        -- [2] 카운트다운이 0초가 되었을 때 (실제 게임 시작)
        if i == 0 then
            -- {셔플} 플레이어 명단을 무작위로 섞기 (피셔-예이츠 셔플 알고리즘)
            for j = #AllPlayers, 2, -1 do
                local r = math.random(1, j)
                AllPlayers[j], AllPlayers[r] = AllPlayers[r], AllPlayers[j]
            end

            -- {팀 나누기} 명단의 절반을 계산
            local halfCount = math.floor(#AllPlayers / 2)
            if halfCount < 1 then halfCount = 1 end

            -- {할당 및 이동} 섞인 명단 앞부분은 레드팀, 뒷부분은 블루팀
            for index, plr in pairs(AllPlayers) do
                if index <= halfCount then
                    plr.Team = game.Teams.Red
                    if plr.Character then
                        -- 레드팀 스폰 지점으로 텔레포트
                        plr.Character:PivotTo(workspace.RedSpawn.CFrame)
                    end
                else
                    plr.Team = game.Teams.Blue
                    if plr.Character then
                        -- 블루팀 스폰 지점으로 텔레포트
                        plr.Character:PivotTo(workspace.BlueSpawn.CFrame)
                    end
                end
            end

            -- [3] 클라이언트에게 "게임 진행 중(180초)" 알림 전송
            CoreEvent:FireAllClients("Round", "In progress", 180)
        end

        task.wait(1) -- 1초 대기
    end

    RoundStarted = false -- 라운드가 끝나면 다시 시작 가능하게 설정
end

-- [4] 새로운 플레이어가 들어왔을 때 체크
PS.PlayerAdded:Connect(function()
    -- 이미 게임이 시작된 게 아니라면 인원수 체크 후 시작
    if not RoundStarted then
        local NumberOfPlayers = #PS:GetPlayers()
        if NumberOfPlayers >= 2 then
            RoundStarted = true -- 중복 실행 방지
            task.wait(2) -- 잠시 대기 후 라운드 함수 실행
            StartRound()
        end
    end
end)
