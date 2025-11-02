local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayerMouse = game:GetService("Players").LocalPlayer:GetMouse()

local isLibraryEnabled = false
local currentAlpha = 0
local maxAlpha = 1
local minAlpha = 0
local toggleState = false

-- Удаление существующего экземпляра библиотеки, если он есть
if game:GetService("CoreGui"):FindFirstChild("WizardLibrary") then
    game:GetService("CoreGui"):FindFirstChild("WizardLibrary"):Destroy()
end

-- Создание основных элементов интерфейса
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WizardLibrary"
ScreenGui.Parent = gethui() or game:GetService("CoreGui")

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Parent = ScreenGui
Container.BackgroundColor3 = Color3.new(1, 1, 1)
Container.BackgroundTransparency = 1
Container.Size = UDim2.new(0, 100, 0, 100)

-- Обработка нажатия клавиши для включения/выключения библиотеки
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightControl then
        isLibraryEnabled = not isLibraryEnabled
        -- Здесь можно добавить логику для показа/скрытия интерфейса
    end
end)

-- Функция для реализации перетаскивания элементов
local function Dragging(element)
    local dragging = false
    local dragInput = nil
    local connection = nil

    local function updatePosition(input)
        local delta = input.Position - dragInput.Position
        element.Position = UDim2.new(
            element.Position.X.Scale,
            element.Position.X.Offset + delta.X,
            element.Position.Y.Scale,
            element.Position.Y.Offset + delta.Y
        )
    end

    element.InputBegan:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragInput = input
            connection = input.Changed:Connect(updatePosition)
        end
    end)

    element.InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end)
end

-- Функция для удаления пробелов из строки
local function removeSpaces(str)
    return str:gsub(" ", "")
end

-- Корутина для циклического изменения альфа-канала
coroutine.wrap(function()
    while wait() do
        currentAlpha = currentAlpha + 0.00392156862745098
        if currentAlpha >= maxAlpha then
            currentAlpha = minAlpha
        end
        -- Здесь можно добавить код для применения альфа-канала к элементам
    end
end)()

-- Таблица для хранения методов работы с окнами
local Library = {}

function Library.NewWindow(windowId, windowTitle)
    local window = Instance.new("ImageLabel")
    local topbar = Instance.new("Frame")
    local toggleButton = Instance.new("TextButton")
    local titleLabel = Instance.new("TextLabel")
    local body = Instance.new("ImageLabel")
    local layout = Instance.new("UIListLayout")

    window.Name = windowTitle .. "Window"
    window.Parent = ScreenGui
    window.BackgroundColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392)
    window.BackgroundTransparency = 1
    window.Position = UDim2.new(0, -100, 3, -265)
    window.Size = UDim2.new(0, 170, 0, 30)
    window.ZIndex = 2
    window.Image = "rbxassetid://3570695787"
    window.ImageColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392)
    window.ScaleType = Enum.ScaleType.Slice
    window.SliceCenter = Rect.new(100, 100, 100, 100)
    window.SliceScale = 0.05

    topbar.Name = "Topbar"
    topbar.Parent = window
    topbar.BackgroundColor3 = Color3.new(1, 1, 1)
    topbar.BackgroundTransparency = 1
    topbar.BorderSizePixel = 0
    topbar.Size = UDim2.new(0, 170, 0, 30)
    topbar.ZIndex = 2

    toggleButton.Name = "WindowToggle"
    toggleButton.Parent = topbar
    toggleButton.BackgroundColor3 = Color3.new(1, 1, 1)
    toggleButton.BackgroundTransparency = 1
    toggleButton.Position = UDim2.new(0.822450161, 0, 0, 0)
    toggleButton.Size = UDim2.new(0, 30, 0, 30)
    toggleButton.ZIndex = 2
    toggleButton.Font = Enum.Font.SourceSansSemibold
    toggleButton.Text = "-"
    toggleButton.TextColor3 = Color3.new(1, 1, 1)
    toggleButton.TextSize = 20
    toggleButton.TextWrapped = true

    titleLabel.Name = "WindowTitle"
    titleLabel.Parent = topbar
    titleLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(0, 170, 0, 30)
    titleLabel.ZIndex = 2
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Text = windowTitle
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextSize = 17

    body.Name = "Body"
    body.Parent = window
    body.BackgroundColor3 = Color3.new(0.137255, 0.137255, 0.137255)
    body.BackgroundTransparency = 1
    body.ClipsDescendants = true
    body.Size = UDim2.new(0, 170, 0, 35)
    body.Image = "rbxassetid://3570695787"
    body.ImageColor3 = Color3.new(0.137255, 0.137255, 0.137255)
    body.ScaleType = Enum.ScaleType.Slice
    body.SliceCenter = Rect.new(100, 100, 100, 100)
    body.SliceScale = 0.05

    layout.Name = "Sorter"
    layout.Parent = body
    layout.SortOrder = Enum.SortOrder.LayoutOrder


    Dragging(window)

    local Section = {}

    function Section.NewSection(sectionId, sectionTitle)
        local section = Instance.new("Frame")
        local info = Instance.new("Frame")
        local toggle = Instance.new("TextButton")
        local label = Instance.new("TextLabel")
        local listLayout = Instance.new("UIListLayout")

        section.Name = sectionTitle .. "Section"
        section.Parent = body
        section.BackgroundColor3 = Color3.new(0.176471, 0.176471, 0.176471)
        section.BorderSizePixel = 0
        section.ClipsDescendants = true
        section.Size = UDim2.new(0, 170, 0, 30)

        info.Name = "SectionInfo"
        info.Parent = section
                info.BackgroundColor3 = Color3.new(1, 1, 1)
        info.BackgroundTransparency = 1
        info.Size = UDim2.new(0, 170, 0, 30)

        toggle.Name = "SectionToggle"
        toggle.Parent = info
        toggle.BackgroundColor3 = Color3.new(1, 1, 1)
        toggle.BackgroundTransparency = 1
        toggle.Position = UDim2.new(0.822450161, 0, 0, 0)
        toggle.Size = UDim2.new(0, 30, 0, 30)
        toggle.ZIndex = 2
        toggle.Font = Enum.Font.SourceSansSemibold
        toggle.Text = "v"
        toggle.TextColor3 = Color3.new(1, 1, 1)
        toggle.TextSize = 14
        toggle.TextWrapped = true

        label.Name = "SectionTitle"
        label.Parent = info
        label.BackgroundColor3 = Color3.new(1, 1, 1)
        label.BackgroundTransparency = 1
        label.BorderSizePixel = 0
        label.Position = UDim2.new(0.052941177, 0, 0, 0)
        label.Size = UDim2.new(0, 125, 0, 30)
        label.Font = Enum.Font.SourceSansBold
        label.Text = sectionTitle
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextSize = 17
        label.TextXAlignment = Enum.TextXAlignment.Left

        listLayout.Name = "Layout"
        listLayout.Parent = section
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local isExpanded = false

        local function expandSection(height)
            TweenService:Create(
                section,
                TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                { Size = UDim2.new(0, 170, 0, height) }
            ):Play()
        end

        local function collapseSection(height)
            TweenService:Create
                section,
                TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                { Size = UDim2.new(0, 17 gef, 0, height) }
            ):Play()
        end

        toggle.MouseButton1Down:Connect(function()
            isExpanded = not isExpanded
            if isExpanded then
                expandSection(60)
                toggle.Text = "-"
                toggle.TextSize = 20
            else
                collapseSection(30)
                toggle.Text = "v"
                toggle.TextSize = 14
            end
        end)

        local Item = {}

        function Item.CreateToggle(toggleId, toggleTitle, defaultState, callback)
            local holder = Instance.new("Frame")
            local title = Instance.new("TextLabel")
            local background = Instance.new("ImageLabel")
            local button = Instance.new("ImageButton")

            holder.Name = toggleTitle .. "ToggleHolder"
            holder.Parent = section
            holder.BackgroundColor3 = Color3.new(0.137255, 0.137255, 0.137255)
            holder.BorderSizePixel = 0
            holder.Size = UDim2.new(0, 170, 0, 30)

            title.Name = "ToggleTitle"
            title.Parent = holder
            title.BackgroundColor3 = Color3.new(1, 1, 1)
            title.BackgroundTransparency = 1
            title.BorderSizePixel = 0
            title.Position = UDim2.new(0.052941177, 0, 0, 0)
            title.Size = UDim2.new(0, 125, 0, 30)
            title.Font = Enum.Font.SourceSansBold
            title.Text = toggleTitle
            title.TextColor3 = Color3.new(1, 1, 1)
            title.TextSize = 17
            title.TextXAlignment = Enum.TextXAlignment.Left


            background.Name = "ToggleBackground"
            background.Parent = holder
            background.BackgroundColor3 = Color3.new(1, 1, 1)
            background.BackgroundTransparency = 1
            background.BorderSizePixel = 0
            background.Position = UDim2.new(0.847058833, 0, 0.166666672, 0)
            background.Size = UDim2.new(0, 20, 0, 20)
            background.Image = "rbxassetid://3570695787"
            background.ImageColor3 = Color3.new(0.254902, 0.254902, 0.254902)

            button.Name = "ToggleButton"
            button.Parent = background
            button.BackgroundColor3 = Color3.new(1, 1, 1)
            button.BackgroundTransparency = 1
            button.Position = UDim2.new(0, 2, 0, 2)
            button.Size = UDim2.new(0, 16, 0, 16)
            button.Image = "rbxassetid://3570695787"
            button.ImageColor3 = Color3.new(1, 0.341176, 0.341176)
            button.ImageTransparency = defaultState and 0 or 1

            local isToggled = defaultState

            button.MouseButton1Down:Connect(function()
                isToggled = not isToggled
                TweenService:Create(
                    button,
                    TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                    { ImageTransparency = isToggled and 0 or 1 }
                ):Play()
                if callback then
                    callback(isToggled)
                end
            end)

            return {
                SetState = function(newState)
                    isToggled = newState
                    button.ImageTransparency = isToggled and 0 or 1
                end,
                GetState = function()
                    return isToggled
                end
            }
        end

        function Item.CreateSlider(sliderId, sliderTitle, minValue, maxValue, defaultValue, step, callback)
            local holder = Instance.new("Frame")
            local title = Instance.new("TextLabel")
            local track = Instance.new("ImageLabel")
            local fill = Instance.new("ImageLabel")
            local knob = Instance.new("ImageLabel")
            local valueLabel = Instance.new("TextLabel")

            holder.Name = sliderTitle .. "SliderHolder"
            holder.Parent = section
            holder.BackgroundColor3 = Color3.new(0.137255, 0.137255, 0.137255)
            holder.BorderSizePixel = 0
            holder.Size = UDim2.new(0, 170, 0, 40)

            title.Name = "SliderTitle"
            title.Parent = holder
            title.BackgroundColor3 = Color3.new(1, 1, 1)
            title.BackgroundTransparency = 1
            title.BorderSizePixel = 0
            title.Position = UDim2.new(0.052941177, 0, 0, 5)
            title.Size = UDim2.new(0, 125, 0, 20)
            title.Font = Enum.Font.SourceSansBold
            title.Text = sliderTitle
            title.TextColor3 = Color3.new(1, 1, 1)
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left

            track.Name = "Track"
            track.Parent = holder
            track.BackgroundColor3 = Color3.new(1, 1, 1)
                        track.BackgroundTransparency = 1
            track.Position = UDim2.new(0.05882353, 0, 0.6, 0)
            track.Size = UDim2.new(0, 140, 0, 4)
            track.Image = "rbxassetid://3570695787"
            track.ImageColor3 = Color3.new(0.254902, 0.254902, 0.254902)


            fill.Name = "Fill"
            fill.Parent = track
            fill.BackgroundColor3 = Color3.new(1, 1, 1)
            fill.BackgroundTransparency = 1
            fill.BorderSizePixel = 0
            fill.Size = UDim2.new(0, 0, 0, 4)
            fill.Image = "rbxassetid://3570695787"
            fill.ImageColor3 = Color3.new(1, 0.341176, 0.341176)


            knob.Name = "Knob"
            knob.Parent = track
            knob.BackgroundColor3 = Color3.new(1, 1, 1)
            knob.BackgroundTransparency = 1
            knob.Position = UDim2.new(0, -8, 0, -8)
            knob.Size = UDim2.new(0, 20, 0, 20)
            knob.Image = "rbxassetid://3570695787"
            knob.ImageColor3 = Color3.new(1, 0.341176, 0.341176)


            valueLabel.Name = "Value"
            valueLabel.Parent = holder
            valueLabel.BackgroundColor3 = Color3.new(1, 1, 1)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Position = UDim2.new(0.917647064, 0, 0.166666672, 0)
            valueLabel.Size = UDim2.new(0, 30, 0, 20)
            valueLabel.Font = Enum.Font.SourceSansBold
            valueLabel.Text = tostring(defaultValue)
            valueLabel.TextColor3 = Color3.new(1, 1, 1)
            valueLabel.TextSize = 14
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right

            local currentValue = defaultValue

            local function updateSlider(input)
                local relativePos = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
                local clampedPos = math.clamp(relativePos, 0, 1)
                local newValue = minValue + (maxValue - minValue) * clampedPos
                newValue = math.floor((newValue / step) + 0.5) * step

                currentValue = newValue


                fill.Size = UDim2.new(clampedPos, 0, 0, 4)
                knob.Position = UDim2.new(clampedPos - 0.07058824, 0, -0.4, 0)
                valueLabel.Text = tostring(currentValue)


                if callback then
                    callback(currentValue)
                end
            end

            local dragging = false
            local connection = nil

            knob.InputBegan:Connect(function(input, gameProcessed)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    connection = UserInputService.InputChanged:Connect(function(changedInput, gp)
                        if changedInput.UserInputType == Enum.UserInputType.MouseMovement then
                            updateSlider(changedInput)
                        end
                    end)
                end
            end)

            UserInputService.InputEnded:Connect(function(input, gameProcessed)
                if dragging and input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    if connection then
                        connection:Disconnect()
                        connection = nil
                    end
                end
            end)

            -- Инициализация положения слайдера
            local initialRelative = (defaultValue - minValue) / (maxValue - minValue)
            fill.Size = UDim2.new(initialRelative, 0, 0, 4)
            knob.Position = UDim2.new(initialRelative - 0.07058824, 0, -0.4, 0)


            return {
                SetValue = function(newValue)
                    currentValue = math.floor((newValue / step) + 0.5) * step
                    local relative = (currentValue - minValue) / (maxValue - minValue)
                    fill.Size = UDim2.new(relative, 0, 0, 4)
                    knob.Position = UDim2.new(relative - 0.07058824, 0, -0.4, 0)
                    valueLabel.Text = tostring(currentValue)
                    if callback then
                        callback(currentValue)
                    end
                end,
                GetValue = function()
                    return currentValue
                end
            }
        end

        return Item
    end

    return Section
end

return Library
