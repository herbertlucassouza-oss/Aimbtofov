-- [[ SERVIÇOS DO ROBLOX ]]
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ VARIÁVEIS DE CONFIGURAÇÃO ]]
local AimbotEnabled = false
local FOVVisible = true
local FOVRadius = 120

-- [[ CRIAÇÃO DO DESENHO DO FOV (DRAWING API) ]]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Radius = FOVRadius
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(180, 100, 255)
FOVCircle.Thickness = 1.5
FOVCircle.Transparency = 1
FOVCircle.Visible = FOVVisible

-- [[ REINICIAR INTERFACE ANTIGA SE EXISTIR ]]
if game:GetService("CoreGui"):FindFirstChild("LK7_AimbotHub") then
    game:GetService("CoreGui")["LK7_AimbotHub"]:Destroy()
end

-- [[ CRIAÇÃO DO HUB SIMPLES ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LK7_AimbotHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 190)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -95)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(120, 60, 200)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- BARRA DE TÍTULO (ÁREA PARA MOVER)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -35, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎯 LK7 - AIMBOT FOV"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -27, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 10
CloseBtn.Parent = TitleBar
Instance.new("UICorner").CornerRadius = UDim.new(0, 4)

CloseBtn.MouseButton1Click:Connect(function()
    FOVCircle:Remove()
    ScreenGui:Destroy()
end)

-- BOTÃO AIMBOT TOGGLE
local ToggleAimbotBtn = Instance.new("TextButton")
ToggleAimbotBtn.Size = UDim2.new(1, -20, 0, 32)
ToggleAimbotBtn.Position = UDim2.new(0, 10, 0, 42)
ToggleAimbotBtn.BackgroundColor3 = Color3.fromRGB(35, 25, 50)
ToggleAimbotBtn.Text = "Aimbot: OFF"
ToggleAimbotBtn.TextColor3 = Color3.fromRGB(200, 180, 220)
ToggleAimbotBtn.Font = Enum.Font.GothamSemibold
ToggleAimbotBtn.TextSize = 11
ToggleAimbotBtn.Parent = MainFrame
Instance.new("UICorner").CornerRadius = UDim.new(0, 5)

ToggleAimbotBtn.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    ToggleAimbotBtn.Text = AimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
    ToggleAimbotBtn.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(100, 45, 170) or Color3.fromRGB(35, 25, 50)
    ToggleAimbotBtn.TextColor3 = AimbotEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 180, 220)
end)

-- BOTÃO VISIBILIDADE FOV
local ToggleFOVBtn = Instance.new("TextButton")
ToggleFOVBtn.Size = UDim2.new(1, -20, 0, 32)
ToggleFOVBtn.Position = UDim2.new(0, 10, 0, 82)
ToggleFOVBtn.BackgroundColor3 = Color3.fromRGB(100, 45, 170)
ToggleFOVBtn.Text = "Mostrar FOV: ON"
ToggleFOVBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleFOVBtn.Font = Enum.Font.GothamSemibold
ToggleFOVBtn.TextSize = 11
ToggleFOVBtn.Parent = MainFrame
Instance.new("UICorner").CornerRadius = UDim.new(0, 5)

ToggleFOVBtn.MouseButton1Click:Connect(function()
    FOVVisible = not FOVVisible
    FOVCircle.Visible = FOVVisible
    ToggleFOVBtn.Text = FOVVisible and "Mostrar FOV: ON" or "Mostrar FOV: OFF"
    ToggleFOVBtn.BackgroundColor3 = FOVVisible and Color3.fromRGB(100, 45, 170) or Color3.fromRGB(35, 25, 50)
    ToggleFOVBtn.TextColor3 = FOVVisible and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 180, 220)
end)

-- CONTROLE DE TAMANHO DO FOV
local FOVControlFrame = Instance.new("Frame")
FOVControlFrame.Size = UDim2.new(1, -20, 0, 32)
FOVControlFrame.Position = UDim2.new(0, 10, 0, 122)
FOVControlFrame.BackgroundTransparency = 1
FOVControlFrame.Parent = MainFrame

local FOVMinus = Instance.new("TextButton")
FOVMinus.Size = UDim2.new(0, 32, 1, 0)
FOVMinus.Position = UDim2.new(0, 0, 0, 0)
FOVMinus.BackgroundColor3 = Color3.fromRGB(35, 25, 50)
FOVMinus.Text = "-"
FOVMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVMinus.Font = Enum.Font.GothamBold
FOVMinus.TextSize = 14
FOVMinus.Parent = FOVControlFrame
Instance.new("UICorner").CornerRadius = UDim.new(0, 5)

local FOVText = Instance.new("TextLabel")
FOVText.Size = UDim2.new(1, -74, 1, 0)
FOVText.Position = UDim2.new(0, 37, 0, 0)
FOVText.BackgroundColor3 = Color3.fromRGB(25, 18, 38)
FOVText.Text = "Tamanho FOV: " .. tostring(FOVRadius)
FOVText.TextColor3 = Color3.fromRGB(220, 220, 220)
FOVText.Font = Enum.Font.Gotham
FOVText.TextSize = 10
FOVText.Parent = FOVControlFrame
Instance.new("UICorner").CornerRadius = UDim.new(0, 5)

local FOVPlus = Instance.new("TextButton")
FOVPlus.Size = UDim2.new(0, 32, 1, 0)
FOVPlus.Position = UDim2.new(1, -32, 0, 0)
FOVPlus.BackgroundColor3 = Color3.fromRGB(35, 25, 50)
FOVPlus.Text = "+"
FOVPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVPlus.Font = Enum.Font.GothamBold
FOVPlus.TextSize = 14
FOVPlus.Parent = FOVControlFrame
Instance.new("UICorner").CornerRadius = UDim.new(0, 5)

FOVMinus.MouseButton1Click:Connect(function()
    if FOVRadius > 20 then
        FOVRadius = FOVRadius - 10
        FOVCircle.Radius = FOVRadius
        FOVText.Text = "Tamanho FOV: " .. tostring(FOVRadius)
    end
end)

FOVPlus.MouseButton1Click:Connect(function()
    if FOVRadius < 500 then
        FOVRadius = FOVRadius + 10
        FOVCircle.Radius = FOVRadius
        FOVText.Text = "Tamanho FOV: " .. tostring(FOVRadius)
    end
end)

-- [[ SISTEMA DE ARRASTO DO HUB ]]
local Dragging = false
local DragStart, StartPos

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local MousePos = UserInputService:GetMouseLocation()
        local FramePos = TitleBar.AbsolutePosition
        local FrameSize = TitleBar.AbsoluteSize
        
        if MousePos.X >= FramePos.X and MousePos.X <= (FramePos.X + FrameSize.X) and
           MousePos.Y >= (FramePos.Y + 36) and MousePos.Y <= (FramePos.Y + FrameSize.Y + 36) then
            
            if MousePos.X > (FramePos.X + FrameSize.X - 35) then return end
            
            Dragging = true
            DragStart = input.Position
            StartPos = MainFrame.Position
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local Delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(
            StartPos.X.Scale, 
            StartPos.X.Offset + Delta.X, 
            StartPos.Y.Scale, 
            StartPos.Y.Offset + Delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = false
    end
end)

-- [[ LÓGICA DO AIMBOT (BUSCA JOGADOR DENTRO DO FOV NA FRENTE DA MIRA) ]]
local function GetClosestTargetInFOV()
    local ClosestPlayer = nil
    local ShortestDistance = FOVRadius
    local CenterScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChildOfClass("Humanoid") then
            local Hum = v.Character:FindFirstChildOfClass("Humanoid")
            if Hum.Health > 0 then
                local Head = v.Character.Head
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(Head.Position)
                
                if OnScreen then
                    local MouseDistance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - CenterScreen).Magnitude
                    if MouseDistance <= ShortestDistance then
                        ShortestDistance = MouseDistance
                        ClosestPlayer = Head
                    end
                end
            end
        end
    end
    return ClosestPlayer
end

-- [[ LOOP PRINCIPAL DE ATUALIZAÇÃO ]]
RunService.RenderStepped:Connect(function()
    -- Atualizar Posição do Círculo do FOV no Centro
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    -- Grudar Mira na Cabeça se o Aimbot estiver Ativo
    if AimbotEnabled then
        local TargetHead = GetClosestTargetInFOV()
        if TargetHead then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, TargetHead.Position)
        end
    end
end)
