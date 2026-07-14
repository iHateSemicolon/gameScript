# 관전 시스템
# Local, Server


-- ServerScript
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SpectateEvent = ReplicatedStorage:WaitForChild("SpectateEvent")
local SpectatePrompt = script.Parent

SpectatePrompt.Triggered:Connect(function(Player)

	SpectateEvent:FireClient(Player, SpectatePrompt)

end)

-- LocalScript
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SpectateEvent = ReplicatedStorage:WaitForChild("SpectateEvent")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local LocalCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local LocalHumanoid = LocalCharacter:WaitForChild("Humanoid")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local MainHUD = PlayerGui:FindFirstChild("StaminaAndHPBar")
local OriginalWalkSpeed = LocalHumanoid.WalkSpeed
local OriginalJumpHeight = LocalHumanoid.JumpHeight
local Camera = workspace.CurrentCamera
local Gui = script.Parent
local ExitButton = Gui:WaitForChild("ExitButton")
local BackButton = Gui:WaitForChild("BackButton")
local NextButton = Gui:WaitForChild("NextButton")
local PlayerNameLabel = Gui:WaitForChild("PlayerNameLabel")

local CurrentIndex = 0
local Prompt
local SpectateList = {}

local function SpectatePlayer(Player)

	local Character = Player.Character or Player.CharacterAdded:Wait()
	local Humanoid = Character:WaitForChild("Humanoid")

	Camera.CameraSubject = Humanoid
	PlayerNameLabel.Text = Player.Name

end

local function UpdateSpectateList()

	SpectateList = {}

	for _, Player in ipairs(Players:GetPlayers()) do

		if Player ~= LocalPlayer then

			table.insert(SpectateList, Player)

		end

	end

end

SpectateEvent.OnClientEvent:Connect(function(SpectatePrompt)

	UpdateSpectateList()

	Prompt = SpectatePrompt
	LocalHumanoid.WalkSpeed = 0
	LocalHumanoid.JumpHeight = 0
	SpectatePrompt.Enabled = false
	Gui.Enabled = true

	-- [추가] 관전 시작할 때 HUD 숨기기
	if MainHUD then MainHUD.Enabled = false end

	if #SpectateList > 0 then
		CurrentIndex = 1
		SpectatePlayer(SpectateList[CurrentIndex])
	else
		PlayerNameLabel.Text = "No one"

	end

end)

ExitButton.MouseButton1Click:Connect(function()

	Gui.Enabled = false

	PlayerNameLabel.Text = ""

	Camera.CameraSubject = LocalHumanoid

	LocalHumanoid.WalkSpeed = OriginalWalkSpeed
	LocalHumanoid.JumpHeight = OriginalJumpHeight

	if MainHUD then MainHUD.Enabled = true end

    if Prompt then
        Prompt.Enabled = true
        Prompt = nil

	end

end)

BackButton.MouseButton1Click:Connect(function()

	if #SpectateList == 0 then

		return

	end

	CurrentIndex += 1

	if CurrentIndex > #SpectateList then

		CurrentIndex = 1

	end

	SpectatePlayer(SpectateList[CurrentIndex])

end)

NextButton.MouseButton1Click:Connect(function()

	if #SpectateList == 0 then

		return

	end

	CurrentIndex -= 1
	if CurrentIndex < 1 then
		CurrentIndex = #SpectateList
	end
	SpectatePlayer(SpectateList[CurrentIndex])
end)
