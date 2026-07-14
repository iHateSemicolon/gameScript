# 플레이어의 점수(돈, 레벨 등)를 서버에 저장하고, 다음에 다시 들어왔을 때 불러오는 기능
# ServerScript


-- [1] 서비스 및 변수 설정
local DataStoreService = game:GetService("DataStoreService")

-- "PlayerStats"라는 이름의 저장 장부를 열거나 만듭니다. (실제 데이터가 저장되는 공간)
local datastore = DataStoreService:GetDataStore("PlayerStats")

-- [2] 플레이어가 게임에 들어왔을 때 (데이터 불러오기)
game.Players.PlayerAdded:Connect(function(plr)
	
	-- 리더보드(화면 오른쪽 상단 표) 만들기
	local leaderstats = Instance.new("Folder") 
	leaderstats.Name = "leaderstats" --"leaderstats"여야 표가 나타남
	leaderstats.Parent = plr

	-- "Money"라는 이름의 숫자 값을 만들기
	local money = Instance.new("IntValue")
	money.Name = "Money"
	money.Parent = leaderstats
	money.Value = 0 -- 처음 온 사람은 0원에서 시작

	--  데이터베이스에서 저장된 값 불러오기
	-- pcall은 'Protected Call'의 약자로, 에러가 나도 게임이 멈추지 않게 보호해주는 기능
	local s, data = pcall(function()
		-- 플레이어의 고유 번호(UserId)를 열쇠로 써서 저장된 값을 찾아옴
		return datastore:GetAsync(plr.UserId)
	end)

	if s and data then 
		-- 불러오기 성공(s)했고 저장된 데이터(data)가 있다면 돈을 설정
		money.Value = data
	elseif not s then
		-- 만약 서버 문제로 불러오지 못했다면 경고 메시지를 띄워.
		warn("데이터를 불러오는데 실패했습니다: " .. data)
	end
end)

-- [3] 플레이어가 게임을 나갈 때 (데이터 저장하기)
game.Players.PlayerRemoving:Connect(function(plr)
	
	-- 나갈 때 그 플레이어의 leaderstats가 있는지 확인
	if plr:FindFirstChild("leaderstats") then
		local s, e = pcall(function()
			-- 현재 가지고 있는 Money 값을 플레이어 번호(UserId)에 맞춰서 저장
			datastore:SetAsync(plr.UserId, plr.leaderstats.Money.Value)
		end)


		end
	end
end)

-- [4] 서버 자체가 꺼질 때 (마지막 안전장치)
game:BindToClose(function()
	-- 서버가 갑자기 닫힐 때 데이터를 저장할 시간을 벌어주는 것
	task.wait(2) 
end)
