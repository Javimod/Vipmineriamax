--// JAVI MOD v1.4 FIXED

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- VARIABLES
local xray = false
local showMinerals = true
local showGems = true
local autoExecute = false

local highlights = {}

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "JAVI_MOD_GUI"

-- BOTÓN NINJA
local open = Instance.new("ImageButton", gui)
open.Size = UDim2.new(0,45,0,45)
open.Position = UDim2.new(0,15,0.5,0)
open.Image = "rbxassetid://6031094678"
open.BackgroundColor3 = Color3.fromRGB(0,0,0)
Instance.new("UICorner", open).CornerRadius = UDim.new(1,0)
local stroke = Instance.new("UIStroke", open)
stroke.Color = Color3.fromRGB(0,255,150)

-- MENÚ
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,350,0,430)
main.Position = UDim2.new(0.5,-175,0.2,0)
main.BackgroundColor3 = Color3.fromRGB(10,10,10)
main.Visible = false
Instance.new("UICorner", main).CornerRadius = UDim.new(0,20)
local s = Instance.new("UIStroke", main)
s.Color = Color3.fromRGB(0,255,150)

open.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

-- DRAG
local dragging, dragStart, startPos
main.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = i.Position
		startPos = main.Position
	end
end)
main.InputEnded:Connect(function()
	dragging = false
end)
main.InputChanged:Connect(function(i)
	if dragging then
		local delta = i.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- TABS
local tabs = Instance.new("Frame", main)
tabs.Size = UDim2.new(1,0,0,40)
tabs.BackgroundTransparency = 1

local function createTab(name,pos)
	local b = Instance.new("TextButton", tabs)
	b.Size = UDim2.new(0,100,1,0)
	b.Position = UDim2.new(0,pos,0,0)
	b.Text = name
	b.BackgroundColor3 = Color3.fromRGB(20,20,20)
	b.TextColor3 = Color3.fromRGB(0,255,150)
	Instance.new("UICorner", b)
	return b
end

local visualsBtn = createTab("Visuals",0)
local miscBtn = createTab("Misc",110)
local statusBtn = createTab("Status",220)

-- SCROLL
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1,-10,1,-60)
scroll.Position = UDim2.new(0,5,0,50)
scroll.CanvasSize = UDim2.new(0,0,0,600)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1

-- CREAR BOTÓN CORRECTO
local function createButton(text,y,callback)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-20,0,45)
	b.Position = UDim2.new(0,10,0,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(20,20,20)
	b.TextColor3 = Color3.fromRGB(0,255,150)
	b.TextScaled = true
	b.Parent = scroll
	Instance.new("UICorner", b)

	b.MouseButton1Click:Connect(function()
		callback(b) -- 🔥 AQUÍ ESTABA EL ERROR
	end)

	return b
end

-- XRAY
local function clear()
	for _,v in pairs(highlights) do
		if v then v:Destroy() end
	end
	highlights = {}
end

local function applyXray()
	clear()
	if not xray then return end
	
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") then
			local dist = (v.Position - root.Position).Magnitude
			if dist < 100 then
				local name = v.Name:lower()
				
				local isMineral = name:find("ore") or name:find("iron") or name:find("gold")
				local isGem = name:find("gem") or name:find("diamond")
				
				if (isMineral and showMinerals) or (isGem and showGems) then
					
					local hl = Instance.new("Highlight")
					hl.Parent = v
					hl.FillColor = isGem and Color3.fromRGB(0,255,150) or Color3.fromRGB(255,140,0)
					table.insert(highlights, hl)

					local bill = Instance.new("BillboardGui")
					bill.Parent = v
					bill.Size = UDim2.new(0,100,0,30)
					bill.StudsOffset = Vector3.new(0,3,0)

					local txt = Instance.new("TextLabel", bill)
					txt.Size = UDim2.new(1,0,1,0)
					txt.Text = v.Name
					txt.TextScaled = true
					txt.BackgroundTransparency = 1
					txt.TextColor3 = Color3.fromRGB(255,255,255)

					table.insert(highlights, bill)
				end
			end
		end
	end
end

-- LOOP XRAY (IMPORTANTE)
RunService.Heartbeat:Connect(function()
	if xray then
		applyXray()
	end
end)

-- VISUALS
local function loadVisuals()
	scroll:ClearAllChildren()

	createButton("👁 Rayo X ❌",0,function(btn)
		xray = not xray
		btn.Text = xray and "👁 Rayo X ✅" or "👁 Rayo X ❌"
	end)

	createButton("⛏ Solo Minerales ✅",55,function(btn)
		showMinerals = not showMinerals
		btn.Text = showMinerals and "⛏ Solo Minerales ✅" or "⛏ Solo Minerales ❌"
	end)

	createButton("💎 Solo Gemas ❌",110,function(btn)
		showGems = not showGems
		btn.Text = showGems and "💎 Solo Gemas ✅" or "💎 Solo Gemas ❌"
	end)
end

-- MISC
local function tp(pos)
	root.CFrame = CFrame.new(pos)
end

local function loadMisc()
	scroll:ClearAllChildren()

	createButton("🛒 Tienda Picos",0,function() tp(Vector3.new(-1573,11,-4)) end)
	createButton("⛏ Mina",55,function() tp(Vector3.new(-1891,7,-198)) end)
	createButton("🔁 Rebirth Shop",110,function() tp(Vector3.new(-1468,10,191)) end)
	createButton("📍 Mina Guardada",165,function() tp(Vector3.new(-551,-73,654)) end)
	createButton("💣 Tienda TNT",220,function() tp(Vector3.new(398,79,-743)) end)

	createButton("⚙ Auto Execute ❌",280,function(btn)
		autoExecute = not autoExecute
		btn.Text = autoExecute and "⚙ Auto Execute ✅" or "⚙ Auto Execute ❌"
	end)

	createButton("🌐 Server Hop",335,function()
		local servers = HttpService:JSONDecode(game:HttpGet(
			"https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"
		))
		for _,s in pairs(servers.data) do
			if s.playing < s.maxPlayers then
				TeleportService:TeleportToPlaceInstance(game.PlaceId,s.id,player)
				break
			end
		end
	end)
end

-- STATUS
local function loadStatus()
	scroll:ClearAllChildren()

	local label = Instance.new("TextLabel", scroll)
	label.Size = UDim2.new(1,-20,0,200)
	label.Position = UDim2.new(0,10,0,0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(0,255,150)
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top

	RunService.RenderStepped:Connect(function()
		label.Text =
		"📊 STATUS\n\nFPS: "..math.floor(1/RunService.RenderStepped:Wait())..
		"\nJugadores: "..#Players:GetPlayers()..
		"\nPing: "..math.floor(player:GetNetworkPing()*1000).." ms"..
		"\nUsuarios: 1\n\nVersión: 1.4"
	end)
end

visualsBtn.MouseButton1Click:Connect(loadVisuals)
miscBtn.MouseButton1Click:Connect(loadMisc)
statusBtn.MouseButton1Click:Connect(loadStatus)

loadVisuals()

print("✅ JAVI MOD v1.4 FIXED")
