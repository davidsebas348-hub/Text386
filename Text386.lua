--------------------------------------------------
-- TOGGLE
--------------------------------------------------
if getgenv().ESP_GUNS then
	getgenv().ESP_GUNS = false

	-- 🔥 eliminar TODOS los ESP
	for _,v in pairs(workspace:GetDescendants()) do
		if v.Name == "ESP_BOX" then
			v:Destroy()
		end
	end

	return
end

getgenv().ESP_GUNS = true
--------------------------------------------------

repeat task.wait() until game:IsLoaded()

local itemsFolder = workspace:WaitForChild("Map")
	:WaitForChild("Util")
	:WaitForChild("Items")

-- 🔥 lista de armas
local guns = {
	["SodaGun"] = true,
	["AR"] = true,
	["GoldAR"] = true,
	["Pistol"] = true,
	["GoldMinigun"] = true,
	["M4A1"] = true,
	["Mac10"] = true,
	["ScrappySMG"] = true,
	["PumpShootgun"] = true,
	["ScrappyShootgun"] = true
}

--------------------------------------------------
-- FUNCIONES
--------------------------------------------------

local function removeESP(part)
	local esp = part:FindFirstChild("ESP_BOX")
	if esp then esp:Destroy() end
end

local function createESP(tool)

	if not getgenv().ESP_GUNS then return end
	if not guns[tool.Name] then return end

	local handle = tool:FindFirstChild("Handle")
	if not handle or not handle:IsA("BasePart") then return end

	if handle:FindFirstChild("ESP_BOX") then return end

	local box = Instance.new("BoxHandleAdornment")
	box.Name = "ESP_BOX"
	box.Adornee = handle
	box.AlwaysOnTop = true
	box.Size = handle.Size
	box.Color3 = Color3.fromRGB(0,0,0)
	box.Transparency = 0.6
	box.ZIndex = 10
	box.Parent = handle

	-- 🔥 auto update tamaño
	handle:GetPropertyChangedSignal("Size"):Connect(function()
		if box and box.Parent and getgenv().ESP_GUNS then
			box.Size = handle.Size
		end
	end)

end

local function update(tool)

	if not getgenv().ESP_GUNS then return end
	if not tool:IsA("Tool") then return end

	local handle = tool:FindFirstChild("Handle")
	if not handle then return end

	if tool.Parent == itemsFolder then
		createESP(tool)
	else
		removeESP(handle)
	end

end

--------------------------------------------------
-- EXISTENTES
--------------------------------------------------
for _, tool in pairs(itemsFolder:GetChildren()) do
	update(tool)

	tool.AncestryChanged:Connect(function()
		update(tool)
	end)
end

--------------------------------------------------
-- NUEVOS
--------------------------------------------------
itemsFolder.ChildAdded:Connect(function(tool)
	task.wait(0.2)
	update(tool)

	tool.AncestryChanged:Connect(function()
		update(tool)
	end)
end)
