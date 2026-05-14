-- Project: Be A Food Speed Hack (Final Stable Version)
-- Опис: Тонкі рамки, зелений інсет-чекбокс, плавна анімація "K" та анти-телепорт.

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

local Vars = {
    SpeedEnabled = false,
    SpeedValue = 16,
    GuiOpen = true,
    OriginalSize = UDim2.new(0, 380, 0, 240),
    CollapsedSize = UDim2.new(0, 380, 0, 70)
}

-- Видалення старих копій
if pGui:FindFirstChild("BeAFood_Final_Build") then pGui.BeAFood_Final_Build:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "BeAFood_Final_Build"
sg.ResetOnSpawn = false
sg.Parent = pGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = Vars.OriginalSize
main.Position = UDim2.new(0, 50, 0.5, -120)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Active = true
main.Parent = sg
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

-- Header (Чорна панель для перетягування)
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 70)
header.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
header.BorderSizePixel = 0
header.ZIndex = 2
header.Parent = main
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "BE A FOOD"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.Bangers
title.TextScaled = true
title.ZIndex = 3
title.Parent = header

-- Content Container
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -40, 0, 120)
content.Position = UDim2.new(0, 20, 0, 85)
content.BackgroundTransparency = 1
content.Parent = main

-- Checkbox Row
local checkRow = Instance.new("Frame")
checkRow.Size = UDim2.new(1, 0, 0, 40)
checkRow.BackgroundTransparency = 1
checkRow.Parent = content

local boxBase = Instance.new("Frame")
boxBase.Size = UDim2.new(0, 32, 0, 32)
boxBase.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
boxBase.BorderSizePixel = 0
boxBase.Parent = checkRow
Instance.new("UICorner", boxBase).CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.new(1, 1, 1)
stroke.Thickness = 1
stroke.Parent = boxBase

local greenSquare = Instance.new("Frame")
greenSquare.Size = UDim2.new(0, 0, 0, 0)
greenSquare.Position = UDim2.new(0.5, 0, 0.5, 0)
greenSquare.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
greenSquare.BorderSizePixel = 0
greenSquare.Parent = boxBase
Instance.new("UICorner", greenSquare).CornerRadius = UDim.new(0, 5)

local clickBtn = Instance.new("TextButton")
clickBtn.Size = UDim2.new(1, 0, 1, 0)
clickBtn.BackgroundTransparency = 1
clickBtn.Text = ""
clickBtn.Parent = boxBase

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -50, 1, 0)
label.Position = UDim2.new(0, 45, 0, 0)
label.BackgroundTransparency = 1
label.Text = "SPEED HACK"
label.TextColor3 = Color3.new(1, 1, 1)
label.Font = Enum.Font.Bangers
label.TextScaled = true
label.TextXAlignment = Enum.TextXAlignment.Left
label.Parent = checkRow

-- Slider
local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(1, 0, 0, 4)
sliderFrame.Position = UDim2.new(0, 0, 0, 65)
sliderFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
sliderFrame.Parent = content

local knob = Instance.new("TextButton")
knob.Size = UDim2.new(0, 22, 0, 22)
knob.Position = UDim2.new(0, 0, 0.5, -11)
knob.BackgroundColor3 = Color3.new(1, 1, 1)
knob.Text = ""
knob.Parent = sliderFrame
Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

-- Logic UI
clickBtn.MouseButton1Click:Connect(function()
    Vars.SpeedEnabled = not Vars.SpeedEnabled
    TweenService:Create(greenSquare, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
        Size = Vars.SpeedEnabled and UDim2.new(0, 22, 0, 22) or UDim2.new(0, 0, 0, 0),
        Position = Vars.SpeedEnabled and UDim2.new(0.5, -11, 0.5, -11) or UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
end)

knob.MouseButton1Down:Connect(function()
    local connection; connection = UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
            knob.Position = UDim2.new(pos, -11, 0.5, -11)
            Vars.SpeedValue = 16 + (pos * 134)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then connection:Disconnect() end
    end)
end)

-- Drag System Fix
local dragging, dragInput, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = input.Position startPos = main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
header.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Physics Logic (Anti-Teleport)
RunService.Heartbeat:Connect(function()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if hrp and hum then
        if Vars.SpeedEnabled and hum.MoveDirection.Magnitude > 0 then
            if not hrp:FindFirstChild("SimpleSpeedBV") then
                local bv = Instance.new("BodyVelocity")
                bv.Name = "SimpleSpeedBV"
                bv.MaxForce = Vector3.new(100000, 0, 100000)
                bv.Parent = hrp
            end
            hrp.SimpleSpeedBV.Velocity = hum.MoveDirection * Vars.SpeedValue
        else
            if hrp:FindFirstChild("SimpleSpeedBV") then hrp.SimpleSpeedBV:Destroy() end
        end
    end
end)

-- Footer
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 40)
footer.Position = UDim2.new(0, 0, 1, -40)
footer.BackgroundTransparency = 1
footer.Text = "BY:SIMPLECHEATS"
footer.TextColor3 = Color3.new(1, 1, 1)
footer.Font = Enum.Font.Bangers
footer.TextScaled = true
footer.Parent = main

-- Smooth K Animation
UserInputService.InputBegan:Connect(function(k, g)
    if not g and k.KeyCode == Enum.KeyCode.K then
        Vars.GuiOpen = not Vars.GuiOpen
        local targetSize = Vars.GuiOpen and Vars.OriginalSize or Vars.CollapsedSize
        TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    end
end)
