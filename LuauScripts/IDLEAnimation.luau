# IDLE 애니메이션 적용
# ServerScirpt


local NPC = script.Parent
local humanoid = NPC:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")
local idleAnimation = script:WaitForChild("Animation") -- 혹은 NPC.IdleAnim

local idleTrack = animator:LoadAnimation(idleAnimation)

-- 설정
idleTrack.Looped = true
idleTrack.Priority = Enum.AnimationPriority.Idle

-- 재생
idleTrack:Play()

--  속도 감속 (튜닝)
idleTrack:AdjustSpeed(0.08)
