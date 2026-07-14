# 쉬프트 입력을 감지해서 서버(스테미나)와 기능 스크립트에 신호를 보냄
# LocalScript


local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent가 나타날 때까지 기다리기
local Remote = ReplicatedStorage:WaitForChild("StaminaEvent")

UIS.InputBegan:Connect(function(input, processed)
	-- 1. 채팅창 입력 중이면 무시
	if processed then return end

	-- 2. 누른 게 '키보드' 입력인지 확인하고 '왼쪽 쉬프트'인지 체크
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.LeftShift then
			
			Remote:FireServer("Start")
		end
	end
end)

UIS.InputEnded:Connect(function(input, processed)
	-- 뗐을 때도 동일하게 체크)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.LeftShift then
			
			Remote:FireServer("Stop")
		end
	end
end)
