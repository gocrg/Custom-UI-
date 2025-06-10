-- custom UI 
-- Mikuware UI System
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

-- Wait for player
local LocalPlayer = Players.LocalPlayer
repeat task.wait() until LocalPlayer:IsDescendantOf(Players)

-- Miku Color Scheme
local MIKU_TEAL = Color3.fromRGB(57, 197, 187)
local MIKU_LIGHT = Color3.fromRGB(180, 240, 255)
local MIKU_PINK = Color3.fromRGB(255, 119, 168)
local MIKU_DARK = Color3.fromRGB(0, 72, 83)
local MIKU_WHITE = Color3.fromRGB(255, 255, 255)

-- Create main GUI container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MikuwareUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

-- Background Blur Effect
local blur = Instance.new("BlurEffect")
blur.Name = "MikuwareBlur"
blur.Size = 0
blur.Enabled = false
blur.Parent = Lighting

-- ========== COMMAND BAR UI ==========
local cmdBar = Instance.new("Frame")
cmdBar.Name = "MikuCommandBar"
cmdBar.AnchorPoint = Vector2.new(0.5, 0.5)
cmdBar.BackgroundColor3 = MIKU_DARK
cmdBar.BackgroundTransparency = 0.2
cmdBar.BorderSizePixel = 0
cmdBar.Size = UDim2.new(0.4, 0, 0, 60)
cmdBar.Position = UDim2.new(0.5, 0, 0.1, 0)
cmdBar.Visible = false
cmdBar.Parent = screenGui

-- Miku gradient background
local cmdGradient = Instance.new("UIGradient")
cmdGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, MIKU_TEAL),
    ColorSequenceKeypoint.new(1, MIKU_LIGHT)
})
cmdGradient.Rotation = 90
cmdGradient.Parent = cmdBar

-- Pink accent bar
local cmdAccent = Instance.new("Frame")
cmdAccent.Name = "AccentBar"
cmdAccent.Size = UDim2.new(1, 0, 0, 4)
cmdAccent.Position = UDim2.new(0, 0, 1, -4)
cmdAccent.BackgroundColor3 = MIKU_PINK
cmdAccent.BorderSizePixel = 0
cmdAccent.Parent = cmdBar

-- White border
local cmdStroke = Instance.new("UIStroke")
cmdStroke.Color = MIKU_WHITE
cmdStroke.Thickness = 2
cmdStroke.Transparency = 0.3
cmdStroke.Parent = cmdBar

-- Command input box
local cmdInput = Instance.new("TextBox")
cmdInput.Name = "CommandInput"
cmdInput.Size = UDim2.new(0.95, 0, 0.8, 0)
cmdInput.Position = UDim2.new(0.025, 0, 0.1, 0)
cmdInput.BackgroundTransparency = 1
cmdInput.Text = ""
cmdInput.PlaceholderText = "Enter Mikuware command (help, notify, serverhop, rejoin...)"
cmdInput.ClearTextOnFocus = false
cmdInput.TextColor3 = MIKU_WHITE
cmdInput.Font = Enum.Font.GothamBold
cmdInput.TextSize = 18
cmdInput.TextXAlignment = Enum.TextXAlignment.Left
cmdInput.TextWrapped = true
cmdInput.Parent = cmdBar

-- Text glow effect
local inputStroke = Instance.new("UIStroke")
inputStroke.Color = MIKU_TEAL
inputStroke.Thickness = 1
inputStroke.Transparency = 0
inputStroke.Parent = cmdInput

-- Sparkle animation
local sparkle = Instance.new("UIGradient")
sparkle.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, MIKU_WHITE),
    ColorSequenceKeypoint.new(0.5, MIKU_LIGHT),
    ColorSequenceKeypoint.new(1, MIKU_WHITE),
})
sparkle.Rotation = 90
sparkle.Offset = Vector2.new(0, 0)
sparkle.Parent = cmdInput

local sparkleTween = TweenService:Create(sparkle, 
    TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), 
    {Offset = Vector2.new(1, 0)}
)
sparkleTween:Play()

-- ========== TOGGLE LOGIC ==========
local isConsoleOpen = false
local debounce = false

local function ToggleMikuConsole()
    if debounce then return end
    debounce = true
    
    isConsoleOpen = not isConsoleOpen
    cmdBar.Visible = isConsoleOpen
    
    if isConsoleOpen then
        -- Open animation
        blur.Size = 24
        blur.Enabled = true
        cmdBar.Position = UDim2.new(0.5, 0, 0, -60)
        local slideDown = TweenService:Create(cmdBar, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
            Position = UDim2.new(0.5, 0, 0.1, 0)
        })
        slideDown:Play()
        task.wait(0.3)
        cmdInput:CaptureFocus()
    else
        -- Close animation
        local slideUp = TweenService:Create(cmdBar, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
            Position = UDim2.new(0.5, 0, 0, -60)
        })
        slideUp.Completed:Connect(function()
            cmdBar.Visible = false
            blur.Enabled = false
        end)
        slideUp:Play()
    end
    
    task.wait(0.5)
    debounce = false
end

-- Keybind (M key)
local keyDebounce = false
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.M and not keyDebounce then
        keyDebounce = true
        ToggleMikuConsole()
        task.wait(0.2)
        keyDebounce = false
    end
end)

-- Command processing
cmdInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local text = string.lower(cmdInput.Text)
        local args = {}
        
        for arg in text:gmatch("%S+") do
            table.insert(args, arg)
        end
        
        if #args > 0 then
            local cmd = args[1]
            table.remove(args, 1)
            
            -- Process commands here
            -- Example: if cmd == "help" then
        end
        
        cmdInput.Text = ""
        if isConsoleOpen then
            cmdInput:CaptureFocus()
        end
    end
end)

-- Initialization message
print("Mikuware UI System Loaded - Press M to toggle console")