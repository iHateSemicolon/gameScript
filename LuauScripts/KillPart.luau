# humanoid가 파트에 닿았을때 체력을 0으로 만드는 스크립트 (즉사)
# localScript

function onTouched(hit)
  local human = hit.Parent:FindFirstChild("Humanoid")
  if (human ~= nil) then
    human . Health = 0
    end
end
script.Parent.Touched:connect(onTouched)
