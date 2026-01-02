-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CONFIG
local LOAD_TIME = 120 -- ~2 minutes
local SLIDE_TIME = 0.6

-- Fake tasks for typewriter
local fakeTasks = {
	"Initializing modules...",
	"Verifying security...",
	"Loading GUI components...",
	"Scanning scripts...",
	"Syncing user data...",
	"Applying protocols...",
	"Fetching settings...",
	"Loading assets...",
	"Optimizing performance...",
	"Finalizing setup..."
}

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "SecurityLoadingGui"
gui.ResetOnSpawn = false
gui.Parent = playerGui
gui.Enabled = false

-- Banner frame
local banner = Instance.new("Frame")
banner.Size = UDim2.new(0.9, 0, 0.18, 0) -- 90% width, 18% height
banner.Position = UDim2.new(0.05, 0, -0.2, 0) -- start above screen
banner.BackgroundColor3 = Color3.fromRGB(230, 230, 230) -- light grey
banner.BorderSizePixel = 0
banner.Parent = gui

local bannerCorner = Instance.new("UICorner")
bannerCorner.CornerRadius = UDim.new(0, 12)
bannerCorner.Parent = banner

-- Main label
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -40, 0.4, 0)
label.Position = UDim2.new(0, 20, 0, 10)
label.BackgroundTransparency = 1
label.Text = "SECURITY LOADING"
label.TextColor3 = Color3.fromRGB(30, 30, 30)
label.Font = Enum.Font.GothamBold
label.TextScaled = true
label.Parent = banner

-- Loading bar background
local barBG = Instance.new("Frame")
barBG.Size = UDim2.new(1, -40, 0.15, 0)
barBG.Position = UDim2.new(0, 20, 0.55, 0)
barBG.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
barBG.BorderSizePixel = 0
barBG.Parent = banner

local barBGCorn = Instance.new("UICorner")
barBGCorn.CornerRadius = UDim.new(0, 10)
barBGCorn.Parent = barBG

-- Loading bar fill
local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
barFill.BorderSizePixel = 0
barFill.Parent = barBG

local barFillCorn = Instance.new("UICorner")
barFillCorn.CornerRadius = UDim.new(0, 10)
barFillCorn.Parent = barFill

-- Glow effect (UIStroke)
local glow = Instance.new("UIStroke")
glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
glow.Color = Color3.fromRGB(0, 180, 255)
glow.Thickness = 2
glow.Transparency = 0.5
glow.Parent = barFill

-- Loading task text (typewriter)
local taskLabel = Instance.new("TextLabel")
taskLabel.Size = UDim2.new(0.5, -20, 0.25, 0)
taskLabel.Position = UDim2.new(0, 20, 0.8, 0)
taskLabel.BackgroundTransparency = 1
taskLabel.TextColor3 = Color3.fromRGB(50, 50, 50)
taskLabel.Font = Enum.Font.Gotham
taskLabel.TextScaled = true
taskLabel.Text = ""
taskLabel.TextXAlignment = Enum.TextXAlignment.Left
taskLabel.Parent = banner

-- Banner tweens
local slideIn = TweenService:Create(
	banner,
	TweenInfo.new(SLIDE_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	{ Position = UDim2.new(0.05, 0, 0.05, 0) }
)

local slideOut = TweenService:Create(
	banner,
	TweenInfo.new(SLIDE_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
	{ Position = UDim2.new(0.05, 0, -0.2, 0) }
)

-- Typewriter effect
local function typeTaskText(textLabel, text)
	textLabel.Text = ""
	for i = 1, #text do
		textLabel.Text = string.sub(text, 1, i)
		task.wait(0.03)
	end
end

-- Smart loading bar with flicker + glow + typewriter tasks
local function smartLoadBar(bar, totalTime, taskLabel)
	local elapsed = 0
	local progress = 0

	while progress < 1 do
		local remaining = totalTime - elapsed
		if remaining <= 0 then break end

		-- Dynamic progress factor
		local speedFactor
		if progress < 0.3 then
			speedFactor = math.random(5, 15) / 100
		elseif progress < 0.7 then
			speedFactor = math.random(2, 10) / 100
		else
			speedFactor = math.random(10, 25) / 100
		end

		if progress + speedFactor > 1 then
			speedFactor = 1 - progress
		end

		-- Random stall
		local stallChance = math.random()
		local tweenTime
		if stallChance < 0.15 then
			tweenTime = math.random(5, 12) / 10
		else
			tweenTime = math.random(2, 6) / 10
		end

		if elapsed + tweenTime > totalTime then
			tweenTime = totalTime - elapsed
		end

		-- Pick a random task for typewriter
		local taskText = fakeTasks[math.random(1, #fakeTasks)]
		typeTaskText(taskLabel, taskText)

		-- Micro flicker for realism
		local flickCount = math.random(1,2)
		for i = 1, flickCount do
			glow.Transparency = 0.2
			task.wait(0.05)
			glow.Transparency = 0.5
		end

		-- Smooth bar tween
		local tween = TweenService:Create(
			bar,
			TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Size = UDim2.new(progress + speedFactor, 0, 1, 0) }
		)
		tween:Play()
		tween.Completed:Wait()

		progress += speedFactor
		elapsed += tweenTime
	end

	-- Complete bar
	bar.Size = UDim2.new(1, 0, 1, 0)
	taskLabel.Text = "Fully Protected. Enjoy!"
end

-- Main function
local function runSecurityLoading()
	gui.Enabled = true
	barFill.Size = UDim2.new(0, 0, 1, 0)
	label.Text = "SECURITY LOADING"
	taskLabel.Text = ""

	slideIn:Play()
	slideIn.Completed:Wait()

	smartLoadBar(barFill, LOAD_TIME, taskLabel)

	label.Text = "SECURITY LOADED"
	task.wait(1.5)

	slideOut:Play()
	slideOut.Completed:Wait()

	gui.Enabled = false
end

-- Run automatically
runSecurityLoading()
