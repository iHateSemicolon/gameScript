# 기본 모듈 (서비스)
# ModuleScript


local module = {}

module.Players = game:GetService("Players")
module.RS = game:GetService("RunService")
module.TS = game:GetService("TweenService")
module.UIS = game:GetService("UserInputService")
module.SSS = game:GetService("ServerScriptService")
module.SS = game:GetService("ServerStorage")
module.RS = game:GetService("ReplicatedStorage")
module.Lighting = game:GetService("Lighting")
module.Debris = game:GetService("Debris")
module.Market = game:GetService("MarketplaceService")
module.Http = game:GetService("HttpService")
module.PS = game:GetService("ProximityPromptService")

-- 로컬 전용
module.LP = module.Players.LocalPlayer
module.Mouse = module.LocalPlayer and module.LocalPlayer:GetMouse()


return module
