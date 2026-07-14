# 1 대 多 서바이벌 게임 킬러 & 생존자 정하기
# ServerScript


local CoreEvent = game.ReplicatedStorage:WaitForChild("CoreEvent")
local RoundStarted = false

local function StartRound()
    -- 1. 대기 시간 45초 알림
    CoreEvent:FireAllClients("Round", "Start", 30)

    -- 30초 동안 카운트다운 
    for i = 30, 0, -1 do
        local NumberOfPlayers = #game.Players:GetChildren() 

        -- 인원 부족 체크
        if NumberOfPlayers < 2 then 
            CoreEvent:FireAllClients("Round", "Clear") 
            RoundStarted = false 
            break
        end

        -- 2. 시간이 다 됐을 때 
        if i == 0 then
            local UserNameList = {}
            
            -- 접속 중인 모든 플레이어 이름을 명단에 넣기
            for _, v in pairs(game.Players:GetChildren()) do 
                table.insert(UserNameList, v.Name)
            end

            -- 명단에서 무작위로 한 명 뽑기 (랜덤 번호 생성)
            local RandomNumber = math.random(1, #UserNameList)
            local RandomUserName = UserNameList[RandomNumber] 

            -- [살인마 처리]
            local killer = game.Players:FindFirstChild(RandomUserName)
            if killer then
                killer.Team = game.Teams.Killer 
                if killer.Character then
                    killer.Character:PivotTo(workspace.KillerSpawn.CFrame) 
                end
            end

            -- [생존자 처리] 살인마가 아닌 나머지 사람들
            for _, v in pairs(game.Players:GetChildren()) do
                if v.Name ~= RandomUserName then 
                    v.Team = game.Teams.Survivors
                    if v.Character then
                        v.Character:PivotTo(workspace.SurvivorSpawn.CFrame)
                    end
                end
            end

            -- 3. 게임 시작 신호 (180초 진행)
            CoreEvent:FireAllClients("Round", "In progress", 180)
        end

        task.wait(1) 
    end
end

-- 인원 체크 후 라운드 시작
game.Players.PlayerAdded:Connect(function()
    if not RoundStarted then
        local NumberOfPlayers = #game.Players:GetChildren()
        if NumberOfPlayers >= 2 then 
            RoundStarted = true
            task.wait(2) 
            StartRound()
        end
    end
end)
