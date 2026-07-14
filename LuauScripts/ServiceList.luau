# 서비스
# ServerScript


local services = {}

for _, service in ipairs(game:GetChildren()) do
 local success, result = pcall(function()
  table.insert(services, service.Name)
 end)
end

table.sort(services)

for _, service in ipairs(services) do
 print(service)
end
