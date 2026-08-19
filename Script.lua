-- [[ SERVIÇOS DO ROBLOX ]]
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ VARIÁVEIS DE CONFIGURAÇÃO ]]
local AimbotEnabled = true
local TargetPart = "Head" -- "Head", "UpperTorso" (Pescoço/Peito), "HumanoidRootPart" (Corpo)
local FOVRadius = 120

-- [[ DESENHO DO CÍRCULO FOV ]]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Radius = FOVRadius
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(255, 0, 127) -- Rosa Pink
FOVCircle.Thickness = 1.5
FOVCircle.Transparency = 1
FOVCircle.Visible = true

-- [[ DESTRUIR PAINEL ANTERIOR ]]
if game:GetService("CoreGui"):FindFirstChild("PinkMenu_LK7") then
    game:GetService("CoreGui")["PinkMenu_LK7"]:Destroy()
end

-- [[ INTERFACE PRINCIPAL (SCREEN GUI) ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PinkMenu_LK7"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- MAIN FRAME (CORPO DO PAINEL)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 260)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- [[ BOTÃO FLUTUANTE PARA ABRIR SE MINIMIZADO ]]
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
OpenBtn.Text = "🌸"
OpenBtn.TextSize = 20
OpenBtn.Visible = false
OpenBtn.ZIndex = 10
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenBtn

-- [[ BARRA DE TÍTULO / CONTROLES ]]
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 5
TopBar.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -28, 0, 4)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 25)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 0, 127)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 11
CloseBtn.ZIndex = 6
CloseBtn.Parent = TopBar
Instance.new("UICorner").CornerRadius = UDim.new(0, 6)

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 22, 0, 22)
MinimizeBtn.Position = UDim2.new(1, -54, 0, 4)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 25)
MinimizeBtn.Text = "─"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 10
MinimizeBtn.ZIndex = 6
MinimizeBtn.Parent = TopBar
Instance.new("UICorner").CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    FOVCircle:Remove()
    ScreenGui:Destroy()
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- [[ SIDEBAR (MENU LATERAL ESQUERDO) ]]
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 120, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(13, 13, 16)
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 12)
SideCorner.Parent = SideBar

local SideList = Instance.new("UIListLayout")
SideList.Padding = UDim.new(0, 4)
SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideList.SortOrder = Enum.SortOrder.LayoutOrder
SideList.Parent = SideBar

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0, 10)
SidePadding.Parent = SideBar

local abas = {
    {Nome = "Principal", Icone = "🏠", Ativa = true},
    {Nome = "Aimbot", Icone = "💀", Ativa = false},
    {Nome = "Gelo", Icone = "❄️", Ativa = false},
    {Nome = "Game", Icone = "🎮", Ativa = false},
    {Nome = "Clear", Icone = "⚙️", Ativa = false},
    {Nome = "Info", Icone = "ℹ️", Ativa = false}
}

for order, abaData in ipairs(abas) do
    local AbaBtn = Instance.new("TextButton")
    AbaBtn.Size = UDim2.new(0, 110, 0, 32)
    AbaBtn.LayoutOrder = order
    AbaBtn.BackgroundColor3 = abaData.Ativa and Color3.fromRGB(255, 0, 127) or Color3.fromRGB(18, 18, 22)
    AbaBtn.Text = "  " .. abaData.Icone .. "   " .. abaData.Nome
    AbaBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    AbaBtn.Font = Enum.Font.GothamBold
    AbaBtn.TextSize = 11
    AbaBtn.TextXAlignment = Enum.TextXAlignment.Left
    AbaBtn.Parent = SideBar
    Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
end

-- DIVISOR VERTICAL ROSA
local VerticalDivider = Instance.new("Frame")
VerticalDivider.Size = UDim2.new(0, 3, 0, 220)
VerticalDivider.Position = UDim2.new(0, 128, 0, 20)
VerticalDivider.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
VerticalDivider.BorderSizePixel = 0
VerticalDivider.Parent = MainFrame

-- [[ CONTEÚDO DA ABA PRINCIPAL ]]
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -145, 1, -20)
ContentFrame.Position = UDim2.new(0, 140, 0, 10)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 25)
TitleLabel.Position = UDim2.new(0, 10, 0, 10)
TitleLabel.Text = "DEFINA O HS:"
TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = ContentFrame

-- CONFIGURAÇÃO DOS OPÇÕES DE HS (RADIO BUTTONS)
local opcoesHS = {
    {Texto = "Cabeça", Part = "Head", Order = 1},
    {Texto = "Pescoço", Part = "UpperTorso", Order = 2},
    {Texto = "Corpo", Part = "HumanoidRootPart", Order = 3}
}

local RadioButtons = {}

for _, opt in ipairs(opcoesHS) do
    local OptionFrame = Instance.new("Frame")
    OptionFrame.Size = UDim2.new(1, 0, 0, 35)
    OptionFrame.Position = UDim2.new(0, 10, 0, 40 + ((opt.Order - 1) * 45))
    OptionFrame.BackgroundTransparency = 1
    OptionFrame.Parent = ContentFrame

    local CircleOuter = Instance.new("TextButton")
    CircleOuter.Size = UDim2.new(0, 24, 0, 24)
    CircleOuter.Position = UDim2.new(0, 0, 0.5, -12)
    CircleOuter.BackgroundColor3 = (TargetPart == opt.Part) and Color3.fromRGB(255, 0, 127) or Color3.fromRGB(25, 25, 30)
    CircleOuter.Text = ""
    CircleOuter.Parent = OptionFrame
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = CircleOuter

    local Label = Instance.new("TextButton")
    Label.Size = UDim2.new(1, -35, 1, 0)
    Label.Position = UDim2.new(0, 32, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = opt.Texto
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = OptionFrame

    RadioButtons[opt.Part] = CircleOuter

    local function SelecionarPonto()
        TargetPart = opt.Part
        for p, btn in pairs(RadioButtons) do
            btn.BackgroundColor3 = (p == TargetPart) and Color3.fromRGB(255, 0, 127) or Color3.fromRGB(25, 25, 30)
        end
    end

    CircleOuter.MouseButton1Click:Connect(SelecionarPonto)
    Label.MouseButton1Click:Connect(SelecionarPonto)
end

-- [[ SISTEMA DE ARRASTO DO PAINEL ]]
local Dragging = false
local DragStart, StartPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(
            StartPos.X.Scale, 
            StartPos.X.Offset + Delta.X, 
            StartPos.Y.Scale, 
            StartPos.Y.Offset + Delta.Y
        )
    end
end)

-- [[ LÓGICA DE AIMBOT MODERNA ]]
local function GetClosestTarget()
    local ClosestPart = nil
    local ShortestDistance = FOVRadius
    local CenterScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChildOfClass("Humanoid") then
            local Hum = v.Character:FindFirstChildOfClass("Humanoid")
            if Hum.Health > 0 then
                local TargetNode = v.Character:FindFirstChild(TargetPart) or v.Character:FindFirstChild("Head")
                if TargetNode then
                    local ScreenPos, OnScreen = Camera:WorldToViewportPoint(TargetNode.Position)
                    if OnScreen then
                        local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - CenterScreen).Magnitude
                        if Distance <= ShortestDistance then
                            ShortestDistance = Distance
                            ClosestPart = TargetNode
                        end
                    end
                end
            end
        end
    end
    return ClosestPart
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    if AimbotEnabled then
        local Target = GetClosestTarget()
        if Target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position)
        end
    end
end)
