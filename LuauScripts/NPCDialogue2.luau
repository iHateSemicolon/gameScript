# NPC 대화
# LocalScript
## 참고 : https://www.youtube.com/watch?v=CwiW2qUCJMQ&list=PLJbhAr3TixIDSymcUWQ4Spm1oK5QQ9nMh


local player = game.Players.LocalPlayer
local promptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local gui = script.Parent
local frame = gui:WaitForChild("MainFrame")
local viewport = frame:WaitForChild("NPCViewport")
local label = frame:WaitForChild("NPCNameLabel")

local currentClonedNPC = nil
local currentPrompt
local swayConnection = nil 
local idleTrack = nil


local function typeWrite(target, message)
	target.Text = ""
	for i = 1, utf8.len(message) do 
		target.Text = string.sub(message, 1, utf8.offset(message, i + 1) - 1)
		task.wait(0.05)
	end
end


local function toggleCameraSway(enable)
	if enable then
		local startTime = tick()
		swayConnection = runService.RenderStepped:Connect(function()
			local t = tick() - startTime
			local x = math.sin(t * 0.5) * 0.05
			local y = math.cos(t * 0.4) * 0.05
			camera.CFrame = camera.CFrame * CFrame.Angles(math.rad(x), math.rad(y), 0)
		end)
	else
		if swayConnection then
			swayConnection:Disconnect()
			swayConnection = nil
		end
	end
end


local function setupViewport(npcModel)
	if currentClonedNPC then currentClonedNPC:Destroy() end
	viewport:ClearAllChildren()

	local worldModel = Instance.new("WorldModel")
	worldModel.Parent = viewport

	local clonedNPC = npcModel:Clone()
	clonedNPC.Parent = worldModel
	currentClonedNPC = clonedNPC
	clonedNPC:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))

	local hum = clonedNPC:FindFirstChildOfClass("Humanoid")
	if hum then
		local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
		local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://107948884979606" 
		idleTrack = animator:LoadAnimation(anim)
		idleTrack.Looped = true
		idleTrack:Play()
		idleTrack:AdjustSpeed(0.08)
	end

	local vpCamera = Instance.new("Camera")
	vpCamera.Parent = viewport
	vpCamera.FieldOfView = 35
	viewport.CurrentCamera = vpCamera

	local root = clonedNPC:FindFirstChild("HumanoidRootPart")
	if root then
		local cameraDistance = -16 
		vpCamera.CFrame = CFrame.new(Vector3.new(0, 2, cameraDistance), root.Position + Vector3.new(0, 0.5, 0))
	end
end


local function startAutomaticDialogue(npc)
	setupViewport(npc)
	toggleCameraSway(true)

	currentPrompt = npc:FindFirstChildWhichIsA("ProximityPrompt", true)
	if currentPrompt then currentPrompt.Enabled = false end

	
	local originalPos = frame.Position
	local startPos = UDim2.new(1.5, 0, originalPos.Y.Scale, originalPos.Y.Offset)

	frame.Position = startPos
	frame.Visible = true

	
	local openTween = TweenService:Create(frame, TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Position = originalPos
	})
	openTween:Play()

	task.wait(1.2)

	typeWrite(label, "바보")
	task.wait(2)
	typeWrite(label, "앙")
	task.wait(2)

	
	local frameCloseTween = TweenService:Create(frame, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
		Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset, 1.5, 0)
	})

	local npcCloseTween = TweenService:Create(viewport, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
		Position = UDim2.new(1.5, 0, viewport.Position.Y.Scale, viewport.Position.Y.Offset)
	})

	frameCloseTween:Play()
	npcCloseTween:Play()


	frameCloseTween.Completed:Connect(function()
		frame.Visible = false
		toggleCameraSway(false)
		viewport.Position = UDim2.new(0, 0, 0, 0)

		if currentClonedNPC then currentClonedNPC:Destroy() end
		if currentPrompt then currentPrompt.Enabled = true end
	end)
end


promptService.PromptTriggered:Connect(function(prompt, playerWhoTriggered)
	if playerWhoTriggered == player and prompt.Name == "DialoguePrompt" then
		local npcModel = prompt:FindFirstAncestorOfClass("Model")
		if npcModel then 
			startAutomaticDialogue(npcModel) 
		end
	end
end)

frame.Visible = false
