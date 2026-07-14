# NPC 대화 스크립트
# LocalScript


local player = game.Players.LocalPlayer
local promptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local camera = workspace.CurrentCamera

local gui = script.Parent
local frame = gui:WaitForChild("MainFrame")
local label = frame:WaitForChild("NPCNameLabel")
local btn1 = frame:WaitForChild("Option1")
local btn2 = frame:WaitForChild("Option2")

local originalCameraCFrame
local currentPrompt -- 현재 상호작용 중인 프롬프트를 기억하기 위한 변수

-- 타자기 효과 함수
local function typeWrite(target, message)
	target.Text = ""
	for i = 1, utf8.len(message) do 
		target.Text = string.sub(message, 1, utf8.offset(message, i + 1) - 1)
		task.wait(0.03)
	end
end

-- 대화 시작 함수
local function startDialogue(npc)
	-- NPC의 머리나 루트파트를 찾음 (카메라 초점용)
	local head = npc:FindFirstChild("Head") or npc:FindFirstChild("HumanoidRootPart")
	if not head then return end

	-- 현재 프롬프트 숨기기
	currentPrompt = npc:FindFirstChildWhichIsA("ProximityPrompt", true)
	if currentPrompt then
		currentPrompt.Enabled = false
	end

	frame.Visible = true
	btn1.Visible = true
	btn2.Visible = true

	-- 카메라 트위닝 (튜닝)
	camera.CameraType = Enum.CameraType.Scriptable
	local targetCFrame = CFrame.new(head.Position + (head.CFrame.LookVector * 7) + Vector3.new(1, 1, 1), head.Position)

	local cameraTween = TweenService:Create(camera, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		CFrame = targetCFrame
	})
	cameraTween:Play()

	typeWrite(label, "수정")
	btn1.Text = "수정"
	btn2.Text = "수정"
end

-- 대화 종료 함수
local function closeDialogue(finalMsg)
	btn1.Visible = false
	btn2.Visible = false
	typeWrite(label, finalMsg)

	task.wait(1)

	--  카메라 복구
	camera.CameraType = Enum.CameraType.Custom
	frame.Visible = false

	--  숨겼던 프롬프트 다시 켜기
	if currentPrompt then
		currentPrompt.Enabled = true
		currentPrompt = nil
	end
end

-- 이벤트 연결
promptService.PromptTriggered:Connect(function(prompt, playerWhoTriggered)
	if playerWhoTriggered == player and prompt.Name == "DialoguePrompt" then
		local npcModel = prompt:FindFirstAncestorOfClass("Model")
		if npcModel then
			startDialogue(npcModel)
		end
	end
end)

btn1.MouseButton1Click:Connect(function() 
	closeDialogue("수정") 
end)

btn2.MouseButton1Click:Connect(function() 
	closeDialogue("hi") 
end)

-- 초기 상태 설정
frame.Visible = false
