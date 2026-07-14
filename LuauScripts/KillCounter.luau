# 플레이어가 다른 플레이어를 처치했을 때 '킬(Kill)' 점수를 올려주는 스크립트
# ServerScript

-- [1] 플레이어가 서버에 들어왔을 때 실행
game.Players.PlayerAdded:Connect(function(plr)
	
	-- 리더보드 생성 (점수판)
	local leaderstats = Instance.new("IntValue")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = plr
	
	-- "Kill" 점수 항목 만들기
	local money = Instance.new("IntValue")
	money.Name = "Kill" -- 화면에 "Kill"이라고 표시됨
	money.Parent = leaderstats
	
	-- [2] 플레이어의 캐릭터가 생성될 때마다 실행
	plr.CharacterAdded:Connect(function(char) -- 여기서 char라는 변수를 받아야 해!
		
		-- 캐릭터의 휴머노이드(체력 관리자)가 죽었을 때 실행
		char.Humanoid.Died:Connect(function()
			
			-- 누가 죽였는지 기록된 'creator' 태그가 있는지 확인
			local creator = char.Humanoid:FindFirstChild("creator")
			
			-- 만약 나를 죽인 사람(creator) 정보가 있다면?
			if creator then
				-- creator.Value는 나를 죽인 플레이어 객체야.
				local killplr = creator.Value
				
				-- 죽인 사람이 아직 게임에 남아있는지 확인 후 점수 +1
				if killplr then
					-- 그 사람의 리더보드에서 Kill 점수를 1 올림
					killplr.leaderstats.Kill.Value += 1
				end
			end
		end)
	end)
end)
