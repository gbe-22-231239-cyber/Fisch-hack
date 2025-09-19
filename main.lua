-- UI 생성
local gui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "FischHub"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 150)
frame.Position = UDim2.new(0.8, 0, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local function createLabel(name, y)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -10, 0, 30)
    label.Position = UDim2.new(0, 5, 0, y)
    label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    label.BorderSizePixel = 0
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.Text = name .. ": OFF"

    local labelCorner = Instance.new("UICorner", label)
    labelCorner.CornerRadius = UDim.new(0, 8)

    return label
end

local flyLabel = createLabel("Fly", 0)
local noclipLabel = createLabel("NoClip", 30)
local antikickLabel = createLabel("AntiKick", 60)
local autofishLabel = createLabel("AutoFish", 90)

-- 기능 상태 변수
local flyEnabled, noclipEnabled, antikickEnabled, autofishEnabled = false, false, false, false
local uiVisible = true

-- Anti-AFK
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- 키 입력 처리
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end

    -- Ctrl 키로 UI 숨기기/보이기
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        uiVisible = not uiVisible
        gui.Enabled = uiVisible
    end

    -- Fly 토글
    if input.KeyCode == Enum.KeyCode.Z then
        flyEnabled = not flyEnabled
        flyLabel.Text = "Fly: " .. (flyEnabled and "ON" or "OFF")
        flyLabel.TextColor3 = flyEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
        -- Fly 기능 삽입 가능
    end

    -- NoClip 토글
    if input.KeyCode == Enum.KeyCode.X then
        noclipEnabled = not noclipEnabled
        noclipLabel.Text = "NoClip: " .. (noclipEnabled and "ON" or "OFF")
        noclipLabel.TextColor3 = noclipEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
        -- NoClip 기능 삽입 가능
    end

    -- Anti-Kick 실행
    if input.KeyCode == Enum.KeyCode.C then
        antikickEnabled = not antikickEnabled
        antikickLabel.Text = "AntiKick: " .. (antikickEnabled and "ON" or "OFF")
        antikickLabel.TextColor3 = antikickEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
        if antikickEnabled then
            local mt = getrawmetatable(game)
            setreadonly(mt, false)
            local old = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                if getnamecallmethod() == "Kick" then return nil end
                return old(self, ...)
            end)
        end
    end

    -- AutoFish 실행
    if input.KeyCode == Enum.KeyCode.F then
        autofishEnabled = not autofishEnabled
        autofishLabel.Text = "AutoFish: " .. (autofishEnabled and "ON" or "OFF")
        autofishLabel.TextColor3 = autofishEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
        if autofishEnabled then
            spawn(function()
                while autofishEnabled do
                    local castDelay = math.random(3, 7)
                    wait(castDelay)
                    -- 캐스팅 함수 삽입 (예: 찌 던지기)

                    local catchDelay = math.random(2, 5)
                    wait(catchDelay)
                    -- 포획 함수 삽입 (예: 물고기 잡기)
                end
            end)
        end
    end
end)
