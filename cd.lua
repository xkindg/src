-- =========================================================
-- xSOLITOxHUB_AUTOFIXED - Limpieza total de bucles y conexiones persistentes
-- =========================================================

-- Desconectar TODOS los bucles y eventos guardados en _G.conexiones
if _G.conexiones then
    for k, conn in pairs(_G.conexiones) do
        pcall(function()
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            elseif typeof(conn) == "function" and getfenv(conn) then
                -- No se puede cerrar funciones arbitrarias, ignorar
            end
        end)
    end
end
_G.conexiones = {}

-- Limpieza básica de GUIs y eventos
pcall(function()
    local CoreGui = game:GetService("CoreGui")
    local PlayerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    for _, name in ipairs({"xSOLITOxHUB", "FloatingButtonGui", "NotificationFrame"}) do
        local gui = CoreGui:FindFirstChild(name) or (PlayerGui and PlayerGui:FindFirstChild(name))
        if gui then gui:Destroy() end
    end
    if _G.EventConnections then
        for _, conn in ipairs(_G.EventConnections) do pcall(function() conn:Disconnect() end) end
    end
    _G.EventConnections = {}
end)


-- =========================================================
-- SISTEMA DE LIMPIEZA AL REEXECUTAR EL SCRIPT
-- =========================================================

-- Eliminar instancias previas
if game:GetService("CoreGui"):FindFirstChild("xSOLITOxHUB") then
    game:GetService("CoreGui").xSOLITOxHUB:Destroy()
end
if game:GetService("CoreGui"):FindFirstChild("FloatingButtonGui") then
    game:GetService("CoreGui").FloatingButtonGui:Destroy()
end
if game:GetService("CoreGui"):FindFirstChild("NotificationFrame") then
    game:GetService("CoreGui").NotificationFrame:Destroy()
end

-- =========================================================
-- =========================================================


-- =========================================================
-- ALGUNOS COLORES DEFAULT DE USO RAPIDO
-- =========================================================

-- Colores demasiados básicos:
_G.Primary = Color3.fromRGB(1, 94, 255) -- Azul (#015EFF)
_G.Secondary = Color3.fromRGB(255, 5, 70) -- Rosa (#FF0546)
_G.Third = Color3.fromRGB(1, 94, 255) -- Azul (#015EFF)

-- Colores para Temas:
_G.Themes = {
    Dark = {
        Main = Color3.fromRGB(6, 6, 6),
        Lighter = Color3.fromRGB(10, .10, 10),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(200, 200, 200)
    },
    Light = {
        Main = Color3.fromRGB(245, 245, 245),
        Lighter = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(10, 10, 10),
        SubText = Color3.fromRGB(80, 80, 80)
    }
}
_G.CurrentTheme = "Dark"

-- Asignación inicial (para mantener compatibilidad)
_G.Dark = _G.Themes.Dark.Main
_G.LighterDark = _G.Themes.Dark.Lighter

-- =========================================================
-- DEGRADADO POR DEFECTO DE MI SCRIPT (Usar cuando pida degradado)
-- =========================================================

_G.DefaultGradient = {
    Start = Color3.fromRGB(1, 94, 255),   -- Azul intenso
    End = Color3.fromRGB(255, 5, 70)      -- Rojo fuerte
}

function ApplyDefaultGradient(frame)
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, _G.DefaultGradient.Start),
		ColorSequenceKeypoint.new(1, _G.DefaultGradient.End)
	})
	gradient.Rotation = 0
	gradient.Parent = frame
end

-- =========================================================
-- =========================================================



-- =========================================================
-- WORKSPACE PARA CONEXIONES O PLANTILLAS
-- =========================================================

--                                        
--     Plantillas debajo

_G.conexiones = {} -- Necesario para la gestión de eventos del panel Avatar
local plantillas = { -- Datos para las plantillas de Avatar
    {nombre="Sin cabeza", ids={Cabeza=15093053680}},
    {nombre="Ojos azules", ids={Cabeza=16580493236}},
    {nombre="Buchon fuego azúl", ids={Torso=16580491126, BrazoDerecho=32336117, BrazoIzquierdo=32336182, PiernaDerecha=14752574049, PiernaIzquierda=14752574419}},
    {nombre="Buchon común", ids={Torso=37754511, BrazoIzquierdo=32336182, BrazoDerecho=32336117, PiernaDerecha=29413476, PiernaIzquierda=29413442}},
    {nombre="Pilchera", ids={Torso=18839824113, BrazoDerecho=76683091425509, BrazoIzquierdo=75159926897589}},
    {nombre="Buchona", ids={Cabeza=746774687, Torso=123961224944372, PiernaDerecha=77406416765105, PiernaIzquierda=96587569156234, BrazoIzquierdo=86499716, BrazoDerecho=86499698}},
    {nombre="Pilchero", ids={Torso=4637265517, BrazoIzquierdo=14525065362, BrazoDerecho=14525065380}},
    {nombre="Korblox derecha", ids={PiernaDerecha=139607718}},
    {nombre="Korblox izquierda", ids={PiernaIzquierda=139607673}},
    {nombre="inf15", ids={Torso=92757812011061, BrazoDerecho=99519402284266, BrazoIzquierdo=115905570886697, PiernaDerecha=84418052877367, PiernaIzquierda=124343282827669}},
    {nombre="Pierna rota", ids={PiernaDerecha=16973885715}},
    {nombre="Mini zombie", ids={Cabeza=79709288872230, Torso=118117565878603, BrazoDerecho=86428284013790, BrazoIzquierdo=137355073960897, PiernaDerecha=97859625635126, PiernaIzquierda=93536839203369}},
    {nombre="Músculo masivo", ids={Cabeza=133638849207345, Torso=11088606225236, BrazoDerecho=136389959521690, BrazoIzquierdo=76676593438086, PiernaDerecha=84897121642477, PiernaIzquierda=72351842882812}},
    {nombre="Mini peluche", ids={Torso=101678129797722, BrazoDerecho=114267907635155, BrazoIzquierdo=74948603903648, PiernaDerecha=100840538291335, PiernaIzquierda=101387518276175}},
    {nombre="Cariñoso", ids={BrazoIzquierdo=4416785861, BrazoDerecho=4416788553, Torso=32336059, PiernaDerecha=14752574049, PiernaIzquierda=14752574419}},
    {nombre="Araña", ids={Cabeza=17047514073, Torso=17047515921, BrazoDerecho=17047513973, BrazoIzquierdo=17047513964, PiernaDerecha=17047517586, PiernaIzquierda=17047514007}},
    {nombre="Sonic", ids={Torso=18253949731, BrazoDerecho=1825394958, BrazoIzquierdo=18253949477, PiernaDerecha=18253949443, PiernaIzquierda=18253949687}},
    {nombre="Freak sonriente", ids={Cabeza=71666458205606, Torso=134794806756884, BrazoDerecho=95438698170561, BrazoIzquierdo=81043872188250, PiernaDerecha=110533795025945, PiernaIzquierda=94252659031992}},
}



--               
--           Functions de conexion debajo

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
local defaultValues = {
    walkspeed = humanoid and humanoid.WalkSpeed or 16,
    jump = humanoid and (humanoid.JumpPower or humanoid.JumpHeight) or 50,
    gravity = Workspace.Gravity or 196.2,
    fallenPartsHeight = Workspace.FallenPartsDestroyHeight or -500
}


-- =========================================================
-- =========================================================



-- =========================================================
-- FUNCIONES DE UTILIDAD
-- =========================================================

-- Tabla para almacenar los bordes que se pueden activar/desactivar
_G.GlowStrokes = {}

function CreateRounded(Parent, Size)
    local Rounded = Instance.new("UICorner")
    Rounded.Name = "Rounded"
    Rounded.Parent = Parent
    Rounded.CornerRadius = UDim.new(0, Size)
end

function CreateGradient(Parent)
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, _G.Primary), -- Azul
        ColorSequenceKeypoint.new(1, _G.Secondary) -- Rosa
     })
    Gradient.Rotation = 45
    Gradient.Parent = Parent
    return Gradient
end


-- =========================================================
-- [[ CREACION DEL BORDE DEGRADADO PARA LAS CATEGORIAS ]]
-- =========================================================

function CreateGradientStroke(Parent)
    -- Nos aseguramos de que no haya otros bordes que causen conflictos
    for _, child in ipairs(Parent:GetChildren()) do
        if child:IsA("UIStroke") then
            child:Destroy()
        end
    end

    local Stroke = Instance.new("UIStroke")
    Stroke.Name = "GlowStroke"
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    -- [[ CAMBIO #1: Más Fino ]]
    -- Lo reducimos de 2.5 a 2 para un look más delicado.
    Stroke.Thickness = 2
    
    Stroke.LineJoinMode = Enum.LineJoinMode.Round
    Stroke.Color = Color3.fromRGB(1, 94, 255) 
	Stroke.Transparency = 0

    -- [[ CAMBIO #2: Desvanecido más Suave ]]
    -- Ajustamos los valores para que el resplandor se sienta menos 'junto' y más suave.
    local TransparencyGradient = Instance.new("UIGradient")
    TransparencyGradient.Transparency = NumberSequence.new({
        -- El núcleo sigue siendo bastante sólido para mantener el color.
        NumberSequenceKeypoint.new(0, 0.2), 
        
        -- El resplandor ahora se desvanece mucho más suavemente hacia el exterior.
        NumberSequenceKeypoint.new(0.5, 0.8),

        -- El borde exterior sigue siendo invisible.
        NumberSequenceKeypoint.new(1, 1)
    })

    TransparencyGradient.Rotation = 120
    TransparencyGradient.Parent = Stroke
    Stroke.Parent = Parent
    
    table.insert(_G.GlowStrokes, Stroke)
end

-- =========================================================
-- =========================================================


-- =========================================================
--         [[ UISTROKE PARA EL CONTENEDOR DE EDITOR ]]
-- =========================================================

-- Esta es tu función CreateGlowStroke, ahora con el efecto "fino y suave" que te gustó.
function CreateGlowStroke(Parent)
    -- Limpiamos cualquier borde anterior para no tener conflictos
    for _, child in ipairs(Parent:GetChildren()) do
        if child:IsA("UIStroke") then
            child:Destroy()
        end
    end

    local Stroke = Instance.new("UIStroke")
    Stroke.Name = "GlowStroke"
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    -- Grosor de 2 para un look delicado.
    Stroke.Thickness = 2
    
    Stroke.LineJoinMode = Enum.LineJoinMode.Round
    Stroke.Color = Color3.fromRGB(1, 94, 255) 
	Stroke.Transparency = 0

    -- El degradado de transparencia "fino y suave".
    local TransparencyGradient = Instance.new("UIGradient")
    TransparencyGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2), 
        NumberSequenceKeypoint.new(0.5, 0.8),
        NumberSequenceKeypoint.new(1, 1)
    })

    -- La rotación de esa versión era 120.
    TransparencyGradient.Rotation = 270
    TransparencyGradient.Parent = Stroke
    Stroke.Parent = Parent
    
    table.insert(_G.GlowStrokes, Stroke)
end


-- =========================================================
-- =========================================================





-- =========================================================
-- [[ SISTEMA AUTO CANVAS AUTOMATICO ]]
-- =========================================================


local AutoCanvasManager = {}

function AutoCanvasManager:setup(scrollingFrame)
    -- Esta función prepara cualquier ScrollingFrame para que su tamaño sea dinámico.
    -- Busca el UIListLayout o UIGridLayout que organiza el contenido.
    local layout = scrollingFrame:FindFirstChildOfClass("UIListLayout") or scrollingFrame:FindFirstChildOfClass("UIGridLayout")
    if not layout then
        -- Si no lo encuentra directamente, lo busca en un hijo llamado "ScriptsArea"
        local scriptsArea = scrollingFrame:FindFirstChild("ScriptsArea")
        if scriptsArea then
            layout = scriptsArea:FindFirstChildOfClass("UIListLayout") or scriptsArea:FindFirstChildOfClass("UIGridLayout")
        end
    end

    -- Si no hay un layout que ordene el contenido, no podemos hacer nada.
    if not layout then
        -- warn("AutoCanvasManager: No se encontró UIListLayout o UIGridLayout para " .. scrollingFrame.Name)
        return function() end -- Devuelve una función vacía
    end

    -- Forzamos el control manual del CanvasSize.
    scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.None

    -- La función que recalcula el tamaño.
    local function updateCanvas()
        -- Usamos task.defer para asegurar que el cálculo se haga después de que la UI se actualice, evitando el lag de task.wait()
        task.defer(function()
            local contentHeight = layout.AbsoluteContentSize.Y
            -- [[ MODIFICACIÓN ]] Ajusta el canvas con el 15% de espacio extra que pediste.
            scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, contentHeight * 1.60)
        end)
    end

    -- Conectamos la función para que se ejecute siempre que el contenido cambie de tamaño.
    local connection = layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
    
    -- Nos aseguramos de que la conexión se destruya si el ScrollingFrame es eliminado.
    scrollingFrame.Destroying:Connect(function()
        if connection then
            connection:Disconnect()
        end
    end)

    -- Hacemos una llamada inicial para establecer el tamaño.
    updateCanvas()

    -- Devolvemos la función de actualización para poder llamarla manually si es necesario (ej: al filtrar una búsqueda).
    return updateCanvas
end

-- =========================================================
-- =========================================================


function MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition
    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        local Tween = TweenService:Create(object, TweenInfo.new(0.15), {Position = pos})
        Tween:Play()
    end
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            input.Changed:Connect(function()
                if input.UserState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

-- ScreenGui para el icono flotante
local FloatingButtonGui = Instance.new("ScreenGui")
FloatingButtonGui.Name = "FloatingButtonGui"
FloatingButtonGui.Parent = game.CoreGui
FloatingButtonGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Validar servicios
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui", 10)

-- Intentar usar CoreGui (si Delta Executor lo permite)
local parentGui = CoreGui
local success, err = pcall(function()
    local testGui = Instance.new("ScreenGui")
    testGui.Parent = CoreGui
end)
if not success then
    warn("No se puede usar CoreGui, usando PlayerGui:", err)
    parentGui = PlayerGui
end

-- Destruir FloatingButtonGui existente
for _, gui in pairs({PlayerGui, CoreGui}) do
    if gui:FindFirstChild("FloatingButtonGui") then
        gui.FloatingButtonGui:Destroy()
    end
end

-- =========================================================
-- ICONO FLOTANTE DE LA INTERFAZ PRINCIPAL
-- =========================================================

local FloatingButtonGui = Instance.new("ScreenGui")
FloatingButtonGui.Name = "FloatingButtonGui"
FloatingButtonGui.Parent = parentGui
FloatingButtonGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
FloatingButtonGui.IgnoreGuiInset = true
FloatingButtonGui.DisplayOrder = 2147483647

-- Configurar UIScale
local success, err = pcall(function()
    local UIScale = Instance.new("UIScale")
    UIScale.Name = "UIScaleMain"
    UIScale.Parent = FloatingButtonGui
    local screenSize = GuiService:GetScreenResolution()
    UIScale.Scale = math.min(screenSize.X / 1920, screenSize.Y / 1080)
end)
if not success then warn("Error en UIScale:", err) end

-- Contenedor principal (ícono negro) con borde
local OutlineButton
local OutlineBorder 
local success, err = pcall(function()
    OutlineButton = Instance.new("Frame")
    OutlineButton.Name = "OutlineButton"
    OutlineButton.Parent = FloatingButtonGui
    OutlineButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    -- MODIFICACIÓN CRÍTICA: Posición inicial muy lejos de la pantalla para que no se vea.
    OutlineButton.Position = UDim2.new(5, 0, 5, 0) -- Nace muy lejos.
    OutlineButton.Size = UDim2.new(0, 120, 0, 120)
    OutlineButton.ZIndex = 2147483647
    OutlineButton.Visible = true -- Debe ser visible (no invisible) para que el Tween o el cambio de posición funcione.
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 18)
    corner.Parent = OutlineButton
    --(OutlineButton)
end)
if not success then warn("Error en OutlineButton o OutlineBorder:", err) return end

-- Botón de imagen (ícono central)
local ImageButton
local success, err = pcall(function()
    ImageButton = Instance.new("ImageButton")
    ImageButton.Parent = OutlineButton
    ImageButton.Position = UDim2.new(0.5, 0, 0.5, 0)
    ImageButton.Size = UDim2.new(0, 96, 0, 96)
    ImageButton.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageButton.BackgroundTransparency = 1
    ImageButton.ImageTransparency = 0
    ImageButton.AutoButtonColor = false
    ImageButton.ZIndex = 2147483648
    ImageButton.Visible = true
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
     corner.Parent = ImageButton
    --(ImageButton)
end)
if not success then warn("Error en ImageButton:", err) return end

-- Ícono principal (sin borde)
local ShadowIcon
local success, err = pcall(function()
    ShadowIcon = Instance.new("ImageLabel")
    ShadowIcon.Name = "ShadowIcon"
    ShadowIcon.Parent = ImageButton
    ShadowIcon.Size = UDim2.new(1, 0, 1, 0)
    ShadowIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    ShadowIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    ShadowIcon.BackgroundTransparency = 1
    ShadowIcon.Image = "rbxthumb://type=Asset&id=127469928873778&w=150&h=150"
    ShadowIcon.ImageTransparency = 0
    ShadowIcon.Visible = true
    ShadowIcon.ZIndex = 2147483648
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = ShadowIcon
end)
if not success then warn("Error en ShadowIcon:", err) end



-- =========================================================
-- AJUSTES DEL ICONO DE LA INTERFAZ PRINCIPAL (DROPDOWN) - ELIMINADO
-- =========================================================
-- La sección MakeDraggable para el OutlineButton
local isDragging = false
local function MakeDraggableFloatingButton(button, frame)
    local dragInput, dragStart, startPos
    local success, err = pcall(function()
        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                dragStart = input.Position
                startPos = frame.Position
                input.Changed:Connect(function()
                    if input.UserState == Enum.UserInputState.End then
                        isDragging = false
                    end
                end)
            end
        end)
        button.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                 dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and isDragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
    end)
    if not success then warn("Error en MakeDraggableFloatingButton:", err) end
end
local success, err = pcall(function() MakeDraggableFloatingButton(ImageButton, OutlineButton) end)
if not success then warn("Error al aplicar MakeDraggableFloatingButton:", err) end


-- Intentar ProtectGui si Delta Executor lo soporta
if syn and syn.protect_gui then
    local success, err = pcall(function()
        syn.protect_gui(FloatingButtonGui)
    end)
    if not success then warn("Error en syn.protect_gui:", err) end
end
-- =========================================================
-- =========================================================


-- =========================================================
-- SCREEN GUI PRINCIPAL
-- =========================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "xSOLITOxHUB"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Enabled = true
ScreenGui.DisplayOrder = 2147483645 -- Máximo para interfaz principal

-- Sistema de notificaciones
local NotificationFrame = Instance.new("ScreenGui")
NotificationFrame.Name = "NotificationFrame"
NotificationFrame.Parent = game.CoreGui
NotificationFrame.ZIndexBehavior = Enum.ZIndexBehavior.Global
NotificationFrame.DisplayOrder = 2147483645

-- [[ MODIFICACIÓN ]] Se añade UIScale para adaptar las notificaciones a cualquier pantalla.
local success, err = pcall(function()
    local GuiService = game:GetService("GuiService")
    local UIScale = Instance.new("UIScale")
    UIScale.Name = "UIScaleNotifications"
    UIScale.Parent = NotificationFrame
    local screenSize = GuiService:GetScreenResolution()
    UIScale.Scale = math.min(screenSize.X / 1500, screenSize.Y / 540)
end)
if not success then warn("Error en UIScale de Notificaciones:", err) end


local NotificationList = {}
local function RemoveOldestNotification()
    if #NotificationList > 0 then
        local removed = table.remove(NotificationList, 1)
        removed[1]:TweenPosition(
            removed[1].Position - UDim2.new(0, 0, 0, 50), -- se desliza hacia arriba
            "Out", "Sine", 0.2, true,
            function()
                removed[1]:Destroy()
            end
        )
    end
end

spawn(function()
    while wait(2) do
        if #NotificationList > 0 then
            RemoveOldestNotification()
        end
    end
end)

local Update = {}
function Update:Notify(desc)
    local Frame = Instance.new("Frame")
    local OutlineFrame = Instance.new("Frame")
    OutlineFrame.Name = "OutlineFrame"
    OutlineFrame.Parent = NotificationFrame
    OutlineFrame.ClipsDescendants = true
    OutlineFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    OutlineFrame.BackgroundTransparency = 0
    OutlineFrame.AnchorPoint = Vector2.new(1, 0)
    OutlineFrame.Position = UDim2.new(1, -30, 0, 30)
    OutlineFrame.Size = UDim2.new(0, 412, 0, 72)
    CreateRounded(OutlineFrame, 12)

    Frame.Name = "Frame"
    Frame.Parent = OutlineFrame
    Frame.ClipsDescendants = true
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = _G.Dark
    Frame.BackgroundTransparency = 1
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.Size = UDim2.new(0, 400, 0, 60)
    CreateRounded(Frame, 10)

    local NoticonIcon = Instance.new("ImageLabel")
NoticonIcon.Name = "NoticonIcon"
NoticonIcon.Parent = Frame
NoticonIcon.Size = UDim2.new(0, 45, 0, 45)
NoticonIcon.Position = UDim2.new(0, 8, 0, 8)
NoticonIcon.BackgroundTransparency = 1
NoticonIcon.Image = "rbxthumb://type=Asset&id=127469928873778&w=150&h=150"
NoticonIcon.Visible = true

    
local Desc = Instance.new("TextLabel")
Desc.Parent = Frame
Desc.BackgroundTransparency = 1
Desc.AnchorPoint = Vector2.new(0.5, 0.5)
Desc.Position = UDim2.new(0.5, 0, 0.5, 0) -- centrado exacto
Desc.Size = UDim2.new(1, -20, 0, 24) -- ocupa casi todo el ancho con padding
Desc.Font = Enum.Font.SourceSansBold -- misma fuente del título
Desc.Text = desc
Desc.TextColor3 = Color3.fromRGB(255, 255, 255) -- bien blanco
Desc.TextSize = 16 * 1.2 -- tamaño aumentado
Desc.TextTransparency = 0 -- bien visible
Desc.TextWrapped = true -- por si el texto es largo
Desc.TextXAlignment = Enum.TextXAlignment.Center
Desc.TextYAlignment = Enum.TextYAlignment.Center

    
    table.insert(NotificationList, {OutlineFrame})
end

-- Animación de carga
function Update:StartLoad()
    local Loader = Instance.new("ScreenGui")
    Loader.Name = "Loader"
    Loader.Parent = game.CoreGui
    Loader.ZIndexBehavior = Enum.ZIndexBehavior.Global
    Loader.DisplayOrder = 2147483644 -- Máximo para pantalla de carga

    -- Frame principal (sin fondo ni marco)
    local OutlineLoader = Instance.new("Frame")
    OutlineLoader.Name = "OutlineLoader"
    OutlineLoader.Parent = Loader
    OutlineLoader.ClipsDescendants = true
    OutlineLoader.BackgroundTransparency = 1 -- Transparente
    OutlineLoader.AnchorPoint = Vector2.new(0.5, 0.5)
    OutlineLoader.Position = UDim2.new(0.5, 0, 0.5, 0)
    OutlineLoader.Size = UDim2.new(0, 600, 0, 400) -- Igual que OutlineMain
    OutlineLoader.ZIndex = 2

    -- Configurar UIScale igual que OutlineMain
    local UIScale = Instance.new("UIScale")
    UIScale.Parent = OutlineLoader
    local screenSize = game:GetService("GuiService"):GetScreenResolution()
    local baseScaleFactor = math.min(screenSize.X / 1920, screenSize.Y / 1080) * 1.5
    local scaleFactor = math.min(baseScaleFactor * 1.4 * 0.85, 1.2)
    UIScale.Scale = scaleFactor

    -- Frame interior (sin fondo)
    local MainLoaderFrame = Instance.new("Frame")
    MainLoaderFrame.Name = "MainLoaderFrame"
    MainLoaderFrame.Parent = OutlineLoader
    MainLoaderFrame.ClipsDescendants = true
    MainLoaderFrame.BackgroundTransparency = 1 -- Transparente
    MainLoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainLoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainLoaderFrame.Size = UDim2.new(1, 0, 1, 0)

    -- Fondo negro opaco para textos
    local TextBackground = Instance.new("Frame")
    TextBackground.Name = "TextBackground"
    TextBackground.Parent = MainLoaderFrame
    TextBackground.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TextBackground.BackgroundTransparency = 0
    TextBackground.Size = UDim2.new(0.9, 0, 0.5, 0)
    TextBackground.Position = UDim2.new(0.05, 0, 0.25, 0)
    TextBackground.ZIndex = 3
    CreateRounded(TextBackground, 15)

    -- Efecto de gradiente para TextBackground
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Rotation = 90
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.3, 0.5),
         NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Parent = TextBackground

    -- UIStroke negro sólido para TextBackground
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Parent = TextBackground
    UIStroke.Thickness = 2
    UIStroke.Color = Color3.fromRGB(0, 0, 0) -- Negro sólido

    -- Título
    local TitleLoader = Instance.new("TextLabel")
    TitleLoader.Name = "TitleLoader"
    TitleLoader.Parent = MainLoaderFrame
    TitleLoader.Text = "xSOLITOx HUB"
    TitleLoader.Font = Enum.Font.FredokaOne
    TitleLoader.TextSize = 50
    TitleLoader.TextColor3 = Color3.fromRGB(255, 255, 255) -- Blanco
    TitleLoader.BackgroundTransparency = 1
    TitleLoader.AnchorPoint = Vector2.new(0.5, 0.5)
    TitleLoader.Position = UDim2.new(0.5, 0, 0.35, 0)
    TitleLoader.Size = UDim2.new(0.9, 0, 0.2, 0)
    TitleLoader.ZIndex = 4

    -- Descripción
    local DescriptionLoader = Instance.new("TextLabel")
    DescriptionLoader.Name = "DescriptionLoader"
    DescriptionLoader.Parent = MainLoaderFrame
    DescriptionLoader.Text = "Cargando..."
    DescriptionLoader.Font = Enum.Font.SourceSansBold
    DescriptionLoader.TextSize = 18
    DescriptionLoader.TextColor3 = Color3.fromRGB(255, 255, 255)
     DescriptionLoader.BackgroundTransparency = 1
    DescriptionLoader.AnchorPoint = Vector2.new(0.5, 0.5)
    DescriptionLoader.Position = UDim2.new(0.5, 0, 0.45, 0)
    DescriptionLoader.Size = UDim2.new(0.9, 0, 0.1, 0)
    DescriptionLoader.ZIndex = 4

    -- Fondo de la barra de carga
    local LoadingBarBackground = Instance.new("Frame")
    LoadingBarBackground.Name = "LoadingBarBackground"
    LoadingBarBackground.Parent = MainLoaderFrame
    LoadingBarBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Gris
    LoadingBarBackground.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadingBarBackground.Position = UDim2.new(0.5, 0, 0.65, 0)
    LoadingBarBackground.Size = UDim2.new(0.8, 0, 0.05, 0)
    LoadingBarBackground.ClipsDescendants = true
    LoadingBarBackground.ZIndex = 4
    CreateRounded(LoadingBarBackground, 20)

    -- UIStroke negro sólido para LoadingBarBackground
    local BarStroke = Instance.new("UIStroke")
    BarStroke.Parent = LoadingBarBackground
    BarStroke.Thickness = 2
    BarStroke.Color = Color3.fromRGB(0, 0, 0) -- Negro sólido

    local LoadingBar = Instance.new("Frame")
    LoadingBar.Name = "LoadingBar"
    LoadingBar.Parent = LoadingBarBackground
    LoadingBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Añadido
    LoadingBar.BackgroundTransparency = 0
    LoadingBar.Size = UDim2.new(0, 0, 1, 0)
    LoadingBar.ZIndex = 4
    CreateRounded(LoadingBar, 20)

    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("#015EFF")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("#FF0546"))
    })
    Gradient.Rotation = 0
    Gradient.Parent = LoadingBar

    -- Recolectar elementos afectados
    local imageElements = {} -- Imágenes (ninguna por ahora, preparado para logo)
    local textElements = {} -- Textos: TitleLoader, DescriptionLoader
    local function collectElements()
         for _, child in pairs(OutlineLoader:GetDescendants()) do -- Changed parent from 'parent' to 'OutlineLoader'
            if child:IsA("ImageLabel") or child:IsA("ImageButton") then
                if child.Name == "CategoryIcon" or child.Name == "CloseButton" or
                    child.Name == "ResizeButton" or child.Name == "SettingsButton" or
                   child.Name == "CornerImage" or child.Name == "IndicatorBar" then
                    imageElements[child] = child.Size
                end
            elseif child:IsA("TextLabel") or child:IsA("TextButton") then
                if not textElements[child] then
                    textElements[child] = child.TextSize
                end
            end
        end
    end

    -- Botón de redimensionamiento
    local NewResizeHandle = Instance.new("TextButton")
    NewResizeHandle.Name = "NewResizeHandle"
    NewResizeHandle.Parent = OutlineLoader
    NewResizeHandle.Position = UDim2.new(1, -2, 1, -2)
    NewResizeHandle.AnchorPoint = Vector2.new(1, 1)
    NewResizeHandle.Size = UDim2.new(0, 40, 0, 40)
    NewResizeHandle.BackgroundTransparency = 1
     NewResizeHandle.Text = ""
    NewResizeHandle.ZIndex = 201
    NewResizeHandle.AutoButtonColor = false
    CreateRounded(NewResizeHandle, 10)

    local newResizeDragging = false
    local newResizeStartMousePos, newResizeStartFrameSize
    local minWidth = 600 -- Igual que OutlineMain
    local maxWidth = 1280
    local maxScaleWidth = 900
    local minImageScale = 1.0 -- Tamaño base original
    local maxImageScale = 1.38
    local minTextScale = 1.0 -- Tamaño base original
    local maxTextScale = 1.5

    
    -- Iniciar arrastre
    NewResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            newResizeDragging = true
            newResizeStartMousePos = input.Position
            newResizeStartFrameSize = Vector2.new(OutlineLoader.Size.X.Offset, OutlineLoader.Size.Y.Offset)
        end
    end)

    -- Finalizar arrastre
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            newResizeDragging = false
        end
    end)

    -- Actualizar tamaño
    UserInputService.InputChanged:Connect(function(input)
        if newResizeDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local scale = OutlineLoader.UIScale.Scale or 1
            local delta = (input.Position - newResizeStartMousePos) * 1.5 / scale
             local newWidth = math.clamp(newResizeStartFrameSize.X + delta.X, minWidth, maxWidth)
            local newHeight = math.clamp(newResizeStartFrameSize.Y + delta.Y, 400, 576)

            -- Mapear ancho a escala
            local t
            if newWidth <= maxScaleWidth then
                t = (newWidth - minWidth) / (maxScaleWidth - minWidth)
            else
                t = 1
            end

            -- Ajustar disminución
            local adjustedT = newWidth < newResizeStartFrameSize.X and math.sqrt(t) * (newWidth <= minWidth + 50 and 0.8 or 1) or t

             -- Escala para imágenes
            local imageScaleFactor = minImageScale + (maxImageScale - minImageScale) * adjustedT
            -- Escala para textos
            local textScaleFactor = minTextScale + (maxTextScale - minTextScale) * adjustedT

            -- Escalar imágenes
            for element, baseSize in pairs(imageElements) do
                 element.Size = UDim2.new(
                    baseSize.X.Scale, baseSize.X.Offset * imageScaleFactor,
                    baseSize.Y.Scale, baseSize.Y.Offset * imageScaleFactor
                )
            end

            -- Escalar textos
              for element, baseTextSize in pairs(textElements) do
                element.TextSize = baseTextSize * textScaleFactor
            end

            -- Actualizar OutlineLoader
            OutlineLoader.Size = UDim2.new(0, newWidth, 0, newHeight)

            -- Ajustar MainLoaderFrame
             MainLoaderFrame.Size = UDim2.new(1, 0, 1, 0)

            -- Ajustar TextBackground
            TextBackground.Size = UDim2.new(0.9, 0, 0.5, 0)
            TextBackground.Position = UDim2.new(0.05, 0, 0.25, 0)

            -- Ajustar LoadingBarBackground
            LoadingBarBackground.Size = UDim2.new(0.8, 0, 0.05, 0)
            LoadingBarBackground.Position = UDim2.new(0.5, 0, 0.65, 0)

            -- Ajustar UIStroke
            for _, element in pairs({TextBackground, LoadingBarBackground}) do
                local stroke = element:FindFirstChildOfClass("UIStroke")
                if stroke then
                    stroke.Thickness = math.max(1, 2 / scale)
                 end
            end
        end
    end)

    -- Animación de la barra
    local barTweenInfoPart1 = TweenInfo.new(0.5, Enum.EasingStyle.Linear)
    local barTweenPart1 = TweenService:Create(LoadingBar, barTweenInfoPart1, {Size = UDim2.new(0.25, 0, 1, 0)})
    local barTweenInfoPart2 = TweenInfo.new(1, Enum.EasingStyle.Linear)
    local barTweenPart2 = TweenService:Create(LoadingBar, barTweenInfoPart2, {Size = UDim2.new(1, 0, 1, 0)})

    barTweenPart1:Play()
    local dotCount = 0
    local running = true
    spawn(function()
        while running do
            dotCount = (dotCount + 1) % 4
            DescriptionLoader.Text = "Por favor espera" .. string.rep(".", dotCount)
            wait(0.5)
        end
    end)

    barTweenPart1.Completed:Connect(function()
        barTweenPart2:Play()
         barTweenPart2.Completed:Connect(function()
            wait(1)
            running = false
            DescriptionLoader.Text = "¡Cargado!"
            wait(0.5)
            Loader:Destroy()
            ScreenGui.Enabled = true
            Update:Notify("xSOLITOx HUB Loaded!")
         end)
    end)
end

-- =========================================================
-- =========================================================


-- =========================================================
-- FUNCION PARA GUARDAR LOS AJUSTES
-- PRIMARIOS EN UNA CARPETA DEL EXECUTOR
-- =========================================================

-- Configuración de ajustes
local SettingsLib = {SaveSettings = true, LoadAnimation = true, FloatingIconTransparency = 0, FloatingIconSize = 120, MainTransparency = 0.1,
    walkspeed = 16,
    jump = 50,
    gravity = 196.2,
    noclip = false,
    antisit = true,
    infiniteJump = false,
    antivoid = true
}
getgenv().LoadConfig = function()
    if isfolder and makefolder and isfile and readfile and writefile then
        if not isfolder("xSOLITOxHUB") then
            makefolder("xSOLITOxHUB")
        end
        if not isfolder("xSOLITOxHUB/Library") then
            makefolder("xSOLITOxHUB/Library")
        end
        local filePath = "xSOLITOxHUB/Library/" .. Players.LocalPlayer.Name .. ".json"
        if not isfile(filePath) then
            writefile(filePath, HttpService:JSONEncode(SettingsLib))
        else
            local Decode = HttpService:JSONDecode(readfile(filePath))
            for i, v in pairs(Decode) do
                SettingsLib[i] = v
            end
        end
    else
        warn("Status: Undetected Executor")
    end
end

getgenv().SaveConfig = function()
    if isfolder and isfile and writefile then
        local filePath = "xSOLITOxHUB/Library/" .. Players.LocalPlayer.Name .. ".json"
        writefile(filePath, HttpService:JSONEncode(SettingsLib))
    else
         warn("Status: Undetected Executor")
    end
end

getgenv().LoadConfig()

function Update:SaveSettings()
    return SettingsLib.SaveSettings
end

function Update:LoadAnimation()
    return SettingsLib.LoadAnimation
end

function Update:GetMainTransparency()
    return SettingsLib.MainTransparency
end
-- =========================================================
-- =========================================================



-- =========================================================
-- VENTANA PRINCIPAL
-- =========================================================

function Update:Window(Config)
    local WindowConfig = {
        Size = Config.Size or UDim2.new(0, 600, 0, 400),
        TabWidth = Config.TabWidth or 150
    }
    OutlineMain = Instance.new("Frame")
    OutlineMain.Name = "OutlineMain"
    OutlineMain.Parent = ScreenGui
    OutlineMain.ClipsDescendants = false -- Sin clipping
    OutlineMain.AnchorPoint = Vector2.new(0.5, 0.5)
    OutlineMain.BackgroundColor3 = _G.Dark -- Negro puro (#000000)
    OutlineMain.BackgroundTransparency = 0
    OutlineMain.Position = UDim2.new(0.5, 0, 0.45, 0)
    OutlineMain.Size = WindowConfig.Size
    CreateRounded(OutlineMain, 15)
    --(OutlineMain)

    -- Configurar UIScale (sin cambios)
    local UIScale = Instance.new("UIScale")
    UIScale.Parent = OutlineMain
    local screenSize = game:GetService("GuiService"):GetScreenResolution()
    local baseScaleFactor = math.min(screenSize.X / 1920, screenSize.Y / 1080) * 1.5
    local scaleFactor = math.min(baseScaleFactor * 1.4 * 0.85, 1.2)
    UIScale.Scale = scaleFactor

    -- [[ PEGAR ESTE BLOQUE CORREGIDO PARA EL PASO 1 ]]
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = OutlineMain
    Main.ClipsDescendants = true 
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Main.BackgroundTransparency = 1
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(1, -16, 1, -16) 
    CreateRounded(Main, 12)

    local Top = Instance.new("Frame")
    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Top.Size = UDim2.new(1, 0, 0, 40)
    Top.BackgroundTransparency = 1
    CreateRounded(Top, 5)

    local NameHub = Instance.new("TextLabel")
    NameHub.Name = "NameHub"
    NameHub.Parent = Top
    NameHub.BackgroundTransparency = 1
    NameHub.Position = UDim2.new(0, 15, 0.5, 0)
    NameHub.AnchorPoint = Vector2.new(0, 0.5)
    NameHub.Size = UDim2.new(0, 100, 0, 25)
    NameHub.Font = Enum.Font.GothamBold
     NameHub.Text = "xSOLITOx HUB"
    NameHub.TextSize = 20
    NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameHub.TextXAlignment = Enum.TextXAlignment.Left

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Name = "SubTitle"
    SubTitle.Parent = NameHub
    SubTitle.BackgroundTransparency = 1
    SubTitle.Position = UDim2.new(0, 120, 0.5, 0)
    SubTitle.Size = UDim2.new(0, 100, 0, 20)
    SubTitle.Font = Enum.Font.Cartoon
    SubTitle.AnchorPoint = Vector2.new(0, 0.5)
    SubTitle.Text = Config.SubTitle or "v1.2"
    SubTitle.TextSize = 15
    SubTitle.TextColor3 = Color3.fromRGB(150, 150, 150)

    local CloseButton = Instance.new("ImageButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = Top
    CloseButton.BackgroundTransparency = 1
    CloseButton.AnchorPoint = Vector2.new(1, 0.5)
    CloseButton.Position = UDim2.new(1, -15, 0.5, 0)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Image = "rbxthumb://type=Asset&id=7743878857&w=150&h=150"
    CloseButton.ImageColor3 = Color3.fromRGB(245, 245, 245)
    CreateRounded(CloseButton, 3)
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = false
    end)

    local ResizeButton = Instance.new("ImageButton")
    ResizeButton.Name = "ResizeButton"
    ResizeButton.Parent = Top
    ResizeButton.BackgroundTransparency = 1
    ResizeButton.AnchorPoint = Vector2.new(1, 0.5)
    ResizeButton.Position = UDim2.new(1, -50, 0.5, 0)
    ResizeButton.Size = UDim2.new(0, 20, 0, 20)
    ResizeButton.Image = "rbxassetid://10734886735"
    ResizeButton.ImageColor3 = Color3.fromRGB(245, 245, 245)
    CreateRounded(ResizeButton, 3)


    -- =========================================================
    -- AJUSTES PRIMARIOS DE LA INTERFAZ PRINCIPAL (AHORA CON SLIDERS DEL ICONO FLOTANTE)
    -- =========================================================

    local SettingsButton = Instance.new("ImageButton")
    SettingsButton.Name = "SettingsButton"
     SettingsButton.Parent = Top
    SettingsButton.BackgroundTransparency = 1
    SettingsButton.AnchorPoint = Vector2.new(1, 0.5)
    SettingsButton.Position = UDim2.new(1, -85, 0.5, 0)
    SettingsButton.Size = UDim2.new(0, 20, 0, 20)
    SettingsButton.Image = "rbxassetid://10734950020"
    SettingsButton.ImageColor3 = Color3.fromRGB(245, 245, 245)
    CreateRounded(SettingsButton, 3)

    local BackgroundSettings = Instance.new("Frame")
    BackgroundSettings.Name = "BackgroundSettings"
    BackgroundSettings.Parent = OutlineMain
    BackgroundSettings.ClipsDescendants = true
    BackgroundSettings.Active = false -- NO CONGELA LA INTERFAZ PRINCIPAL
    BackgroundSettings.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
     BackgroundSettings.BackgroundTransparency = 1 -- SIN FONDO
    BackgroundSettings.Position = UDim2.new(0, 0, 0, 0)
    BackgroundSettings.Size = UDim2.new(1, 0, 1, 0)
    BackgroundSettings.Visible = false
    BackgroundSettings.ZIndex = 150 -- Asegura que esté por encima de la interfaz principal

    local SettingsFrame = Instance.new("Frame")
    SettingsFrame.Name = "SettingsFrame"
    SettingsFrame.Parent = BackgroundSettings
    SettingsFrame.ClipsDescendants = true
    SettingsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    SettingsFrame.BackgroundColor3 = _G.Dark
    SettingsFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    SettingsFrame.Size = UDim2.new(0, 400, 0, 300) -- MISMO TAMAÑO QUE ThemeWindow
    CreateRounded(SettingsFrame, 15)
    CreateGlowStroke(SettingsFrame) -- Aplica el mismo borde degradado

    local CloseSettings = Instance.new("ImageButton")
    CloseSettings.Name = "CloseSettings"
    CloseSettings.Parent = SettingsFrame
    CloseSettings.BackgroundTransparency = 1
    CloseSettings.AnchorPoint = Vector2.new(1, 0)
    CloseSettings.Position = UDim2.new(1, -15, 0, 15) -- Mover 5px a la derecha (antes -20, ahora -15)
    CloseSettings.Size = UDim2.new(0, 26, 0, 26) -- Aumentar tamaño en 30% (antes 20, ahora 26)
     CloseSettings.Image = "rbxassetid://10747384394"
    CloseSettings.ImageColor3 = Color3.fromRGB(245, 245, 245)
    CreateRounded(CloseSettings, 3)
    CloseSettings.MouseButton1Click:Connect(function()
        BackgroundSettings.Visible = false
    end)

    SettingsButton.MouseButton1Click:Connect(function()
        BackgroundSettings.Visible = not BackgroundSettings.Visible
    end)

    local TitleSettings = Instance.new("TextLabel")
    TitleSettings.Name = "TitleSettings"
    TitleSettings.Parent = SettingsFrame
    TitleSettings.BackgroundTransparency = 1
    TitleSettings.Position = UDim2.new(0, 20, 0, 15)
    TitleSettings.Size = UDim2.new(1, 0, 0, 20)
     TitleSettings.Font = Enum.Font.GothamBold
    TitleSettings.Text = "Ajustes del icono" -- Changed title
    TitleSettings.TextSize = 20
    TitleSettings.TextColor3 = Color3.fromRGB(245, 245, 245)
    TitleSettings.TextXAlignment = Enum.TextXAlignment.Left

    local SettingsMenuList = Instance.new("Frame")
    SettingsMenuList.Name = "SettingsMenuList"
    SettingsMenuList.Parent = SettingsFrame
    SettingsMenuList.ClipsDescendants = true
    SettingsMenuList.BackgroundTransparency = 1
    SettingsMenuList.Position = UDim2.new(0, 0, 0, 50)
    SettingsMenuList.Size = UDim2.new(1, 0, 1, -70)
    CreateRounded(SettingsMenuList, 15)

    local ScrollSettings = Instance.new("ScrollingFrame")
    ScrollSettings.Name = "ScrollSettings"
    ScrollSettings.Parent = SettingsMenuList
    ScrollSettings.Active = true
    ScrollSettings.BackgroundTransparency = 1
    ScrollSettings.Size = UDim2.new(1, 0, 1, 0)
    ScrollSettings.ScrollBarThickness = 1
    ScrollSettings.ScrollingDirection = Enum.ScrollingDirection.Y

    local SettingsListLayout = Instance.new("UIListLayout")
    SettingsListLayout.Parent = ScrollSettings
    SettingsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SettingsListLayout.Padding = UDim.new(0, 20) -- MAYOR ESPACIO
    SettingsListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center -- Centrar elementos del layout

    local function CreateCheckbox(title, state, callback, parentFrame)
         local Background = Instance.new("Frame")
         Background.Parent = parentFrame or ScrollSettings -- Default to ScrollSettings if no parentFrame
        Background.BackgroundTransparency = 1
        Background.Size = UDim2.new(1, 0, 0, 20)
        Background.LayoutOrder = Background.LayoutOrder or 0 -- Initialize LayoutOrder

        local Title = Instance.new("TextLabel")
        Title.Parent = Background
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 60, 0.5, 0)
         Title.Size = UDim2.new(1, -60, 0, 20)
        Title.Font = Enum.Font.Code
        Title.AnchorPoint = Vector2.new(0, 0.5)
        Title.Text = title
        Title.TextSize = 15
        Title.TextColor3 = Color3.fromRGB(200, 200, 200)
        Title.TextXAlignment = Enum.TextXAlignment.Left

        local Checkbox = Instance.new("ImageButton")
        Checkbox.Parent = Background
         Checkbox.BackgroundColor3 = state and _G.Third or Color3.fromRGB(100, 100, 100)
        Checkbox.AnchorPoint = Vector2.new(0, 0.5)
        Checkbox.Position = UDim2.new(0, 30, 0.5, 0)
        Checkbox.Size = UDim2.new(0, 20, 0, 20)
        Checkbox.Image = "rbxassetid://10709790644"
        Checkbox.ImageTransparency = state and 0 or 1
        Checkbox.ImageColor3 = Color3.fromRGB(245, 245, 245)
        CreateRounded(Checkbox, 5)

         Checkbox.MouseButton1Click:Connect(function()
            state = not state
            Checkbox.ImageTransparency = state and 0 or 1
            Checkbox.BackgroundColor3 = state and _G.Third or Color3.fromRGB(100, 100, 100)
            pcall(callback, state)
        end)
        return Background
    end

    local function CreateButton(title, callback, parentFrame)
         local Background = Instance.new("Frame")
        Background.Parent = parentFrame or ScrollSettings -- Default to ScrollSettings if no parentFrame
        Background.BackgroundTransparency = 1
        Background.Size = UDim2.new(1, 0, 0, 30)
        Background.LayoutOrder = Background.LayoutOrder or 0 -- Initialize LayoutOrder

        local Button = Instance.new("TextButton")
        Button.Parent = Background
        Button.Size = UDim2.new(0.8, 0, 0, 30)
         Button.Font = Enum.Font.Code
        Button.Text = title
        Button.AnchorPoint = Vector2.new(0.5, 0)
        Button.Position = UDim2.new(0.5, 0, 0, 0)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 15
        Button.AutoButtonColor = false
        CreateRounded(Button, 5)
        ApplyDefaultGradient(Button) -- Aplicar degradado por defecto

         -- Ensure text is on top
        local buttonText = Instance.new("TextLabel")
        buttonText.Parent = Button
        buttonText.Size = UDim2.new(1, 0, 1, 0)
        buttonText.BackgroundTransparency = 1
        buttonText.Text = title
        buttonText.Font = Enum.Font.Code
        buttonText.TextSize = 15
        buttonText.TextColor3 = Color3.fromRGB(255, 255, 255)
         buttonText.TextXAlignment = Enum.TextXAlignment.Center
        buttonText.TextYAlignment = Enum.TextYAlignment.Center
        buttonText.ZIndex = Button.ZIndex + 1

        Button.MouseButton1Click:Connect(callback)
        return Background
    end
    
    -- New Transparency Slider for Floating Icon
    local TransparencyLabel = Instance.new("TextLabel")
    TransparencyLabel.Name = "TransparencyLabel"
    TransparencyLabel.Parent = ScrollSettings
    TransparencyLabel.BackgroundTransparency = 1
    TransparencyLabel.Position = UDim2.new(0.5, 0, 0, 15) -- Ajustado para centrar verticalmente en el frame de 300 de alto
    TransparencyLabel.AnchorPoint = Vector2.new(0.5, 0) -- Anclaje al centro
    TransparencyLabel.Size = UDim2.new(0.8, 0, 0, 20)
    TransparencyLabel.Font = Enum.Font.Gotham
    TransparencyLabel.Text = "Transparencia del Icono"
    TransparencyLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    TransparencyLabel.TextSize = 14
    TransparencyLabel.TextXAlignment = Enum.TextXAlignment.Center -- Alineado al centro
    TransparencyLabel.LayoutOrder = 1

    local IconTransparencySlider = Instance.new("Frame")
    IconTransparencySlider.Name = "IconTransparencySlider"
    IconTransparencySlider.Parent = ScrollSettings
    IconTransparencySlider.BackgroundColor3 = Color3.fromRGB(25, 25, 25) 
    IconTransparencySlider.Position = UDim2.new(0.5, 0, 0, 40) -- Ajustado
    IconTransparencySlider.Size = UDim2.new(0.8, 0, 0, 12)
    IconTransparencySlider.AnchorPoint = Vector2.new(0.5, 0)
    CreateRounded(IconTransparencySlider, 6)
    IconTransparencySlider.LayoutOrder = 2

    local IconTransparencySliderFill = Instance.new("Frame")
    IconTransparencySliderFill.Name = "IconTransparencySliderFill"
    IconTransparencySliderFill.Parent = IconTransparencySlider
    IconTransparencySliderFill.Size = UDim2.new(0, 0, 1, 0)
    IconTransparencySliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CreateRounded(IconTransparencySliderFill, 6)

    local IconTransparencyGradient = Instance.new("UIGradient")
    IconTransparencyGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(1, 94, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 5, 70))
    })
    IconTransparencyGradient.Rotation = 0
    IconTransparencyGradient.Parent = IconTransparencySliderFill

    local IconTransparencySliderHandle = Instance.new("Frame")
    IconTransparencySliderHandle.Name = "IconTransparencySliderHandle"
    IconTransparencySliderHandle.Parent = IconTransparencySlider
    IconTransparencySliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    IconTransparencySliderHandle.Position = UDim2.new(0, 0, 0.5, 0)
    IconTransparencySliderHandle.Size = UDim2.new(0, 16, 0, 16)
    IconTransparencySliderHandle.AnchorPoint = Vector2.new(0.5, 0.5)
    IconTransparencySliderHandle.ZIndex = IconTransparencySlider.ZIndex + 1
    CreateRounded(IconTransparencySliderHandle, 8)

    local isIconTransparencyDragging = false
    local function updateIconTransparency(inputPos)
        local sliderSize = IconTransparencySlider.AbsoluteSize
        local sliderPos = IconTransparencySlider.AbsolutePosition
        local relativeX = math.clamp(inputPos.X - sliderPos.X, 0, sliderSize.X)
        local t = relativeX / sliderSize.X
        
        local transparency = t * 0.9 -- Original transparency logic 0 to 0.9
        ShadowIcon.ImageTransparency = transparency
         OutlineButton.BackgroundTransparency = transparency
        
        -- OutlineBorder does not exist in the new structure so this line is removed
        
        IconTransparencySliderFill.Size = UDim2.new(t, 0, 1, 0)
        IconTransparencySliderHandle.Position = UDim2.new(t, 0, 0.5, 0)
        SettingsLib.FloatingIconTransparency = transparency
        getgenv().SaveConfig()
    end

    IconTransparencySlider.InputBegan:Connect(function(input)
         if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isIconTransparencyDragging = true
            updateIconTransparency(input.Position)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isIconTransparencyDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateIconTransparency(input.Position)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
         if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isIconTransparencyDragging = false
        end
    end)

    -- New Size Slider for Floating Icon
    local SizeLabel = Instance.new("TextLabel")
    SizeLabel.Name = "SizeLabel"
    SizeLabel.Parent = ScrollSettings
    SizeLabel.BackgroundTransparency = 1
    SizeLabel.Position = UDim2.new(0.5, 0, 0, 70) -- Ajustado
    SizeLabel.AnchorPoint = Vector2.new(0.5, 0) -- Anclaje al centro
      SizeLabel.Size = UDim2.new(0.8, 0, 0, 20)
    SizeLabel.Font = Enum.Font.Gotham
    SizeLabel.Text = "Tamaño del Icono"
    SizeLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    SizeLabel.TextSize = 14
    SizeLabel.TextXAlignment = Enum.TextXAlignment.Center -- Alineado al centro
    SizeLabel.LayoutOrder = 3

    local IconSizeSlider = Instance.new("Frame")
    IconSizeSlider.Name = "IconSizeSlider"
    IconSizeSlider.Parent = ScrollSettings
    IconSizeSlider.BackgroundColor3 = Color3.fromRGB(25, 25, 25) 
    IconSizeSlider.Position = UDim2.new(0.5, 0, 0, 95) -- Ajustado
    IconSizeSlider.Size = UDim2.new(0.8, 0, 0, 12)
     IconSizeSlider.AnchorPoint = Vector2.new(0.5, 0)
    CreateRounded(IconSizeSlider, 6)
    IconSizeSlider.LayoutOrder = 4

    local IconSizeSliderFill = Instance.new("Frame")
    IconSizeSliderFill.Name = "IconSizeSliderFill"
    IconSizeSliderFill.Parent = IconSizeSlider
    IconSizeSliderFill.Size = UDim2.new(0, 0, 1, 0)
    IconSizeSliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CreateRounded(IconSizeSliderFill, 6)

    local IconSizeGradient = Instance.new("UIGradient")
    IconSizeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(1, 94, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 5, 70))
    })
     IconSizeGradient.Rotation = 0
    IconSizeGradient.Parent = IconSizeSliderFill

    local IconSizeSliderHandle = Instance.new("Frame")
    IconSizeSliderHandle.Name = "IconSizeSliderHandle"
    IconSizeSliderHandle.Parent = IconSizeSlider
    IconSizeSliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    IconSizeSliderHandle.Position = UDim2.new(0, 0, 0.5, 0)
    IconSizeSliderHandle.Size = UDim2.new(0, 16, 0, 16)
    IconSizeSliderHandle.AnchorPoint = Vector2.new(0.5, 0.5)
    IconSizeSliderHandle.ZIndex = IconSizeSlider.ZIndex + 1
    CreateRounded(IconSizeSliderHandle, 8)

    local isIconSizeDragging = false
    local function updateIconSize(inputPos)
        local sliderSize = IconSizeSlider.AbsoluteSize
          local sliderPos = IconSizeSlider.AbsolutePosition
        local relativeX = math.clamp(inputPos.X - sliderPos.X, 0, sliderSize.X)
        local t = relativeX / sliderSize.X
        
        local newSize = 80 + t * (200 - 80) -- Original size logic 80 to 200
        OutlineButton.Size = UDim2.new(0, newSize, 0, newSize)
        ImageButton.Size = UDim2.new(0, newSize * 0.8, 0, newSize * 0.8)
         ShadowIcon.Size = UDim2.new(1, 0, 1, 0)
        -- SettingsButton.Size = UDim2.new(1, 0, 0, 18) -- This line controls the settings button in the old dropdown, not needed here.
        -- Restore transparency based on the value from settings
        ShadowIcon.ImageTransparency = SettingsLib.FloatingIconTransparency
        OutlineButton.BackgroundTransparency = SettingsLib.FloatingIconTransparency

        IconSizeSliderFill.Size = UDim2.new(t, 0, 1, 0)
        IconSizeSliderHandle.Position = UDim2.new(t, 0, 0.5, 0)
        SettingsLib.FloatingIconSize = newSize
        getgenv().SaveConfig()
    end

    IconSizeSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isIconSizeDragging = true
            updateIconSize(input.Position)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isIconSizeDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateIconSize(input.Position)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isIconSizeDragging = false
        end
    end)


    -- Apply initial saved values
    ShadowIcon.ImageTransparency = SettingsLib.FloatingIconTransparency
    OutlineButton.BackgroundTransparency = SettingsLib.FloatingIconTransparency
    local initialTransparencyT = SettingsLib.FloatingIconTransparency / 0.9
    IconTransparencySliderFill.Size = UDim2.new(initialTransparencyT, 0, 1, 0)
    IconTransparencySliderHandle.Position = UDim2.new(initialTransparencyT, 0, 0.5, 0)

    OutlineButton.Size = UDim2.new(0, SettingsLib.FloatingIconSize, 0, SettingsLib.FloatingIconSize)
    ImageButton.Size = UDim2.new(0, SettingsLib.FloatingIconSize * 0.8, 0, SettingsLib.FloatingIconSize * 0.8)
    ShadowIcon.Size = UDim2.new(1, 0, 1, 0)
    local initialSizeT = (SettingsLib.FloatingIconSize - 80) / (200 - 80)
    IconSizeSliderFill.Size = UDim2.new(initialSizeT, 0, 1, 0)
    IconSizeSliderHandle.Position = UDim2.new(initialSizeT, 0, 0.5, 0)


    -- Nuevo botón "Restablecer" para los sliders del icono flotante
    local resetButton = CreateButton("Restablecer", function()
        -- Reset settings in memory and apply
        SettingsLib.FloatingIconTransparency = 0
        SettingsLib.FloatingIconSize = 120
        getgenv().SaveConfig()

        -- Reapply default states to sliders and icon
        ShadowIcon.ImageTransparency = 0
        OutlineButton.BackgroundTransparency = 0
        IconTransparencySliderFill.Size = UDim2.new(0, 0, 1, 0)
        IconTransparencySliderHandle.Position = UDim2.new(0, 0, 0.5, 0)

        OutlineButton.Size = UDim2.new(0, 120, 0, 120)
        ImageButton.Size = UDim2.new(0, 96, 0, 96)
        ShadowIcon.Size = UDim2.new(1, 0, 1, 0)
        IconSizeSliderFill.Size = UDim2.new(0.5, 0, 1, 0) -- For 120, assuming 80-200 range
        IconSizeSliderHandle.Position = UDim2.new(0.5, 0, 0.5, 0)
        Update:Notify("Sliders del icono restablecidos!")
    end, ScrollSettings)
    resetButton.LayoutOrder = 5
    resetButton.Position = resetButton.Position + UDim2.new(0,0,0,30) -- Mover 30px hacia abajo


    local SidebarScroll = Instance.new("ScrollingFrame")
    SidebarScroll.Name = "SidebarScroll"
    SidebarScroll.Parent = Main
    SidebarScroll.Position = UDim2.new(0, 0, 0, 40)
    SidebarScroll.Size = UDim2.new(0, WindowConfig.TabWidth, 1, -40)
    SidebarScroll.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Aseguramos que el color de fondo sea negro
    SidebarScroll.BorderSizePixel = 0
    SidebarScroll.BackgroundTransparency = 1 -- Eliminado por completo el fondo de las categorías
    SidebarScroll.ScrollBarThickness = 1
    SidebarScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    SidebarScroll.ScrollingDirection = Enum.ScrollingDirection.Y -- Solo scrolleo vertical
    CreateRounded(SidebarScroll, 5)

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = SidebarScroll
    SidebarLayout.Padding = UDim.new(0.028, 0)
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center -- Centrar elementos del layout

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.Parent = SidebarScroll
    SidebarPadding.PaddingTop = UDim.new(0, 7)
    SidebarPadding.PaddingLeft = UDim.new(0, 0)
    SidebarPadding.PaddingRight = UDim.new(0, 0)

    local Page = Instance.new("Frame")
    Page.Name = "Page"
    Page.Parent = Main
    Page.BackgroundTransparency = 1
    Page.Position = UDim2.new(0, WindowConfig.TabWidth, 0, 40)
    Page.Size = UDim2.new(1, -WindowConfig.TabWidth, 1, -40)
    CreateRounded(Page, 3)


    local MainPage = Instance.new("Frame")
    MainPage.Name = "MainPage"
    MainPage.Parent = Page
    MainPage.BackgroundTransparency = 1
    MainPage.Size = UDim2.new(1, 0, 1, 0)

    local PageList = Instance.new("Folder")
    PageList.Name = "PageList"
    PageList.Parent = MainPage

    MakeDraggable(Top, OutlineMain)

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Insert then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    local DragButton = Instance.new("TextButton")
    DragButton.Name = "DragButton"
    DragButton.Parent = OutlineMain -- Cambiar parent a OutlineMain para respetar UIScale
    DragButton.Position = UDim2.new(1, 0, 1, 0)
    DragButton.AnchorPoint = Vector2.new(1, 1)
    DragButton.Size = UDim2.new(0, 20, 0, 20)
    DragButton.BackgroundTransparency = 1
    DragButton.Text = ""
    DragButton.ZIndex = 10
    CreateRounded(DragButton, 99)

    local Dragging = false
    local StartPos, StartSize

    DragButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
             StartPos = input.Position
            StartSize = OutlineMain.AbsoluteSize
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - StartPos
            local newWidth = math.clamp(StartSize.X + delta.X, WindowConfig.Size.X.Offset, 1920) -- Limitar tamaño máximo
            local newHeight = math.clamp(StartSize.Y + delta.Y, WindowConfig.Size.Y.Offset, 1080)
            OutlineMain.Size = UDim2.new(0, newWidth, 0, newHeight)
            Main.Size = UDim2.new(1, -15, 1, -15)
            Page.Size = UDim2.new(0, newWidth - WindowConfig.TabWidth - 25, 0, newHeight - 48)
            SidebarScroll.Size = UDim2.new(0, WindowConfig.TabWidth, 0, newHeight - 48)
        end
    end)

    local defaultSize = true
    ResizeButton.MouseButton1Click:Connect(function()
        local minWidth = 600 -- Igual que NewResizeHandle
        local maxWidth = 1280 -- Igual que NewResizeHandle
         local minHeight = WindowConfig.Size.Y.Offset or 400 -- Igual que NewResizeHandle
        local maxHeight = 576 -- Igual que NewResizeHandle
        local maxScaleWidth = 900 -- Igual que NewResizeHandle
        local minImageScale = 1.0 -- Igual que NewResizeHandle
        local maxImageScale = 1.38 -- Igual que NewResizeHandle
        local minTextScale = 1.0 -- Igual que NewResizeHandle
        local maxTextScale = 1.5 -- Igual que NewResizeHandle

        -- Definir el TweenInfo para todas las animaciones
        local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        if defaultSize then
            defaultSize = false
            local newWidth = maxWidth -- Ancho objetivo al maximizar
            local newHeight = maxHeight

            -- Calcular el factor de escala dinámico (igual que NewResizeHandle)
            local t
            if newWidth <= maxScaleWidth then
                t = (newWidth - minWidth) / (maxScaleWidth - minWidth)
            else
                t = 1
             end
            local adjustedT = t -- No se aplica math.sqrt ni 0.8 porque es maximización

            local imageScaleFactor = minImageScale + (maxImageScale - minImageScale) * adjustedT
            local textScaleFactor = minTextScale + (maxTextScale - minTextScale) * adjustedT

            -- Animar OutlineMain
            TweenService:Create(OutlineMain, tweenInfo, {
                Position = UDim2.new(0.5, 0, 0.45, 0),
                Size = UDim2.new(0, newWidth, 0, newHeight)
            }):Play()

            -- Animar Main
            TweenService:Create(Main, tweenInfo, {
                Size = UDim2.new(1, -15, 1, -15)
            }):Play()

            -- Animar Page
            TweenService:Create(Page, tweenInfo, {
                Size = UDim2.new(0, newWidth - WindowConfig.TabWidth - 25, 0, newHeight - 48)
            }):Play()

            -- Animar SidebarScroll
                 TweenService:Create(SidebarScroll, tweenInfo, {
                Size = UDim2.new(0, WindowConfig.TabWidth, 0, newHeight - 48)
            }):Play()

            -- Animar imágenes
            for element, baseSize in pairs(imageElements) do
                TweenService:Create(element, tweenInfo, {
                     Size = UDim2.new(
                        baseSize.X.Scale, baseSize.X.Offset * imageScaleFactor,
                        baseSize.Y.Scale, baseSize.Y.Offset * imageScaleFactor
                    )
                 }):Play()
            end

            -- Animar textos
            for element, baseTextSize in pairs(textElements) do
                TweenService:Create(element, tweenInfo, {
                    TextSize = baseTextSize * textScaleFactor
                 }):Play()
            end

            -- Ajustar UIStroke
            local scale = OutlineMain:FindFirstChild("UIScale") and OutlineMain.UIScale.Scale or 1
            for _, element in pairs({OutlineMain, Main}) do
                local stroke = element:FindFirstChildOfClass("UIStroke")
                 if stroke then
                    TweenService:Create(stroke, tweenInfo, {
                        Thickness = math.max(1, 2 / scale)
                    }):Play()
                 end
             end

            ResizeButton.Image = "rbxassetid://10734895698"
        else
            defaultSize = true
            local newWidth = WindowConfig.Size.X.Offset or minWidth -- Ancho objetivo al restaurar
            local newHeight = WindowConfig.Size.Y.Offset or minHeight

            -- Calcular el factor de escala dinámico (igual que NewResizeHandle)
            local t
            if newWidth <= maxScaleWidth then
                t = (newWidth - minWidth) / (maxScaleWidth - minWidth)
            else
                t = 1
            end
             local adjustedT = math.sqrt(t) * (newWidth <= minWidth + 50 and 0.8 or 1) -- Ajuste suave para disminución

            local imageScaleFactor = minImageScale + (maxImageScale - minImageScale) * adjustedT
            local textScaleFactor = minTextScale + (maxTextScale - minTextScale) * adjustedT

            -- Animar OutlineMain
            TweenService:Create(OutlineMain, tweenInfo, {
                 Position = UDim2.new(0.5, 0, 0.45, 0), -- Restaurar posición centrada
                Size = UDim2.new(0, newWidth, 0, newHeight)
            }):Play()

            -- Animar Main
            TweenService:Create(Main, tweenInfo, {
                Size = UDim2.new(1, -15, 1, -15)
            }):Play()

            -- Animar Page
            TweenService:Create(Page, tweenInfo, {
                Size = UDim2.new(0, newWidth - WindowConfig.TabWidth - 25, 0, newHeight - 48)
            }):Play()

            -- Animar SidebarScroll
                 TweenService:Create(SidebarScroll, tweenInfo, {
                Size = UDim2.new(0, WindowConfig.TabWidth, 0, newHeight - 48)
            }):Play()

            -- Animar imágenes
            for element, baseSize in pairs(imageElements) do
                TweenService:Create(element, tweenInfo, {
                     Size = UDim2.new(
                        baseSize.X.Scale, baseSize.X.Offset * imageScaleFactor,
                        baseSize.Y.Scale, baseSize.Y.Offset * imageScaleFactor
                    )
                 }):Play()
            end

            -- Animar textos
            for element, baseTextSize in pairs(textElements) do
                TweenService:Create(element, tweenInfo, {
                    TextSize = baseTextSize * textScaleFactor
                 }):Play()
            end

            -- Ajustar UIStroke
            local scale = OutlineMain:FindFirstChild("UIScale") and OutlineMain.UIScale.Scale or 1
            for _, element in pairs({OutlineMain, Main}) do
                local stroke = element:FindFirstChildOfClass("UIStroke")
                 if stroke then
                    TweenService:Create(stroke, tweenInfo, {
                        Thickness = math.max(1, 2 / scale)
                    }):Play()
                end
             end

            ResizeButton.Image = "rbxassetid://10734886735"
        end
    end)

    local currentPage = "Inicio"
    local searchQuery = ""

    local function ChangePage(newPage)
    currentPage = newPage
    for _, page in pairs(PageList:GetChildren()) do
        if page:IsA("Frame") or page:IsA("ScrollingFrame") then
            page.Visible = (page.Name == newPage .. "_Page")
        end
    end

    -- Lógica corregida para encontrar los botones y las barras
    for _, borderFrame in pairs(SidebarScroll:GetChildren()) do
        -- Buscamos el botón DENTRO del marco de borde que creamos
        if borderFrame:IsA("Frame") and borderFrame.Name:match("_Border$") then
            local button = borderFrame:FindFirstChildOfClass("TextButton")
            if button then
                local isActive = (button.Name == newPage .. "Btn")

                -- Buscamos la barrita DENTRO del botón y la hacemos visible/invisible
                local indicator = button:FindFirstChild("IndicatorBar")
                if indicator then
                    indicator.Visible = isActive
                end

                -- También mantenemos el cambio de color del texto
                local label = button:FindFirstChild("Label")
                if label then
                    label.TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
                end
            end
        end
    end
end

local function CreateCategory(parent, name, icon, layoutOrder)
    local CategoryBtn = Instance.new("TextButton")
    CategoryBtn.Name = name .. "Btn"
    Size = UDim2.new(1, 0, 0, 30)
    CategoryBtn.Parent = parent
    CreateRounded(CategoryBtn, 30)
    CategoryBtn.Size = UDim2.new(0.99, 0, 0, 40)
    CategoryBtn.BackgroundTransparency = 0
    CategoryBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    CategoryBtn.BorderSizePixel = 0
    CategoryBtn.Text = ""
    CategoryBtn.LayoutOrder = layoutOrder
    CategoryBtn.AutoButtonColor = false
    CreateRounded(CategoryBtn, 12)

    local CategoryIcon = Instance.new("ImageLabel")
    CategoryIcon.Name = "Icon"
    CategoryIcon.Parent = CategoryBtn
    CategoryIcon.AnchorPoint = Vector2.new(0, 0.5)
    CategoryIcon.Position = UDim2.new(0.04, 0, 0.5, -2)
    CategoryIcon.Size = UDim2.new(0, 25, 0, 25)
    CategoryIcon.BackgroundTransparency = 1
    CategoryIcon.Image = icon or "rbxthumb://type=Asset&id=6031154871&w=200&h=200"
    CategoryIcon.ScaleType = Enum.ScaleType.Fit
    CategoryIcon.ImageTransparency = 0

    local IndicatorBar = Instance.new("Frame")
    IndicatorBar.Name = "IndicatorBar"
    IndicatorBar.Parent = CategoryBtn
    IndicatorBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    IndicatorBar.Size = UDim2.new(0, 1, 0.7, 0)
    IndicatorBar.Position = UDim2.new(0, 1, 0.5, -2.9)
    IndicatorBar.AnchorPoint = Vector2.new(1, 0.5)
    IndicatorBar.BackgroundTransparency = 0
    IndicatorBar.Visible = (name == "Inicio") -- Controlamos la visibilidad al crear
    CreateRounded(IndicatorBar, 2)

    local CategoryLabel = Instance.new("TextLabel")
    CategoryLabel.Name = "Label"
    CategoryLabel.Parent = CategoryBtn
    CategoryLabel.Position = UDim2.new(0.28, 10, 0, 0)
    CategoryLabel.Size = UDim2.new(0.67, 0, 1, 0)
    CategoryLabel.BackgroundTransparency = 1
    CategoryLabel.Text = name
    CategoryLabel.TextColor3 = (name == "Inicio") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    CategoryLabel.TextSize = 14
    CategoryLabel.Font = Enum.Font.GothamBold
    CategoryLabel.TextXAlignment = Enum.TextXAlignment.Left

    local stroke = CategoryBtn:FindFirstChild("FadedShadow")
    if stroke then
        stroke.Thickness = (name == "Inicio") and 6 or 4
    end

    CategoryBtn.MouseButton1Click:Connect(function()
        ChangePage(name)
    end)

    return CategoryBtn
end

    -- =========================================================
    -- =========================================================


     -- =========================================================
    -- CREACION DE TARJETAS (SCRIPTS)
    -- =========================================================

    local function CreateScriptCard(parent, data)
        local Card = Instance.new("Frame")
        Card.Name = data.name
        Card.Parent = parent
        Card.BackgroundColor3 = _G.LighterDark
        Card.BackgroundTransparency = 0
        Card.BorderSizePixel = 0
        CreateRounded(Card, 8)

         local CardStroke = Instance.new("UIStroke")
        CardStroke.Parent = Card
        CardStroke.Color = Color3.fromRGB(70, 70, 70)
        CardStroke.Thickness = 1
        CardStroke.Transparency = 0.5

        local ScriptImage = Instance.new("ImageLabel")
        ScriptImage.Name = "ScriptImage"
        ScriptImage.Parent = Card
        ScriptImage.Position = UDim2.new(0.05, 0, 0.05, 0)
         ScriptImage.Size = UDim2.new(0.9, 0, 0.5, 0)
        ScriptImage.BackgroundColor3 = _G.Dark
        ScriptImage.BackgroundTransparency = 0
        ScriptImage.Image = data.image or "rbxassetid://10723415903"
        ScriptImage.ScaleType = Enum.ScaleType.Crop
        CreateRounded(ScriptImage, 8)

        local ScriptTitle = Instance.new("TextLabel")
        ScriptTitle.Name = "ScriptTitle"
        ScriptTitle.Parent = Card
         ScriptTitle.Position = UDim2.new(0.05, 0, 0.6, 0)
        ScriptTitle.Size = UDim2.new(0.9, 0, 0.15, 0)
        ScriptTitle.BackgroundTransparency = 1
        ScriptTitle.Text = data.name
        ScriptTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        ScriptTitle.TextSize = 14
        ScriptTitle.Font = Enum.Font.GothamBold
        ScriptTitle.TextXAlignment = Enum.TextXAlignment.Left
        ScriptTitle.TextWrapped = true

          local Description = Instance.new("TextLabel")
        Description.Name = "Description"
        Description.Parent = Card
        Description.Position = UDim2.new(0.05, 0, 0.8, 0)
        Description.Size = UDim2.new(0.9, 0, 0.15, 0)
        Description.BackgroundTransparency = 1
        Description.Text = data.desc or "Este es un ejemplo de funcionalidad"
        Description.TextColor3 = Color3.fromRGB(200, 200, 200)
        Description.TextSize = 10
        Description.Font = Enum.Font.Gotham
        Description.TextXAlignment = Enum.TextXAlignment.Left
        Description.TextWrapped = true

        local ExecuteBtn = Instance.new("TextButton")
        ExecuteBtn.Name = "ExecuteBtn"
        ExecuteBtn.Parent = Card
        ExecuteBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
        ExecuteBtn.Size = UDim2.new(0.9, 0, 0.15, 0)
        ExecuteBtn.BackgroundColor3 = _G.Third
         ExecuteBtn.Text = "Ejecutar"
        ExecuteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ExecuteBtn.TextSize = 12
        ExecuteBtn.Font = Enum.Font.Gotham
        ExecuteBtn.BorderSizePixel = 0
        CreateRounded(ExecuteBtn, 8)

        ExecuteBtn.MouseEnter:Connect(function()
            TweenService:Create(ExecuteBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 140, 255)}):Play()
        end)

         ExecuteBtn.MouseLeave:Connect(function()
            TweenService:Create(ExecuteBtn, TweenInfo.new(0.2), {BackgroundColor3 = _G.Third}):Play()
        end)

        ExecuteBtn.MouseButton1Click:Connect(function()
            local success, err = pcall(data.callback or function()
                Update:Notify("Ejecutando " .. data.name)
            end)
            if not success then
                 StarterGui:SetCore("SendNotification", {
                    Title = "Error",
                    Text = "Fallo al ejecutar " .. data.name .. ": " .. err,
                    Duration = 5
             })
            end
        end)

        return Card
    end
    
    -- =========================================================
    -- =========================================================


    -- =======================================================
    -- FUNCION CREACION DE PAGINAS
    -- =======================================================


    function CreateContentPage(name)
        local ContentPage = Instance.new("ScrollingFrame")
        ContentPage.Name = name .. "_Page"
          ContentPage.Parent = PageList
        ContentPage.Active = true
        ContentPage.BackgroundTransparency = 1
        ContentPage.Size = UDim2.new(1, 0, 1, 0)
        ContentPage.ScrollBarThickness = 1
        ContentPage.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
        ContentPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        -- YA NO USAMOS ESTO: ContentPage.AutomaticCanvasSize = name == "Inicio" and Enum.AutomaticSize.None or Enum.AutomaticSize.Y
         ContentPage.ScrollingDirection = Enum.ScrollingDirection.Y
        ContentPage.Visible = false

        if name ~= "Inicio" then
            local contentLayout = Instance.new("UIListLayout", ContentPage)
            contentLayout.Padding = UDim.new(0, 10)
            contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

            local SearchFrame = Instance.new("Frame")
            SearchFrame.Name = "SearchFrame"
            SearchFrame.Parent = ContentPage
            SearchFrame.LayoutOrder = 1
            SearchFrame.Size = UDim2.new(0.96, 0, 0, 40)
            SearchFrame.BackgroundColor3 = _G.LighterDark
            SearchFrame.BackgroundTransparency = SettingsLib.MainTransparency -- Controlado por slider principal
             SearchFrame.BorderSizePixel = 0
            CreateRounded(SearchFrame, 8)

            local SearchBox = Instance.new("TextBox")
            SearchBox.Name = "SearchBox"
            SearchBox.Parent = SearchFrame
            SearchBox.Position = UDim2.new(0.04, 0, 0, 0)
            SearchBox.Size = UDim2.new(0.88, 0, 1, 0)
             SearchBox.BackgroundTransparency = 1
            SearchBox.Text = ""
            SearchBox.PlaceholderText = "Buscar en " .. name .. "..."
            SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
            SearchBox.TextSize = 14
             SearchBox.Font = Enum.Font.Gotham
            SearchBox.TextXAlignment = Enum.TextXAlignment.Left

            local SearchIcon = Instance.new("ImageLabel")
            SearchIcon.Name = "SearchIcon"
            SearchIcon.Parent = SearchFrame
            SearchIcon.AnchorPoint = Vector2.new(1, 0.5)
            SearchIcon.Position = UDim2.new(1, -5, 0.5, 0)
             SearchIcon.Size = UDim2.new(0, 20, 0, 20)
            SearchIcon.BackgroundTransparency = 1
            SearchIcon.Image = "rbxassetid://6031154871"
            SearchIcon.ScaleType = Enum.ScaleType.Fit

            local ScriptsArea = Instance.new("Frame")
            ScriptsArea.Name = "ScriptsArea"
            ScriptsArea.Parent = ContentPage
              ScriptsArea.LayoutOrder = 2
            ScriptsArea.Size = UDim2.new(0.96, 0, 0, 0) -- Se pone en 0 para que el layout decida la altura.
            ScriptsArea.AutomaticSize = Enum.AutomaticSize.Y -- Hacemos que la altura de este frame sea automática.
            ScriptsArea.BackgroundTransparency = 1

            -- [[ MODIFICACIÓN CLAVE ]]
            -- Llamamos a nuestro sistema para que esta página sea dinámica.
            -- Esto reemplaza la necesidad de poner lógica de CanvasSize en otros lugares.
            local forceUpdateCanvas = AutoCanvasManager:setup(ContentPage)

            return ContentPage, SearchBox, forceUpdateCanvas
        end

        return ContentPage, nil, function() end -- Devuelve función vacía para "Inicio"
    end
    -- =======================================================
    -- =======================================================


    -- =======================================================
    -- FUNCION: LOADSCRIPT
    -- =======================================================

    local function LoadScripts(category, scriptsArea, searchBox)
        -- Limpiar contenido anterior
        for _, child in pairs(scriptsArea:GetChildren()) do
            if child:IsA("Frame") or child:IsA("UIGridLayout") or child:IsA("UIListLayout") or child:IsA("UIPadding") then
                child:Destroy()
            end
        end
        
       -- =======================================================
       -- =======================================================
       
-- =======================================================
     -- CREACION DE CATEGORIAS
       -- =======================================================
        

        if category == "Editor" then
        scriptsArea.Parent.Active = false

            --[[ MODIFICACIÓN #1.1: ELIMINAR BUSCADOR ANTIGUO ]]
              -- Esta línea busca y elimina el buscador genérico que se creaba por defecto en la página.
            local genericSearch = scriptsArea.Parent:FindFirstChild("SearchFrame")
            if genericSearch then
                genericSearch:Destroy()
            end

            -- MODIFICACIÓN: Contenedor de todas las tarjetas para el buscador
            local allCharacterCards = {}

            -- Gestión de conexiones para evitar memory leaks
            if _G.conexiones then
                for _, conn in ipairs(_G.conexiones) do
                    conn:Disconnect()
                end
            end
            _G.conexiones = {}

            scriptsArea.Parent.AutomaticCanvasSize = Enum.AutomaticSize.None -- Lo controlaremos manualmente
            local listLayout = Instance.new("UIListLayout", scriptsArea)
            listLayout.Padding = UDim.new(0, 15)
            listLayout.SortOrder = Enum.SortOrder.LayoutOrder
            listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

            local cuerpoIDs = { BrazoDerecho=nil, Torso=nil, BrazoIzquierdo=nil, PiernaDerecha=nil, PiernaIzquierda=nil, Cabeza=nil }
            local textboxes = {}
            local textboxOrder = {"Cabeza", "Torso", "BrazoDerecho", "BrazoIzquierdo", "PiernaDerecha", "PiernaIzquierda"}
            
            local function aplicarCuerpo()
                pcall(function()
                    local player = Players.LocalPlayer
                     local char = player.Character or player.CharacterAdded:Wait()
                    local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 5)
                    if not remotes then
                        Update:Notify("  Error: No se encontraron los remotes.")
                         return
                    end
                    
                    remotes.ChangeCharacterBody:InvokeServer({0, 0, 0, 0, 0, 0})
                    wait(0.6)

                    local nuevo = {
                        cuerpoIDs["BrazoDerecho"] or 0,
                        cuerpoIDs["Torso"] or 0,
                        cuerpoIDs["BrazoIzquierdo"] or 0,
                        cuerpoIDs["PiernaDerecha"] or 0,
                        cuerpoIDs["PiernaIzquierda"] or 0,
                        cuerpoIDs["Cabeza"] or 0
                    }
                    remotes.ChangeCharacterBody:InvokeServer(nuevo)
                    wait(0.5)
                    Update:Notify("  Personaje actualizado")
                end)
            end
             
            local function crearTitulo(texto, orden)
                local titleFrame = Instance.new("Frame", scriptsArea)
                titleFrame.Size = UDim2.new(0.95, 0, 0, 35)
                titleFrame.BackgroundTransparency = 1
                titleFrame.LayoutOrder = orden
            
                local label = Instance.new("TextLabel", titleFrame)
                label.Size = UDim2.new(1, 0, 1, -5)
                label.Position = UDim2.new(0,0,0,0)
                label.BackgroundTransparency = 1
                 label.Text = texto
                label.Font = Enum.Font.GothamBold
                label.TextSize = 24
                label.TextColor3 = Color3.new(1, 1, 1)
                label.TextXAlignment = Enum.TextXAlignment.Left

                local underline = Instance.new("Frame", label)
                underline.Size = UDim2.new(1, 0, 0, 3)
                underline.Position = UDim2.new(0, 0, 1, 0)
                underline.BackgroundColor3 = _G.Primary
                underline.BorderSizePixel = 0
                ApplyDefaultGradient(underline)

                 return titleFrame
            end

            local btnCaras = Instance.new("TextButton", scriptsArea)
            btnCaras.Size = UDim2.new(0.95, 0, 0, 40)
            btnCaras.BackgroundColor3 = _G.LighterDark
            btnCaras.BackgroundTransparency = SettingsLib.MainTransparency -- Controlado por slider principal
             btnCaras.Text = "  Caras VIP Gratis"
            btnCaras.Font = Enum.Font.GothamBold
            btnCaras.TextSize = 16
            btnCaras.TextColor3 = Color3.new(1, 1, 1)
            btnCaras.LayoutOrder = 0
            CreateRounded(btnCaras, 8)
            CreateGlowStroke(btnCaras)
             
            -- Image for VIP Faces button
            local carasImage = Instance.new("ImageLabel")
            carasImage.Name = "CarasVIPImage"
            carasImage.Parent = btnCaras
            carasImage.Size = UDim2.new(0, 25, 0, 25) 
            carasImage.Position = UDim2.new(0, 5, 0.5, 0) -- Ajuste para la esquina
            carasImage.AnchorPoint = Vector2.new(0, 0.5)
            carasImage.BackgroundTransparency = 1
            carasImage.Image = "rbxthumb://type=Asset&id=12786639363&w=150&h=150"
            carasImage.ScaleType = Enum.ScaleType.Fit
            carasImage.ZIndex = btnCaras.ZIndex + 1

            local carasConn = btnCaras.MouseButton1Click:Connect(function()
                  pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/xkindg/Anonimo/refs/heads/main/x"))()
                    Update:Notify("  Script de Caras VIP ejecutado")
                end)
            end)
             table.insert(_G.conexiones, carasConn)

            crearTitulo("   Editor de partes ", 1)

            local editorContainer = Instance.new("Frame", scriptsArea)
            editorContainer.BackgroundTransparency = 1
            editorContainer.Size = UDim2.new(0.95, 0, 0, 150)
            editorContainer.LayoutOrder = 2
            local editorLayout = Instance.new("UIGridLayout", editorContainer)
              editorLayout.CellSize = UDim2.new(0.48, 0, 0, 40)
            editorLayout.CellPadding = UDim2.new(0.04, 0, 0.04, 0)
            editorLayout.SortOrder = Enum.SortOrder.LayoutOrder
            editorLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            
            -- [[ FUNCIÓN MODIFICADA ]]
            -- Se acelera la animación para un efecto de degradado más notorio.
            local function AnimateAndStyleTextbox(textbox)
                textbox.Font = Enum.Font.Sarpanch
                local color_rosa_rojo = Color3.fromRGB(255, 20, 80)
                local color_azul_claro = Color3.fromRGB(0, 170, 255)
                textbox.TextColor3 = color_rosa_rojo
                spawn(function()
                    while textbox and textbox.Parent do
                        -- Se reduce el tiempo de 1.2 a 0.8 para una transición más rápida.
                        local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                        local tweenAzul = TweenService:Create(textbox, tweenInfo, {TextColor3 = color_azul_claro})
                        tweenAzul:Play()
                        tweenAzul.Completed:Wait()
                        if not (textbox and textbox.Parent) then break end
                        local tweenRosa = TweenService:Create(textbox, tweenInfo, {TextColor3 = color_rosa_rojo})
                        tweenRosa:Play()
                        tweenRosa.Completed:Wait()
                    end
                end)
            end

            for i, key in ipairs(textboxOrder) do
                local nombre = key:gsub("([A-Z])", " %1"):match("^%s*(.-)$")
                local campo = Instance.new("TextBox", editorContainer)
                campo.Size = UDim2.new(1, 0, 1, 0)
                campo.BackgroundColor3 = _G.Dark
                campo.BackgroundTransparency = SettingsLib.MainTransparency -- Controlado por slider principal
                campo.Text = ""
                campo.PlaceholderText = "ID de " .. string.lower(nombre)
                campo.PlaceholderColor3 = Color3.new(0.7, 0.7, 0.7)
                -- [[ TAMAÑO MODIFICADO ]]
                -- Se aumenta el tamaño de 16 a 21 (un 30% más grande).
                campo.TextSize = 21 
                campo.LayoutOrder = i
                CreateRounded(campo, 8)
                CreateGlowStroke(campo)
                AnimateAndStyleTextbox(campo)
                local focusLostConn = campo.FocusLost:Connect(function()
                    cuerpoIDs[key] = tonumber(campo.Text) or nil
                end)
                table.insert(_G.conexiones, focusLostConn)
                textboxes[key] = campo
            end

            local actionButtonsContainer = Instance.new("Frame", scriptsArea)
            actionButtonsContainer.BackgroundTransparency = 1
            actionButtonsContainer.Size = UDim2.new(0.95, 0, 0, 40)
            actionButtonsContainer.LayoutOrder = 3
            local actionButtonsLayout = Instance.new("UIGridLayout", actionButtonsContainer)
            actionButtonsLayout.CellSize = UDim2.new(0.48, 0, 1, 0)
            actionButtonsLayout.CellPadding = UDim2.new(0.04, 0, 0, 0)
            
             local aplicarBtn = Instance.new("TextButton", actionButtonsContainer)
            aplicarBtn.BackgroundColor3 = _G.Primary
            aplicarBtn.Text = "APLICAR"
            aplicarBtn.Font = Enum.Font.GothamBold
            aplicarBtn.TextSize = 16
            aplicarBtn.TextColor3 = Color3.new(1, 1, 1)
            CreateRounded(aplicarBtn, 8)
            ApplyDefaultGradient(aplicarBtn) -- Apply gradient
            local aplicarBtnText = Instance.new("TextLabel")
            aplicarBtnText.Parent = aplicarBtn
            aplicarBtnText.Size = UDim2.new(1, 0, 1, 0)
            aplicarBtnText.BackgroundTransparency = 1
            aplicarBtnText.Text = "APLICAR"
            aplicarBtnText.Font = Enum.Font.GothamBold
            aplicarBtnText.TextSize = 16
            aplicarBtnText.TextColor3 = Color3.new(1, 1, 1)
            aplicarBtnText.TextXAlignment = Enum.TextXAlignment.Center
            aplicarBtnText.TextYAlignment = Enum.TextYAlignment.Center
            aplicarBtnText.ZIndex = aplicarBtn.ZIndex + 1
            local aplicarConn = aplicarBtn.MouseButton1Click:Connect(aplicarCuerpo)
            table.insert(_G.conexiones, aplicarConn)

            local vaciarBtn = Instance.new("TextButton", actionButtonsContainer)
            vaciarBtn.BackgroundColor3 = _G.Secondary
            vaciarBtn.Text = "VACIAR"
            vaciarBtn.Font = Enum.Font.GothamBold
            vaciarBtn.TextSize = 16
            vaciarBtn.TextColor3 = Color3.new(1, 1, 1)
            CreateRounded(vaciarBtn, 8)
            ApplyDefaultGradient(vaciarBtn) -- Apply gradient
            local vaciarBtnText = Instance.new("TextLabel")
            vaciarBtnText.Parent = vaciarBtn
            vaciarBtnText.Size = UDim2.new(1, 0, 1, 0)
            vaciarBtnText.BackgroundTransparency = 1
            vaciarBtnText.Text = "VACIAR"
             vaciarBtnText.Font = Enum.Font.GothamBold
            vaciarBtnText.TextSize = 16
            vaciarBtnText.TextColor3 = Color3.new(1, 1, 1)
            vaciarBtnText.TextXAlignment = Enum.TextXAlignment.Center
            vaciarBtnText.TextYAlignment = Enum.TextYAlignment.Center
            vaciarBtnText.ZIndex = vaciarBtn.ZIndex + 1
            local vaciarConn = vaciarBtn.MouseButton1Click:Connect(function()
                  for _, tb in pairs(textboxes) do tb.Text = "" end
                for k in pairs(cuerpoIDs) do cuerpoIDs[k] = nil end
                Update:Notify(" Códigos limpiados")
            end)
            table.insert(_G.conexiones, vaciarConn)

            crearTitulo(" Personajes ", 4)
            
            -- =======================================================
            -- [[ BUSCADOR CON ICONO ]]
            -- =======================================================

            local searchFrame = Instance.new("Frame", scriptsArea)
            searchFrame.Size = UDim2.new(0.95, 0, 0, 40)
              searchFrame.BackgroundColor3 = _G.Dark
            searchFrame.BackgroundTransparency = SettingsLib.MainTransparency -- Controlado por slider principal
            searchFrame.LayoutOrder = 5
            CreateRounded(searchFrame, 8)
            CreateGlowStroke(searchFrame)
            local searchBoxCards = Instance.new("TextBox", searchFrame)
            searchBoxCards.Size = UDim2.new(1, -45, 1, 0)
             searchBoxCards.Position = UDim2.new(0, 10, 0, 0)
            searchBoxCards.BackgroundTransparency = 1
            searchBoxCards.Text = ""
            searchBoxCards.PlaceholderText = "Buscar personaje por nombre..."
            searchBoxCards.TextColor3 = Color3.new(1, 1, 1)
            searchBoxCards.PlaceholderColor3 = Color3.new(0.7, 0.7, 0.7)
             searchBoxCards.Font = Enum.Font.Gotham
            searchBoxCards.TextSize = 25
            searchBoxCards.TextXAlignment = Enum.TextXAlignment.Left
            
            -- [[ MODIFICACIÓN ]]
            -- Se aplica el mismo estilo de texto animado al buscador de personajes.
            AnimateAndStyleTextbox(searchBoxCards)

            local searchIcon = Instance.new("ImageLabel", searchFrame)
            searchIcon.Size = UDim2.new(0, 25, 0, 25)
            searchIcon.AnchorPoint = Vector2.new(1, 0.5)
            searchIcon.Position = UDim2.new(1, -10, 0.5, 0)
            searchIcon.BackgroundTransparency = 1
            searchIcon.Image = "rbxassetid://6031154871"
            searchIcon.ScaleType = Enum.ScaleType.Fit
            
            -- =======================================================
            -- =======================================================

            -- =======================================================
            -- [[ CONTENEDOR DE TARJETAS DINÁMICO ]]
            -- =======================================================
            local tarjetasContainer = Instance.new("Frame", scriptsArea)
            tarjetasContainer.BackgroundTransparency = 1
            tarjetasContainer.Size = UDim2.new(0.95, 0, 0, 0)
            tarjetasContainer.AutomaticSize = Enum.AutomaticSize.Y
            tarjetasContainer.LayoutOrder = 6

            local tarjetasLayout = Instance.new("UIGridLayout", tarjetasContainer)
            tarjetasLayout.CellSize = UDim2.new(0.31, 0, 0, 220)
              tarjetasLayout.CellPadding = UDim2.new(0.035, 0, 0.02, 0)
            tarjetasLayout.SortOrder = Enum.SortOrder.LayoutOrder
            tarjetasLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            
            local function crearVentanaElegirPartes(plantilla)
                local bg = Instance.new("Frame", OutlineMain)
                bg.Name = "VentanaElegirPartesBG"
                bg.Size = UDim2.new(1, 0, 1, 0)
                bg.BackgroundColor3 = Color3.new(0, 0, 0)
                bg.BackgroundTransparency = 1
                bg.ZIndex = 200 

                local frame = Instance.new("Frame", bg)
                frame.Size = UDim2.new(0, 400, 0, 300) -- Mismo tamaño que SettingsFrame
                frame.AnchorPoint = Vector2.new(0.5, 0.5)
                frame.Position = UDim2.new(0.5, 0, 0.5, 0)
                frame.BackgroundColor3 = _G.LighterDark
                frame.BackgroundTransparency = 0
                CreateRounded(frame, 12)
                
                local titulo = Instance.new("TextLabel", frame)
                titulo.Size = UDim2.new(1, -50, 0, 30)
                titulo.Position = UDim2.new(0, 15, 0, 10)
                titulo.BackgroundTransparency = 1
                titulo.Text = "Elige partes de: " .. plantilla.nombre
                titulo.TextColor3 = Color3.new(1, 1, 1)
                titulo.Font = Enum.Font.GothamBold
                titulo.TextSize = 18
                titulo.TextXAlignment = Enum.TextXAlignment.Left

                local scroll = Instance.new("ScrollingFrame", frame)
                scroll.Size = UDim2.new(1, -10, 1, -50)
                scroll.Position = UDim2.new(0, 5, 0, 45)
                scroll.BackgroundTransparency = 1
                scroll.ScrollBarThickness = 5
                scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
                scroll.CanvasSize = UDim2.new(0,0,0,0)
                
                local layout = Instance.new("UIGridLayout", scroll)
                layout.CellSize = UDim2.new(0, 120, 0, 120)
                layout.CellPadding = UDim2.new(0, 5, 0, 5)
                layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                
                local partesOrdenadas = {"Cabeza", "Torso", "BrazoDerecho", "BrazoIzquierdo", "PiernaDerecha", "PiernaIzquierda"}
                for _, k in ipairs(partesOrdenadas) do
                    local partId = plantilla.ids[k]
                    if partId then
                        local btnParte = Instance.new("ImageButton", scroll)
                        btnParte.BackgroundColor3 = _G.Dark
                        btnParte.BackgroundTransparency = SettingsLib.MainTransparency -- Controlado por slider principal
                        btnParte.Image = "rbxthumb://type=Asset&id="..tostring(partId).."&w=150&h=150"
                        CreateRounded(btnParte, 10)
                        CreateGlowStroke(btnParte)
                        
                        local btnParteClick = btnParte.MouseButton1Click:Connect(function()
                            if textboxes[k] then
                                  textboxes[k].Text = tostring(partId)
                                cuerpoIDs[k] = partId
                                Update:Notify("  ID de "..k.." pegado")
                                bg:Destroy()
                            end
                        end)
                        table.insert(_G.conexiones, btnParteClick)
                    end
                end

                local btnCerrar = Instance.new("ImageButton", frame)
                btnCerrar.Size = UDim2.new(0, 25, 0, 25)
                btnCerrar.Position = UDim2.new(1, -15, 0, 15)
                btnCerrar.AnchorPoint = Vector2.new(1, 0)
                btnCerrar.BackgroundTransparency = 1
                btnCerrar.Image = "rbxassetid://10747384394"
                btnCerrar.ImageColor3 = Color3.fromRGB(245, 245, 245)
                local cerrarConn = btnCerrar.MouseButton1Click:Connect(function() bg:Destroy() end)
                table.insert(_G.conexiones, cerrarConn)
            end

            local function crearTarjetaPersonaje(plantilla)
                local tarjeta = Instance.new("Frame", tarjetasContainer)
                tarjeta.Name = plantilla.nombre
                tarjeta.BackgroundColor3 = _G.LighterDark
                tarjeta.BackgroundTransparency = SettingsLib.MainTransparency -- Controlado por slider principal
                CreateRounded(tarjeta, 12)
                CreateGlowStroke(tarjeta)

                local titulo = Instance.new("TextLabel", tarjeta)
                titulo.Size = UDim2.new(1, -10, 0, 30)
                titulo.Position = UDim2.new(0.5, 0, 0, 5)
                titulo.AnchorPoint = Vector2.new(0.5, 0)
                titulo.BackgroundTransparency = 1
                titulo.Text = plantilla.nombre
                titulo.Font = Enum.Font.GothamBold
                 titulo.TextColor3 = Color3.new(1,1,1)
                titulo.TextSize = 12

                local imagen = Instance.new("ImageLabel", tarjeta)
                imagen.Size = UDim2.new(1, -20, 0, 120)
                imagen.Position = UDim2.new(0.5, 0, 0, 35)
                  imagen.AnchorPoint = Vector2.new(0.5, 0)
                imagen.BackgroundColor3 = _G.Dark
                imagen.BackgroundTransparency = SettingsLib.MainTransparency -- Controlado por slider principal
                imagen.Image = "rbxthumb://type=Asset&id=80694709922755&w=150&h=150"
                CreateRounded(imagen, 8)

                 local botonColocar = Instance.new("TextButton", tarjeta)
                botonColocar.Size = UDim2.new(1, -20, 0, 28)
                botonColocar.Position = UDim2.new(0.5, 0, 1, -39)
                botonColocar.AnchorPoint = Vector2.new(0.5, 1)
                botonColocar.BackgroundColor3 = _G.Third
                 botonColocar.Text = "Colocar"
                botonColocar.TextColor3 = Color3.new(1,1,1)
                botonColocar.Font = Enum.Font.GothamBold
                botonColocar.TextSize = 16
                CreateRounded(botonColocar, 6)
                ApplyDefaultGradient(botonColocar) -- Apply gradient
                 local botonColocarText = Instance.new("TextLabel")
                botonColocarText.Parent = botonColocar
                botonColocarText.Size = UDim2.new(1, 0, 1, 0)
                botonColocarText.BackgroundTransparency = 1
                botonColocarText.Text = "Colocar"
                  botonColocarText.Font = Enum.Font.GothamBold
                botonColocarText.TextSize = 16
                botonColocarText.TextColor3 = Color3.new(1,1,1)
                botonColocarText.TextXAlignment = Enum.TextXAlignment.Center
                botonColocarText.TextYAlignment = Enum.TextYAlignment.Center
                botonColocarText.ZIndex = botonColocar.ZIndex + 1
                
                local btnColocarClick = botonColocar.MouseButton1Click:Connect(function()
                    for k, v in pairs(plantilla.ids) do
                        if textboxes[k] then
                               textboxes[k].Text = tostring(v)
                            cuerpoIDs[k] = v
                        end
                    end
                       aplicarCuerpo()
                end)
                table.insert(_G.conexiones, btnColocarClick)

                local botonElegir = Instance.new("TextButton", tarjeta)
                botonElegir.Size = UDim2.new(1, -20, 0, 28)
                botonElegir.Position = UDim2.new(0.5, 0, 1, -5)
                botonElegir.AnchorPoint = Vector2.new(0.5, 1)
                botonElegir.BackgroundColor3 = _G.Dark
                botonElegir.BackgroundTransparency = SettingsLib.MainTransparency -- Controlado por slider principal
                botonElegir.Text = "Elegir Partes"
                botonElegir.TextColor3 = Color3.new(1,1,1)
                botonElegir.Font = Enum.Font.GothamBold
                botonElegir.TextSize = 16
                CreateRounded(botonElegir, 6)
                CreateGlowStroke(botonElegir)
                local botonElegirText = Instance.new("TextLabel")
                   botonElegirText.Parent = botonElegir
                botonElegirText.Size = UDim2.new(1, 0, 1, 0)
                botonElegirText.BackgroundTransparency = 1
                botonElegirText.Text = "Elegir Partes"
                botonElegirText.Font = Enum.Font.GothamBold
                botonElegirText.TextSize = 16
                botonElegirText.TextColor3 = Color3.new(1,1,1)
                botonElegirText.TextXAlignment = Enum.TextXAlignment.Center
                botonElegirText.TextYAlignment = Enum.TextYAlignment.Center
                botonElegirText.ZIndex = botonElegir.ZIndex + 1
                
                 local btnElegirClick = botonElegir.MouseButton1Click:Connect(function()
                    crearVentanaElegirPartes(plantilla)
                end)
                table.insert(_G.conexiones, btnElegirClick)
            
                return tarjeta
             end

            for i, plantilla in ipairs(plantillas) do
                local tarjeta = crearTarjetaPersonaje(plantilla)
                tarjeta.LayoutOrder = i
                table.insert(allCharacterCards, tarjeta)
            end
             
            local searchConn = searchBoxCards:GetPropertyChangedSignal("Text"):Connect(function()
                local query = string.lower(searchBoxCards.Text)
                for _, card in ipairs(allCharacterCards) do
                    if query == "" then
                         card.Visible = true
                    else
                        card.Visible = string.find(string.lower(card.Name), query, 1, true)
                    end
                end
                   updateCanvas() -- Actualizamos el tamaño del canvas después de filtrar
            end)
            table.insert(_G.conexiones, searchConn)

    -- =======================================================
    -- HASTA AQUÍ 
    -- =======================================================


elseif category == "Jugador" then
    --[[ ESTE BLOQUE SE HA COMENTADO PARA EVITAR CONFLICTOS
    -- Limpiar conexiones previas
    if _G.conexiones then
        for _, conn in ipairs(_G.conexiones) do
            conn:Disconnect()
        end
    end
    _G.conexiones = {}
    ]]

            
            
            -- Aseguramos que scriptsArea.Parent (la ContentPage) tendrá AutomaticCanvasSize.Y
            scriptsArea.Parent.AutomaticCanvasSize = Enum.AutomaticSize.Y
            local listLayout = Instance.new("UIListLayout", scriptsArea)
            listLayout.Padding = UDim.new(0, 15)
            listLayout.SortOrder = Enum.SortOrder.LayoutOrder
            listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

            local function CreateStyledSlider(parent, name, min, max, current_value, callback, layoutOrder)
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = name .. "Label"
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.AnchorPoint = Vector2.new(0, 0)
                SliderLabel.Size = UDim2.new(0.7, 0, 0, 20)
                SliderLabel.Font = Enum.Font.GothamBold
                SliderLabel.Text = name
                SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                SliderLabel.TextSize = 15 * 1.3
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.ZIndex = 7

                local SliderBar = Instance.new("Frame")
                SliderBar.Name = name .. "SliderBar"
                SliderBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                SliderBar.BackgroundTransparency = 0
                SliderBar.Size = UDim2.new(0.8, 0, 0, 12)
                SliderBar.AnchorPoint = Vector2.new(0.5, 0)
                CreateRounded(SliderBar, 6)
                SliderBar.ZIndex = 7

                local SliderFill = Instance.new("Frame")
                SliderFill.Name = name .. "Fill"
                SliderFill.Parent = SliderBar
                SliderFill.Size = UDim2.new((current_value - min) / (max - min), 0, 1, 0)
                SliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderFill.BackgroundTransparency = 0
                CreateRounded(SliderFill, 6)
                SliderFill.ZIndex = SliderBar.ZIndex + 1

                local Gradient = Instance.new("UIGradient")
                Gradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(1, 94, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 5, 70))
                })
                Gradient.Rotation = 0
                Gradient.Parent = SliderFill

                local SliderHandle = Instance.new("Frame")
                SliderHandle.Name = name .. "Handle"
                SliderHandle.Parent = SliderBar
                SliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderHandle.BackgroundTransparency = 0
                SliderHandle.Position = UDim2.new((current_value - min) / (max - min), 0, 0.5, 0)
                SliderHandle.Size = UDim2.new(0, 16, 0, 16)
                SliderHandle.AnchorPoint = Vector2.new(0.5, 0.5)
                SliderHandle.ZIndex = SliderFill.ZIndex + 1
                CreateRounded(SliderHandle, 8)

                local SliderValueText = Instance.new("TextLabel")
                SliderValueText.Name = name .. "Value"
                SliderValueText.BackgroundTransparency = 1
                SliderValueText.AnchorPoint = Vector2.new(0.5, 0.5)
                SliderValueText.Size = UDim2.new(0, 50 * 1.5, 0, 15 * 1.5)
                SliderValueText.Font = Enum.Font.Gotham
                SliderValueText.Text = tostring(math.floor(current_value))
                SliderValueText.TextColor3 = Color3.fromRGB(200, 200, 200)
                SliderValueText.TextSize = 12 * 1.5
                SliderValueText.TextXAlignment = Enum.TextXAlignment.Center
                SliderValueText.ZIndex = 7

                local isDragging = false
                local function updateSlider(inputPos)
                    local sliderBarAbsoluteSize = SliderBar.AbsoluteSize.X
                    local sliderBarAbsolutePos = SliderBar.AbsolutePosition.X
                    local relativeX = math.clamp((inputPos.X - sliderBarAbsolutePos) / sliderBarAbsoluteSize, 0, 1)
                    
                    local value = min + (max - min) * relativeX
                    value = math.floor(value)

                    SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                    SliderHandle.Position = UDim2.new(relativeX, 0, 0.5, 0)
                    SliderValueText.Text = tostring(value)
                    if callback then
                        callback(value)
                    end
                end

                local handleInputBeganConn = SliderHandle.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDragging = true
                    end
                end)
                table.insert(_G.conexiones, handleInputBeganConn)

                local barInputBeganConn = SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDragging = true
                    end
                end)
                table.insert(_G.conexiones, barInputBeganConn)

                local inputEndedConn = UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDragging = false
                    end
                end)
                table.insert(_G.conexiones, inputEndedConn)

                local inputChangedConn = UserInputService.InputChanged:Connect(function(input)
                    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateSlider(input.Position)
                    end
                end)
                table.insert(_G.conexiones, inputChangedConn)
                
                return SliderLabel, SliderBar, SliderValueText, function() updateSlider(SliderBar.AbsolutePosition + Vector2.new( ((current_value - min) / (max - min)) * SliderBar.AbsoluteSize.X, 0) ) end
            end

            local function CreateStyledToggle(parent, name, default_state, callback, layoutOrder, sliderElements)
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = name .. "Toggle"
                ToggleFrame.Parent = parent

                local baseHeight = 50
                local toggleLabelYOffset = 0
                local toggleButtonYOffset = -15
                local toggleLabelXOffset = 10
                local frameYAdjust = 0 -- Ajuste vertical para el ToggleFrame completo

                if name:match("Forzar") then
                    baseHeight = 140
                    toggleLabelYOffset = -60 + 30 + 50 + 20
                    toggleButtonYOffset = -15 + 40
                    toggleLabelXOffset = 55 + 50 + 50 + 30 + 40
                    frameYAdjust = -50 
                end

                ToggleFrame.Size = UDim2.new(0.95, 0, 0, baseHeight)
                ToggleFrame.Position = UDim2.new(0, 0, 0, frameYAdjust) 

                ToggleFrame.BackgroundColor3 = _G.LighterDark
                ToggleFrame.BackgroundTransparency = SettingsLib.MainTransparency
                ToggleFrame.BorderSizePixel = 0
                ToggleFrame.LayoutOrder = layoutOrder
                ToggleFrame.ZIndex = 10 
                CreateRounded(ToggleFrame, 8)
                CreateGlowStroke(ToggleFrame)

                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Parent = ToggleFrame
                ToggleLabel.Size = UDim2.new(0.6, 0, 1, 0)
                ToggleLabel.Position = UDim2.new(0, toggleLabelXOffset, 0, toggleLabelYOffset)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = name
                ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                ToggleLabel.TextSize = 15
                ToggleLabel.Font = Enum.Font.GothamBold
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.ZIndex = ToggleFrame.ZIndex + 1

                -- Anidar los elementos del slider si se proporcionaron
                if sliderElements then
                    local sliderLabel, sliderBar, sliderValueText, updateSliderInitial = table.unpack(sliderElements)
                    
                    -- Re-parentar los elementos del slider al ToggleFrame
                    sliderLabel.Parent = ToggleFrame
                    sliderBar.Parent = ToggleFrame
                    sliderValueText.Parent = ToggleFrame

                    -- Posicionar el SliderLabel en la esquina superior izquierda del ToggleFrame
                    sliderLabel.Position = UDim2.new(0, 10, 0, 5)
                    sliderLabel.AnchorPoint = Vector2.new(0,0)
                    sliderLabel.Size = UDim2.new(0.7, 0, 0, 20)

                    -- Posicionar el SliderValueText por encima del SliderBar y centrado
                    sliderValueText.Position = UDim2.new(0.5, 0, 0, 30)
                    sliderValueText.AnchorPoint = Vector2.new(0.5,0.5)
                    sliderValueText.Size = UDim2.new(0, 50, 0, 15)

                    -- Posicionar el SliderBar en el centro horizontal del ToggleFrame, 20px más abajo
                    sliderBar.Position = UDim2.new(0.5, 0, 0, 30 + 20 + (sliderValueText.AbsoluteSize.Y / 2))
                    sliderBar.AnchorPoint = Vector2.new(0.5,0)
                    sliderBar.Size = UDim2.new(0.8, 0, 0, 12)

                    -- Llamar a la función de inicialización del slider para que se posicione correctamente
                    updateSliderInitial()
                end


                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Parent = ToggleFrame
                ToggleButton.Size = UDim2.new(0, 60, 0, 30)
                ToggleButton.Position = UDim2.new(1, -70, 0.5, toggleButtonYOffset)
                ToggleButton.BackgroundColor3 = default_state and _G.Primary or Color3.fromRGB(50, 50, 50)
                ToggleButton.Text = ""
                ToggleButton.AutoButtonColor = false
                ToggleButton.BackgroundTransparency = 0
                ToggleButton.ZIndex = ToggleFrame.ZIndex + 1
                CreateRounded(ToggleButton, 15)

                local ToggleCircle = Instance.new("Frame")
                ToggleCircle.Parent = ToggleButton
                ToggleCircle.Size = UDim2.new(0, 24, 0, 24)
                ToggleCircle.Position = default_state and UDim2.new(1, -27, 0.5, -12) or UDim2.new(0, 3, 0.5, -12)
                ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleCircle.BackgroundTransparency = 0
                ToggleCircle.ZIndex = ToggleButton.ZIndex + 1
                CreateRounded(ToggleCircle, 12)

                local toggled = default_state
                local toggleConn = ToggleButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1, -27, 0.5, -12) or UDim2.new(0, 3, 0.5, -12)}):Play()
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = toggled and _G.Primary or Color3.fromRGB(50, 50, 50)}):Play()
                    
                    if callback then
                        callback(toggled)
                    end
                end)
                table.insert(_G.conexiones, toggleConn)

                return ToggleFrame
            end

            local function CreateStyledButton(parent, name, callback, layoutOrder)
                local ButtonFrame = Instance.new("Frame")
                ButtonFrame.Name = name .. "ButtonContainer"
                ButtonFrame.Parent = parent
                ButtonFrame.Size = UDim2.new(0.95, 0, 0, 40)
                ButtonFrame.BackgroundTransparency = 1
                ButtonFrame.LayoutOrder = layoutOrder
                
                local Button = Instance.new("TextButton")
                Button.Parent = ButtonFrame
                Button.Size = UDim2.new(1, 0, 1, 0)
                Button.BackgroundColor3 = _G.Primary
                Button.Text = name
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                Button.TextSize = 16
                Button.Font = Enum.Font.GothamBold
                Button.BorderSizePixel = 0
                Button.BackgroundTransparency = 0
                Button.ZIndex = 5
                CreateRounded(Button, 8)
                ApplyDefaultGradient(Button)

                local buttonText = Instance.new("TextLabel")
                buttonText.Parent = Button
                buttonText.Size = UDim2.new(1, 0, 1, 0)
                buttonText.BackgroundTransparency = 1
                buttonText.Text = name
                buttonText.Font = Enum.Font.GothamBold
                buttonText.TextSize = 16
                buttonText.TextColor3 = Color3.fromRGB(255, 255, 255)
                buttonText.TextXAlignment = Enum.TextXAlignment.Center
                buttonText.TextYAlignment = Enum.TextYAlignment.Center
                buttonText.ZIndex = Button.ZIndex + 1

                local btnConn = Button.MouseButton1Click:Connect(callback)
                table.insert(_G.conexiones, btnConn)
                
                return ButtonFrame
            end

            local function CreateStyledTitle(parent, text, layoutOrder)
                local titleFrame = Instance.new("Frame", parent)
                titleFrame.Size = UDim2.new(0.95, 0, 0, 35)
                titleFrame.BackgroundTransparency = 1
                titleFrame.LayoutOrder = layoutOrder
                titleFrame.ZIndex = 5
            
                local label = Instance.new("TextLabel", titleFrame)
                label.Size = UDim2.new(1, 0, 1, -5)
                label.Position = UDim2.new(0,0,0,0)
                label.BackgroundTransparency = 1
                label.Text = text
                label.Font = Enum.Font.GothamBold
                label.TextSize = 24
                label.TextColor3 = Color3.new(1, 1, 1)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.ZIndex = titleFrame.ZIndex + 1

                local underline = Instance.new("Frame", label)
                underline.Size = UDim2.new(1, 0, 0, 3)
                underline.Position = UDim2.new(0, 0, 1, 0)
                underline.BackgroundColor3 = _G.Primary
                underline.BorderSizePixel = 0
                underline.BackgroundTransparency = 0
                underline.ZIndex = label.ZIndex + 1
                ApplyDefaultGradient(underline)

                return titleFrame
            end

            -- Funciones de hacks con depuración para asegurar activación/desactivación correcta
            local function applyAntisit(character)
                local hum = character:FindFirstChildWhichIsA("Humanoid")
                if not hum then return end

                hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                -- Desconectamos cualquier conexión previa de antisit para evitar duplicados
                if _G.conexiones.antisit_stateChanged then
                    _G.conexiones.antisit_stateChanged:Disconnect()
                    _G.conexiones.antisit_stateChanged = nil
                end
                if SettingsLib.antisit then -- Solo conectar si SettingsLib.antisit es true
                    local antisitConn = hum.StateChanged:Connect(function(old, new)
                        if new == Enum.HumanoidStateType.Seated and SettingsLib.antisit then
                            task.wait(0.1)
                            hum:ChangeState(Enum.HumanoidStateType.Running)
                        end
                    end)
                    _G.conexiones.antisit_stateChanged = antisitConn
                end
            end

            local function removeAntisit(character)
                local hum = character:FindFirstChildWhichIsA("Humanoid")
                if not hum then return end
                
                hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                if _G.conexiones.antisit_stateChanged then
                    _G.conexiones.antisit_stateChanged:Disconnect()
                    _G.conexiones.antisit_stateChanged = nil
                end
            end

            local function toggleAntisit(enabled)
                SettingsLib.antisit = enabled
                if Player.Character then
                    if enabled then
                        applyAntisit(Player.Character)
                    else
                        removeAntisit(Player.Character)
                    end
                end
                Update:Notify("Antisit " .. (enabled and "activado" or "desactivado"))
                getgenv().SaveConfig()
            end

            local function toggleAntivoid(enabled)
                SettingsLib.antivoid = enabled
                if enabled then
                    Workspace.FallenPartsDestroyHeight = 0/0 -- Revertido a 0/0 (NaN)
                else
                    Workspace.FallenPartsDestroyHeight = defaultValues.fallenPartsHeight
                end
                Update:Notify("Antivoid " .. (enabled and "activado" or "desactivado"))
                getgenv().SaveConfig()
            end

            local function toggleNoclip(enabled)
                SettingsLib.noclip = enabled
                if enabled and not _G.conexiones.noclip_stepped then
                    local noclipConn = RunService.Stepped:Connect(function()
                        if SettingsLib.noclip and Player.Character then
                            for _, v in pairs(Player.Character:GetChildren()) do
                                if v:IsA("BasePart") then
                                    v.CanCollide = false
                                end
                            end
                        end
                    end)
                    _G.conexiones.noclip_stepped = noclipConn
                elseif not enabled and _G.conexiones.noclip_stepped then
                    _G.conexiones.noclip_stepped:Disconnect(); _G.conexiones.noclip_stepped = nil
                    if Player.Character then
                        for _, v in pairs(Player.Character:GetChildren()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = true
                            end
                        end
                    end
                end
                Update:Notify("Noclip " .. (enabled and "activado" or "desactivado"))
                getgenv().SaveConfig()
            end

            local infJumpDebounce = false 
            local function toggleInfiniteJump(enabled)
                SettingsLib.infiniteJump = enabled
                if enabled and not _G.conexiones.infiniteJump_jumpRequest then
                    local jumpConn = UserInputService.JumpRequest:Connect(function()
                        local currentHumanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
                        if SettingsLib.infiniteJump and not infJumpDebounce and currentHumanoid then
                            infJumpDebounce = true
                            currentHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                            task.wait()
                            infJumpDebounce = false
                        end
                    end)
                    _G.conexiones.infiniteJump_jumpRequest = jumpConn
                elseif not enabled and _G.conexiones.infiniteJump_jumpRequest then
                    _G.conexiones.infiniteJump_jumpRequest:Disconnect(); _G.conexiones.infiniteJump_jumpRequest = nil
                end
                Update:Notify("Salto Infinito " .. (enabled and "activado" or "desactivado"))
                getgenv().SaveConfig()
            end
            
            -- REVISADO: Lógica de re-aplicación de hacks al reaparecer el personaje
            local function resetAndReapplyHacks(character)
                -- Asegurarse de que el humanoid esté actualizado y esperar si es necesario
                humanoid = character:FindFirstChildOfClass("Humanoid") -- Actualizar la referencia global
                if not humanoid then 
                    local success, newHumanoid = pcall(function() return character:WaitForChild("Humanoid", 5) end)
                    if success and newHumanoid then
                        humanoid = newHumanoid
                    else
                        warn("Humanoid not found after character added for resetAndReapplyHacks.")
                        return
                    end
                end

                -- Desconectar explícitamente las conexiones persistentes asociadas al Humanoid anterior
                -- Esto es crucial ya que el Humanoid cambia
                if _G.conexiones.noclip_stepped then _G.conexiones.noclip_stepped:Disconnect(); _G.conexiones.noclip_stepped = nil end
                if _G.conexiones.infiniteJump_jumpRequest then _G.conexiones.infiniteJump_jumpRequest:Disconnect(); _G.conexiones.infiniteJump_jumpRequest = nil end
                if _G.conexiones.antisit_stateChanged then _G.conexiones.antisit_stateChanged:Disconnect(); _G.conexiones.antisit_stateChanged = nil end
                
                -- Aplicar valores guardados de sliders directamente al nuevo Humanoid/Workspace
                if humanoid then 
                    humanoid.WalkSpeed = SettingsLib.walkspeed
                    if humanoid.JumpPower then
                        humanoid.JumpPower = SettingsLib.jump
                    elseif humanoid.JumpHeight then
                        humanoid.JumpHeight = SettingsLib.jump
                    end
                end
                Workspace.Gravity = SettingsLib.gravity
                
                -- Re-activar hacks si estaban habilitados en SettingsLib con el nuevo Humanoid
                -- Llama a las funciones toggle para que se encarguen de re-conectar y aplicar el efecto al nuevo Humanoid.
                -- Es VITAL llamar a toggle(true) o toggle(false) para re-evaluar y (re)conectar si es necesario.
                toggleNoclip(SettingsLib.noclip) 
                toggleInfiniteJump(SettingsLib.infiniteJump)
                toggleAntisit(SettingsLib.antisit)
                toggleAntivoid(SettingsLib.antivoid)
            end
            
            -- Conexión Player.CharacterAdded para re-aplicar hacks
            -- Asegurarse de que esta conexión se guarde globalmente y se desconecte si la categoría se cierra.
            -- Se añade un pequeño task.wait para dar tiempo a que el personaje esté completamente disponible.
            local charAddedConn = Player.CharacterAdded:Connect(function(character)
                task.wait(0.1) -- Pequeño retraso para que el personaje se cargue completamente
                resetAndReapplyHacks(character)
            end)
            _G.conexiones.player_character_added = charAddedConn -- Guardar esta conexión específicamente
            
            -- Lógica de "Forzar" en RenderStepped para aplicar el valor solo si el toggle está activo
            local currentCategoryPersistenceLoop = nil
            if _G.conexiones.category_persistence_loop then
                _G.conexiones.category_persistence_loop:Disconnect()
                _G.conexiones.category_persistence_loop = nil
            end

            currentCategoryPersistenceLoop = RunService.RenderStepped:Connect(function()
                local currentHumanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
                if not currentHumanoid then return end

                if SettingsLib.forceWalkspeed then
                    currentHumanoid.WalkSpeed = SettingsLib.walkspeed
                end
                if SettingsLib.forceJump then
                    if currentHumanoid.JumpPower then
                        currentHumanoid.JumpPower = SettingsLib.jump
                    elseif currentHumanoid.JumpHeight then
                        currentHumanoid.JumpHeight = SettingsLib.jump 
                    end
                end
                if SettingsLib.forceGravity then
                    Workspace.Gravity = SettingsLib.gravity
                end
            end)
            _G.conexiones.category_persistence_loop = currentCategoryPersistenceLoop
            
            -- Aplicar estados iniciales al cargar la categoría
            -- También se encarga de re-aplicar si el personaje ya existe al cargar el script
            if Player.Character then
                resetAndReapplyHacks(Player.Character)
            end

            CreateStyledTitle(scriptsArea, "Configuración del Jugador", 1)
            
            -- Sliders y Toggles "Forzar"
            local sliderVelocidadLabel, sliderVelocidadBar, sliderVelocidadValueText, updateSliderVelocidadInitial = CreateStyledSlider(scriptsArea, "Velocidad", 0, 100, SettingsLib.walkspeed, function(value)
                SettingsLib.walkspeed = value
                if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
                    Player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
                end
                Update:Notify("Velocidad ajustada a " .. value)
                getgenv().SaveConfig()
            end, 2)
            
            CreateStyledToggle(scriptsArea, "Forzar Velocidad", SettingsLib.forceWalkspeed or false, function(enabled)
                SettingsLib.forceWalkspeed = enabled
                getgenv().SaveConfig()
                if enabled then
                    if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
                        Player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = SettingsLib.walkspeed
                    end
                end
                Update:Notify("Forzar Velocidad " .. (enabled and "activado" or "desactivado"))
            end, 3, {sliderVelocidadLabel, sliderVelocidadBar, sliderVelocidadValueText, updateSliderVelocidadInitial})

            local sliderSaltoLabel, sliderSaltoBar, sliderSaltoValueText, updateSliderSaltoInitial = CreateStyledSlider(scriptsArea, "Salto", 0, 200, SettingsLib.jump, function(value)
                SettingsLib.jump = value
                if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
                    local currentHumanoid = Player.Character:FindFirstChildOfClass("Humanoid")
                    if currentHumanoid.JumpPower then
                        currentHumanoid.JumpPower = value
                    elseif currentHumanoid.JumpHeight then
                        currentHumanoid.JumpHeight = value
                    end
                end
                Update:Notify("Salto ajustado a " .. value)
                getgenv().SaveConfig()
            end, 4)

            CreateStyledToggle(scriptsArea, "Forzar Salto", SettingsLib.forceJump or false, function(enabled)
                SettingsLib.forceJump = enabled
                getgenv().SaveConfig()
                if enabled then
                    if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
                        local currentHumanoid = Player.Character:FindFirstChildOfClass("Humanoid")
                        if currentHumanoid.JumpPower then
                            currentHumanoid.JumpPower = SettingsLib.jump
                        elseif currentHumanoid.JumpHeight then
                            currentHumanoid.JumpHeight = SettingsLib.jump
                        end
                    end
                end
                Update:Notify("Forzar Salto " .. (enabled and "activado" or "desactivado"))
            end, 5, {sliderSaltoLabel, sliderSaltoBar, sliderSaltoValueText, updateSliderSaltoInitial})
            
            local sliderGravedadLabel, sliderGravedadBar, sliderGravedadValueText, updateSliderGravedadInitial = CreateStyledSlider(scriptsArea, "Gravedad", 0, 500, SettingsLib.gravity, function(value)
                SettingsLib.gravity = value
                Workspace.Gravity = value
                Update:Notify("Gravedad ajustada a " .. value)
                getgenv().SaveConfig()
            end, 6)

            CreateStyledToggle(scriptsArea, "Forzar Gravedad", SettingsLib.forceGravity or false, function(enabled)
                SettingsLib.forceGravity = enabled
                getgenv().SaveConfig()
                if enabled then
                    Workspace.Gravity = SettingsLib.gravity
                end
                Update:Notify("Forzar Gravedad " .. (enabled and "activado" or "desactivado"))
            end, 7, {sliderGravedadLabel, sliderGravedadBar, sliderGravedadValueText, updateSliderGravedadInitial})
            
            CreateStyledTitle(scriptsArea, "Propiedades", 8)
            CreateStyledToggle(scriptsArea, "Noclip", SettingsLib.noclip, toggleNoclip, 9)
            CreateStyledToggle(scriptsArea, "Salto Infinito", SettingsLib.infiniteJump, toggleInfiniteJump, 10)
            
            CreateStyledTitle(scriptsArea, "Protecciones", 11)
            CreateStyledToggle(scriptsArea, "Antisit", SettingsLib.antisit, toggleAntisit, 12)
            CreateStyledToggle(scriptsArea, "Antivoid", SettingsLib.antivoid, toggleAntivoid, 13)
            
            CreateStyledButton(scriptsArea, "Reiniciar Personaje", function()
                if Player.Character then
                    Player.Character:BreakJoints()
                end
                Update:Notify("Personaje Reiniciado")
            end, 14)

            if searchBox then
                searchBox:Destroy()
            end
            
            local updateCanvas = AutoCanvasManager:setup(scriptsArea.Parent)
            updateCanvas()

        else
        -- Lógica para las otras categorías (sin cambios)
            local ScriptsLayout = Instance.new("UIGridLayout")
             ScriptsLayout.Parent = scriptsArea
            ScriptsLayout.CellSize = UDim2.new(0.333, -5, 0, 150)
            ScriptsLayout.CellPadding = UDim2.new(0.02, 0, 0.02, 0)
            ScriptsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            local UIPadding = Instance.new("UIPadding")
            UIPadding.Parent = scriptsArea
              UIPadding.PaddingLeft = UDim.new(0.01, 0)
            UIPadding.PaddingRight = UDim.new(0.01, 0)
            UIPadding.PaddingTop = UDim.new(0.01, 0)
            local scripts = {
                {name = "EjemploCodigo1", image = "rbxassetid://10723415903", desc = "Este es un ejemplo de funcionalidad", callback = function() Update:Notify("Ejecutando EjemploCodigo1") end},
                  {name = "EjemploCodigo2", image = "rbxassetid://10723415903", desc = "Este es un ejemplo de funcionalidad", callback = function() Update:Notify("Ejecutando EjemploCodigo2") end},
                {name = "EjemploCodigo3", image = "rbxassetid://10723415903", desc = "Este es un ejemplo de funcionalidad", callback = function() Update:Notify("Ejecutando EjemploCodigo3") end},
                {name = "EjemploCodigo4", image = "rbxassetid://10723415903", desc = "Este es un ejemplo de funcionalidad", callback = function() Update:Notify("Ejecutando EjemploCodigo4") end},
                   {name = "EjemploCodigo5", image = "rbxassetid://10723415903", desc = "Este es un ejemplo de funcionalidad", callback = function() Update:Notify("Ejecutando Ejemplo5") end},
                {name = "Test Slider", image = "rbxassetid://10723415903", desc = "Este es un ejemplo de funcionalidad", type = "slider"},
                {name = "Test Toggle 1", image = "rbxassetid://10723415903", desc = "Este es un ejemplo de funcionalidad", type = "toggle"},
                 {name = "Test Toggle 2", image = "rbxassetid://10723415903", desc = "Este es un ejemplo de funcionalidad", type = "toggle"}
            }
            for _, scriptData in ipairs(scripts) do
                if searchQuery == "" or (scriptData.name and string.find(string.lower(scriptData.name), string.lower(searchQuery))) then
                    if scriptData.type == "slider" then
                        local Card = Instance.new("Frame")
                        Card.Name = scriptData.name
                        Card.Parent = scriptsArea
                         Card.BackgroundColor3 = _G.LighterDark
                        Card.BackgroundTransparency = SettingsLib.MainTransparency -- Controlado por slider principal
                        Card.BorderSizePixel = 0
                        CreateRounded(Card, 8)
                         local CardStroke = Instance.new("UIStroke")
                        CardStroke.Parent = Card
                        CardStroke.Color = Color3.fromRGB(70, 70, 70)
                        CardStroke.Thickness = 1
                          CardStroke.Transparency = 0.5
                        local Title = Instance.new("TextLabel")
                        Title.Parent = Card
                          Title.BackgroundTransparency = 1
                        Title.Position = UDim2.new(0.05, 0, 0.05, 0)
                        Title.Size = UDim2.new(0.9, 0, 0.15, 0)
                        Title.Font = Enum.Font.GothamBold
                         Title.Text = scriptData.name
                        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                        Title.TextSize = 14
                        Title.TextXAlignment = Enum.TextXAlignment.Left
                         Title.TextWrapped = true
                        local Bar = Instance.new("Frame")
                        Bar.Parent = Card
                        Bar.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                        Bar.BackgroundTransparency = 0.8
                        Bar.Size = UDim2.new(0.8, 0, 0.05, 0)
                        Bar.Position = UDim2.new(0.1, 0, 0.3, 0)
                         CreateRounded(Bar, 3)
                        local Bar1 = Instance.new("Frame")
                        Bar1.Parent = Bar
                        Bar1.BackgroundColor3 = _G.Third
                         Bar1.Size = UDim2.new(0.5, 0, 1, 0)
                        CreateRounded(Bar1, 3)
                        local CircleBar = Instance.new("Frame")
                        CircleBar.Parent = Bar1
                         CircleBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        CircleBar.Position = UDim2.new(1, 0, 0, -5)
                        CircleBar.Size = UDim2.new(0, 10, 0, 10)
                          CircleBar.AnchorPoint = Vector2.new(0.5, 0)
                        CreateRounded(CircleBar, 100)
                        local ValueText = Instance.new("TextLabel")
                        ValueText.Parent = Bar
                          ValueText.BackgroundTransparency = 1
                        ValueText.Position = UDim2.new(0, -30, 0.5, 0)
                        ValueText.Size = UDim2.new(0, 25, 0, 15)
                        ValueText.Font = Enum.Font.Gotham
                         ValueText.Text = "50"
                        ValueText.TextColor3 = Color3.fromRGB(255, 255, 255)
                        ValueText.TextSize = 10
                        local Description = Instance.new("TextLabel")
                        Description.Parent = Card
                        Description.BackgroundTransparency = 1
                        Description.Position = UDim2.new(0.05, 0, 0.8, 0)
                         Description.Size = UDim2.new(0.9, 0, 0.15, 0)
                        Description.Font = Enum.Font.Gotham
                        Description.Text = scriptData.desc
                        Description.TextColor3 = Color3.fromRGB(200, 200, 200)
                         Description.TextSize = 10
                        Description.TextXAlignment = Enum.TextXAlignment.Left
                        Description.TextWrapped = true
                        local dragging = false
                          CircleBar.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                dragging = true
                             end
                        end)
                        Bar.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                dragging = true
                            end
                        end)
                          UserInputService.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                dragging = false
                             end
                        end)
                        UserInputService.InputChanged:Connect(function(input)
                            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                                local value = math.clamp(((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X) * 100, 0, 100)
                                value = math.floor(value)
                                  Bar1.Size = UDim2.new(value / 100, 0, 1, 0)
                                CircleBar.Position = UDim2.new(0, (value / 100) * Bar.AbsoluteSize.X - 5, 0, -5)
                                ValueText.Text = tostring(value)
                                 Update:Notify("Slider: " .. value)
                            end
                        end)
                    elseif scriptData.type == "toggle" then
                        local Card = Instance.new("Frame")
                        Card.Name = scriptData.name
                        Card.Parent = scriptsArea
                         Card.BackgroundColor3 = _G.LighterDark
                        Card.BackgroundTransparency = SettingsLib.MainTransparency -- Controlado por slider principal
                        Card.BorderSizePixel = 0
                        CreateRounded(Card, 8)
                          local CardStroke = Instance.new("UIStroke")
                        CardStroke.Parent = Card
                        CardStroke.Color = Color3.fromRGB(70, 70, 70)
                        CardStroke.Thickness = 1
                         CardStroke.Transparency = 0.5
                        local Title = Instance.new("TextLabel")
                        Title.Parent = Card
                        Title.BackgroundTransparency = 1
                        Title.Position = UDim2.new(0.05, 0, 0.05, 0)
                        Title.Size = UDim2.new(0.9, 0, 0.15, 0)
                        Title.Font = Enum.Font.GothamBold
                          Title.Text = scriptData.name
                        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                        Title.TextSize = 14
                        Title.TextXAlignment = Enum.TextXAlignment.Left
                         Title.TextWrapped = true
                        local ToggleButton = Instance.new("TextButton")
                        ToggleButton.Parent = Card
                        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                        ToggleButton.BackgroundTransparency = 0.8
                        ToggleButton.Position = UDim2.new(0.65, 0, 0.3, 0)
                        ToggleButton.Size = UDim2.new(0.25, 0, 0.1, 0)
                         ToggleButton.Text = ""
                        ToggleButton.AutoButtonColor = false
                        CreateRounded(ToggleButton, 10)
                        local Circle = Instance.new("Frame")
                          Circle.Parent = ToggleButton
                        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        Circle.Position = UDim2.new(0, 4, 0.5, 0)
                        Circle.Size = UDim2.new(0, 10, 0, 10)
                        Circle.AnchorPoint = Vector2.new(0, 0.5)
                        CreateRounded(Circle, 5)
                        local Description = Instance.new("TextLabel")
                          Description.Parent = Card
                        Description.BackgroundTransparency = 1
                        Description.Position = UDim2.new(0.05, 0, 0.8, 0)
                        Description.Size = UDim2.new(0.9, 0, 0.15, 0)
                        Description.Font = Enum.Font.Gotham
                        Description.Text = scriptData.desc
                        Description.TextColor3 = Color3.fromRGB(200, 200, 200)
                        Description.TextSize = 10
                        Description.TextXAlignment = Enum.TextXAlignment.Left
                        Description.TextWrapped = true
                        local toggled = false
                        ToggleButton.MouseButton1Click:Connect(function()
                            toggled = not toggled
                            Circle:TweenPosition(UDim2.new(0, toggled and 15 or 4, 0.5, 0), "Out", "Sine", 0.2, true)
                            TweenService:Create(ToggleButton, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {BackgroundColor3 = toggled and _G.Third or Color3.fromRGB(200, 200, 200), BackgroundTransparency = toggled and 0 or 0.8}):Play()
                            Update:Notify(scriptData.name .. ": " .. tostring(toggled))
                        end)
                    else
                        CreateScriptCard(scriptsArea, scriptData)
                    end
                end
            end
        end

        if searchBox then
            searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                searchQuery = searchBox.Text or ""
                LoadScripts(category, scriptsArea, searchBox)
            end)
        end
    end

    -- =======================================================
    -- =======================================================


    -- =======================================================
    -- BARRITA INDICADORA DE BOTON SELECCIONADO (categorias)
    -- =======================================================

    local function ChangePage(newPage)
        currentPage = newPage
        for _, page in pairs(PageList:GetChildren()) do
            if page:IsA("Frame") or page:IsA("ScrollingFrame") then
                page.Visible = (page.Name == newPage .. "_Page")
            end
        end

        -- Lógica corregida para encontrar los botones y las barras
        for _, borderFrame in pairs(SidebarScroll:GetChildren()) do
            -- Buscamos el botón DENTRO del marco de borde que creamos
            if borderFrame:IsA("Frame") and borderFrame.Name:match("_Border$") then
                local button = borderFrame:FindFirstChildOfClass("TextButton")
                if button then
                    local isActive = (button.Name == newPage .. "Btn")

                    -- Buscamos la barrita DENTRO del botón y la hacemos visible/invisible
                    local indicator = button:FindFirstChild("IndicatorBar")
                    if indicator then
                       indicator.Visible = isActive
                    end
                    
                    -- También mantenemos el cambio de color del texto
                    local label = button:FindFirstChild("Label")
                    if label then
                        label.TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
                    end
                end
            end
        end
    end
    
    -- =======================================================
    -- =======================================================


    local categories = {
        {name = "Inicio", icon = "rbxthumb://type=Asset&id=97354184149697&w=150&h=150"}, -- Ícono genérico
        {name = "Editor", icon = "rbxthumb://type=Asset&id=105518340990624&w=150&h=150"},
        {name = "Jugador", icon = "rbxthumb://type=Asset&id=82408391929329&w=150&h=150"},
        {name = "Test3", icon = "rbxthumb://type=Asset&id=91775451465303&w=150&h=150"},
        {name = "Test4", icon = "rbxthumb://type=Asset&id=127623386942236&w=150&h=150"},
        {name = "Test5", icon = "rbxthumb://type=Asset&id=105406924317922&w=150&h=150"},
        {name = "Test6", icon = "rbxthumb://type=Asset&id=100498930394012&w=150&h=150"},
        {name = "Test7", icon = "rbxthumb://type=Asset&id=130821196479975&w=150&h=150"},
        {name = "Test8", icon = "rbxthumb://type=Asset&id=70589266138646&w=150&h=150"},
        {name = "Test9", icon = "rbxthumb://type=Asset&id=126035899107195&w=150&h=150"},
        {name = "Test10", icon = "rbxthumb://type=Asset&id=134191932354728&w=150&h=150"}
    }

    for i, category in ipairs(categories) do
        local contentPage, searchBox = CreateContentPage(category.name)
        local btn = CreateCategory(SidebarScroll, category.name, category.icon, i)
        btn.MouseButton1Click:Connect(function()
            ChangePage(category.name)
        end)
        -- Important: Only call LoadScripts if category is not "Inicio" as it's a special page
        if category.name ~= "Inicio" then
            LoadScripts(category.name, contentPage.ScriptsArea, searchBox)
        end
    end

    SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, #categories * 40)

    -- Pestaña Inicio
    local inicioPage = PageList:FindFirstChild("Inicio_Page") or CreateContentPage("Inicio")
    inicioPage.ScrollingEnabled = false 
    inicioPage.Visible = true

    -- Destruir welcomeFrame existente para evitar caché
    local existingWelcomeFrame = inicioPage:FindFirstChild("WelcomeFrame")
    if existingWelcomeFrame then
        existingWelcomeFrame:Destroy()
    end
    wait(0.1) -- Retraso para forzar limpieza de UI

    -- Función para dividir texto por letras con guion
    local function WrapTextByLetter(textLabel, text)
        local maxWidth = textLabel.AbsoluteSize.X
        local font = textLabel.Font
        local textSize = textLabel.TextSize
        local wrappedText = ""
        local currentLine = ""
        
        for i = 1, #text do
            local char = text:sub(i, i)
            local testLine = currentLine .. char
            local textBounds = game:GetService("TextService"):GetTextSize(testLine, textSize, font, Vector2.new(maxWidth, 1000)).X
            
            if textBounds <= maxWidth or char == "\n" then
                currentLine = currentLine .. char
            else
                if currentLine ~= "" then
                    wrappedText = wrappedText .. currentLine .. "-"
                    currentLine = char
                else
                    wrappedText = wrappedText .. char
                    currentLine = ""
                end
                wrappedText = wrappedText .. "\n"
            end
        end
        
        if currentLine ~= "" then
            wrappedText = wrappedText .. currentLine
        end
        
        textLabel.Text = wrappedText
    end

    -- Configurar welcomeFrame como contenedor principal
    local welcomeFrame = Instance.new("Frame")
    welcomeFrame.Name = "WelcomeFrame"
    welcomeFrame.Parent = inicioPage
    welcomeFrame.Size = UDim2.new(0.98, 0, 0, 400)
    welcomeFrame.BackgroundTransparency = 1
    welcomeFrame.Position = UDim2.new(0.01, 0, 0, 5)
    welcomeFrame.ClipsDescendants = false -- Añadir
    CreateRounded(welcomeFrame, 10)
    --(welcomeFrame)

    -- Cuadro de perfil
    local profileFrame = Instance.new("Frame")
    profileFrame.Name = "ProfileFrame"
    profileFrame.Parent = welcomeFrame
    profileFrame.Size = UDim2.new(0.45, -10, 0.45, -13)
    profileFrame.Position = UDim2.new(0, 3, 0, -1)
    profileFrame.BackgroundTransparency = 1
    CreateRounded(profileFrame, 8)
    --(profileFrame) -- Sombra degradada

    -- Nombre del usuario
    local profileName = Instance.new("TextLabel")
    profileName.Name = "ProfileName"
    profileName.Parent = profileFrame
    profileName.BackgroundTransparency = 1
    profileName.AnchorPoint = Vector2.new(0, 1) -- Anclado a la esquina inferior izquierda de su padre
    profileName.Position = UDim2.new(0, 10, 1, -10) -- Un margen de 10px desde la esquina inferior izquierda
    profileName.Size = UDim2.new(1, -30, 0, 25) -- Puedes ajustar el tamaño si necesitas que el texto ocupe un porcentaje o un tamaño fijo más pequeño.
    profileName.Font = Enum.Font.GothamBold
    profileName.Text = Players.LocalPlayer.Name
    profileName.TextColor3 = Color3.fromRGB(255, 255, 255)
    profileName.TextSize = 13
    profileName.TextXAlignment = Enum.TextXAlignment.Left -- Alinea el texto a la izquierda
    profileName.TextWrapped = true
    profileName:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        WrapTextByLetter(profileName, Players.LocalPlayer.Name)
    end)

    -- Mensaje de bienvenida
    local profileWelcome = Instance.new("TextLabel")
    profileWelcome.Name = "ProfileWelcome"
    profileWelcome.Parent = profileFrame
      profileWelcome.BackgroundTransparency = 1
    profileWelcome.Position = UDim2.new(0, 15, 0, 25)
    profileWelcome.Size = UDim2.new(1, -30, 0, 80)
    profileWelcome.ZIndex = 2
    profileWelcome.Font = Enum.Font.Gotham
    profileWelcome.Text = "> ¡Bienvenido/a xSOLITOx HUB!<br/>> No olvides que podés comentarme alguna sugerencia<br/>o idea en mi perfil de TikTok: @xsolito_rbl"
    profileWelcome.RichText = true
    profileWelcome.TextColor3 = Color3.fromRGB(200, 200, 200)
    profileWelcome.TextSize = 12
    profileWelcome.TextXAlignment = Enum.TextXAlignment.Center
    profileWelcome.TextWrapped = true
    profileWelcome:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
         WrapTextByLetter(profileWelcome, profileWelcome.Text)
    end)

    -- Foto de cuerpo completo
    local imageFrame = Instance.new("Frame")
    imageFrame.Name = "ProfileImageFrame"
    imageFrame.Parent = profileFrame
    imageFrame.Size = UDim2.new(0, 62, 0, 62)
    imageFrame.AnchorPoint = Vector2.new(1, 1) -- Anclado a la esquina inferior derecha de su padre
    imageFrame.Position = UDim2.new(1, -10, 1, -10) -- Un margen de 10px desde la esquina inferior derecha
    imageFrame.BackgroundTransparency = 1

    -- Bordes redondeados (círculo completo)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = imageFrame

    -- Aplicamos el borde azul con degradado y transparencia
    CreateGradientStroke(imageFrame)

    -- Imagen del perfil redonda
    local profileImage = Instance.new("ImageLabel")
    profileImage.Name = "ProfileImage"
    profileImage.Parent = imageFrame
    profileImage.Size = UDim2.new(1, 0, 1, 0)
    profileImage.Position = UDim2.new(0, 0, 0, 0)
    profileImage.BackgroundTransparency = 1
    profileImage.Image = Players:GetUserThumbnailAsync(
        Players.LocalPlayer.UserId,
        Enum.ThumbnailType.AvatarBust,
        Enum.ThumbnailSize.Size150x150
    )

      -- Borde redondeado a la imagen
    local innerCorner = Instance.new("UICorner")
    innerCorner.CornerRadius = UDim.new(1, 0)
    innerCorner.Parent = profileImage

    -- Cuadro de información
    local infoFrame = Instance.new("Frame")
    infoFrame.Name = "InfoFrame"
    infoFrame.Parent = welcomeFrame
    infoFrame.Size = UDim2.new(0.55, -15, 0.45, -10)
    infoFrame.Position = UDim2.new(0.45, -2, 0, -3)
    infoFrame.BackgroundTransparency = 1
    CreateRounded(infoFrame, 8)


    local infoTitle = Instance.new("TextLabel")
    infoTitle.Name = "InfoTitle"
    infoTitle.Parent = infoFrame
    infoTitle.BackgroundTransparency = 1
    infoTitle.Position = UDim2.new(0, 15, 0, 10) -- Subido 5 píxeles
    infoTitle.Size = UDim2.new(1, -30, 0, 25)
    infoTitle.Font = Enum.Font.GothamBold
    infoTitle.Text = "Información del Hub"
    infoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoTitle.TextSize = 15
    infoTitle.TextXAlignment = Enum.TextXAlignment.Center
    infoTitle.TextWrapped = true
    infoTitle:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        WrapTextByLetter(infoTitle, infoTitle.Text)
    end)

    local infoText = Instance.new("TextLabel")
    infoText.Name = "InfoText"
      infoText.Parent = infoFrame
    infoText.BackgroundTransparency = 1
    infoText.Position = UDim2.new(0, 15, 0, 45)
    infoText.Size = UDim2.new(1, -30, 0.7, -20)
    infoText.Font = Enum.Font.Gotham
    infoText.Text = "> Versión: 7.0<br/>> Creador: @xsolito_rbl<br/>> Script para Brookhaven RP<br/>> Características únicas<br/>> Cualquier versión sin mis créditos<br/>es más falsa que tu ex<br/>> Y recuerden no al yupi sí al pack"
    infoText.RichText = true -- Esto activa el uso de <br/>
    infoText.TextColor3 = Color3.fromRGB(255, 255, 255) 
    infoText.TextSize = 12
    infoText.TextXAlignment = Enum.TextXAlignment.Center
    infoText.TextWrapped = true

    -- Cuadro de estadísticas
    local statsFrame = Instance.new("Frame")
    statsFrame.Name = "StatsFrame"
    statsFrame.Parent = welcomeFrame
    statsFrame.Size = UDim2.new(1, -20, 0, 45)
    statsFrame.Position = UDim2.new(0, 3, 0.45, -8)
    statsFrame.BackgroundTransparency = 1
    CreateRounded(statsFrame, 8)
    --(statsFrame) -- Sombra degradada

    -- Etiquetas de estadísticas
    local pingLabel = Instance.new("TextLabel")
    pingLabel.Name = "PingLabel"
    pingLabel.Parent = statsFrame
    pingLabel.BackgroundTransparency = 1
    pingLabel.Position = UDim2.new(0.028, 16, 0, 10)
    pingLabel.Size = UDim2.new(0.3, -15, 0, 25)
    pingLabel.Font = Enum.Font.Gotham
    pingLabel.Text = "Ping: N/A"
    pingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    pingLabel.TextSize = 12
    pingLabel.TextXAlignment = Enum.TextXAlignment.Center
    pingLabel.TextWrapped = true
    pingLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        WrapTextByLetter(pingLabel, pingLabel.Text)
    end)

    local playersLabel = Instance.new("TextLabel")
    playersLabel.Name = "PlayersLabel"
    playersLabel.Parent = statsFrame
    playersLabel.BackgroundTransparency = 1
    playersLabel.Position = UDim2.new(0.342, 7, 0, 10)
    playersLabel.Size = UDim2.new(0.3, -15, 0, 25)
    playersLabel.Font = Enum.Font.Gotham
    playersLabel.Text = "Jugadores: " .. #Players:GetPlayers()
    playersLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    playersLabel.TextSize = 12
    playersLabel.TextXAlignment = Enum.TextXAlignment.Center
    playersLabel.TextWrapped = true
    playersLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        WrapTextByLetter(playersLabel, playersLabel.Text)
    end)

    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Name = "FpsLabel"
    fpsLabel.Parent = statsFrame
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.Position = UDim2.new(0.658, -2, 0, 10)
    fpsLabel.Size = UDim2.new(0.3, -15, 0, 25)
    fpsLabel.Font = Enum.Font.Gotham
    fpsLabel.Text = "FPS: N/A"
    fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fpsLabel.TextSize = 12
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Center
    fpsLabel.TextWrapped = true
    fpsLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        WrapTextByLetter(fpsLabel, fpsLabel.Text)
    end)

    -- Cuadro de redes sociales
    local socialsFrame = Instance.new("Frame")
    socialsFrame.Name = "SocialsFrame"
     socialsFrame.Parent = welcomeFrame
    socialsFrame.Size = UDim2.new(1, -20, 0.25, 0)
    socialsFrame.Position = UDim2.new(0, 3, 0.45, 42)
    socialsFrame.BackgroundTransparency = 1
    CreateRounded(socialsFrame, 8)
    --(socialsFrame) -- Sombra degradada

    local socialsTitle = Instance.new("TextLabel")
    socialsTitle.Name = "SocialsTitle"
    socialsTitle.Parent = socialsFrame
    socialsTitle.BackgroundTransparency = 1
    socialsTitle.Position = UDim2.new(0, 15, 0, 10)
    socialsTitle.Size = UDim2.new(1, -30, 0, 25)
    socialsTitle.Font = Enum.Font.GothamBold
    socialsTitle.Text = "xsolito redes"
    socialsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    socialsTitle.TextSize = 12
    socialsTitle.TextXAlignment = Enum.TextXAlignment.Center
    socialsTitle.TextWrapped = true
    socialsTitle:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        WrapTextByLetter(socialsTitle, socialsTitle.Text)
    end)

    -- Botones de redes sociales
    local InstaButton = Instance.new("TextButton")
    InstaButton.Name = "InstaButton"
    InstaButton.Parent = socialsFrame
    InstaButton.BackgroundTransparency = 1
    InstaButton.Size = UDim2.new(0.22, -10, 0, 30)
    InstaButton.Position = UDim2.new(0.038, 9, 0, 40)
    InstaButton.Font = Enum.Font.Gotham
    InstaButton.Text = "Insta"
    InstaButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    InstaButton.TextSize = 12
    InstaButton.TextXAlignment = Enum.TextXAlignment.Center
    InstaButton.TextWrapped = true
    CreateRounded(InstaButton, 5)
    --(InstaButton) -- Sombra degradada
    InstaButton:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        WrapTextByLetter(InstaButton, InstaButton.Text)
    end)
    InstaButton.MouseButton1Click:Connect(function()
        setclipboard("https://www.instagram.com/xkindg/profilecard/?igsh=eWF6enZuZ3BqNnUx")
        Update:Notify("¡Link de Insta copiado!")
    end)

    local robloxButton = Instance.new("TextButton")
    robloxButton.Name = "RobloxButton"
    robloxButton.Parent = socialsFrame
    robloxButton.BackgroundTransparency = 1
    robloxButton.Size = UDim2.new(0.22, -10, 0, 30)
    robloxButton.Position = UDim2.new(0.272, 5, 0, 40)
    robloxButton.Font = Enum.Font.Gotham
    robloxButton.Text = "Roblox"
    robloxButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    robloxButton.TextSize = 12
    robloxButton.TextXAlignment = Enum.TextXAlignment.Center
    robloxButton.TextWrapped = true
    CreateRounded(robloxButton, 5)
    --(robloxButton) -- Sombra degradada
    robloxButton:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        WrapTextByLetter(robloxButton, robloxButton.Text)
    end)
    robloxButton.MouseButton1Click:Connect(function()
         setclipboard("Https:enlacedeejemplo_roblox")
        Update:Notify("¡Link de Roblox copiado!")
    end)

    local youtubeButton = Instance.new("TextButton")
    youtubeButton.Name = "YouTubeButton"
    youtubeButton.Parent = socialsFrame
    youtubeButton.BackgroundTransparency = 1
    youtubeButton.Size = UDim2.new(0.22, -10, 0, 30)
    youtubeButton.Position = UDim2.new(0.508, 1, 0, 40)
    youtubeButton.Font = Enum.Font.Gotham
    youtubeButton.Text = "YouTube"
    youtubeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    youtubeButton.TextSize = 12
    youtubeButton.TextXAlignment = Enum.TextXAlignment.Center
    youtubeButton.TextWrapped = true
    CreateRounded(youtubeButton, 5)
    --(youtubeButton) -- Sombra degradada
    youtubeButton:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        WrapTextByLetter(youtubeButton, youtubeButton.Text)
    end)
    youtubeButton.MouseButton1Click:Connect(function()
        setclipboard("Https:enlacedeejemplo_youtube")
        Update:Notify("¡Link de YouTube copiado!")
    end)

    local discordButton = Instance.new("TextButton")
    discordButton.Name = "DiscordButton"
    discordButton.Parent = socialsFrame
    discordButton.BackgroundTransparency = 1
    discordButton.Size = UDim2.new(0.22, -10, 0, 30)
    discordButton.Position = UDim2.new(0.742, -3, 0, 40)
     discordButton.Font = Enum.Font.Gotham
    discordButton.Text = "Discord"
    discordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordButton.TextSize = 12
    discordButton.TextXAlignment = Enum.TextXAlignment.Center
    discordButton.TextWrapped = true
    CreateRounded(discordButton, 5)
    --(discordButton) -- Sombra degradada
    discordButton:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        WrapTextByLetter(discordButton, discordButton.Text)
    end)
    discordButton.MouseButton1Click:Connect(function()
        setclipboard("Https:enlacedeejemplo_discord")
        Update:Notify("¡Link de Discord copiado!")
    end)

    -- Imagen en la esquina inferior derecha del marco principal
    local CornerImage = Instance.new("ImageLabel")
    CornerImage.Name = "CornerImage"
    CornerImage.Parent = Main
    CornerImage.BackgroundTransparency = 1
    CornerImage.Size = UDim2.new(0, 32.5, 0, 32.5) -- 30% más grande (25 * 1.3)
    CornerImage.Position = UDim2.new(1, -5, 1, -5) -- Esquina inferior derecha con 5 píxeles de margen
    CornerImage.AnchorPoint = Vector2.new(1, 1)
    CornerImage.Image = "rbxthumb://type=Asset&id=105732409305720&w=150&h=150"
    CornerImage.ZIndex = 100 -- Por encima de otros elementos
    CornerImage.Visible = true
    CreateRounded(CornerImage, 10)

    -- Área de detección de arrastre
    local dragArea = Instance.new("TextButton")
    dragArea.Name = "DragArea"
    dragArea.Parent = welcomeFrame
    dragArea.BackgroundTransparency = 1
    dragArea.Size = UDim2.new(0, 27.5, 0, 27.5)
    dragArea.Position = UDim2.new(1, -6.25, 1, -16.25) -- Mantener posición original
    dragArea.ZIndex = 99
    dragArea.Text = ""

    -- Conectar dragArea al arrastre existente
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
              Dragging = true
        end
    end)

    -- Asegurar WindowConfig
    local WindowConfig = {
        Size = Config.Size or UDim2.new(0, 600, 0, 400),
        TabWidth = Config.TabWidth or 150
    }
    assert(WindowConfig.Size.X.Offset, "Error: WindowConfig.Size.X.Offset no está definido")
    assert(WindowConfig.TabWidth, "Error: WindowConfig.TabWidth no está definido")

    -- Recolectar elementos afectados una sola vez, con tamaños base originales
    local imageElements = {} -- Imágenes: CategoryIcon, CloseButton, ResizeButton, SettingsButton, CornerImage
    local textElements = {} -- Textos: Todos los TextLabel y TextButton
    local function collectElements()
        for _, child in ipairs(OutlineMain:GetDescendants()) do
            if child:IsA("ImageLabel") or child:IsA("ImageButton") then
                if child.Name == "Icon" and child.Parent.Parent == SidebarScroll then
                     imageElements[child] = child.Size
                elseif child.Parent == Top and (child.Name == "CloseButton" or child.Name == "ResizeButton" or child.Name == "SettingsButton") then
                    imageElements[child] = child.Size
                elseif child.Name == "CornerImage" and child.Parent == Main then
                     imageElements[child] = child.Size
                end
            end
            if (child:IsA("TextLabel") or child:IsA("TextButton")) and child.Name ~= "NewResizeHandle" then
                textElements[child] = child.TextSize
            end
        end
    end
     collectElements() -- Ejecutar al inicio

    -- Crear botón de redimensionamiento
    local NewResizeHandle = Instance.new("TextButton")
    NewResizeHandle.Name = "NewResizeHandle"
    NewResizeHandle.Parent = OutlineMain
    NewResizeHandle.Position = UDim2.new(1, -2, 1, -2)
    NewResizeHandle.AnchorPoint = Vector2.new(1, 1)
    NewResizeHandle.Size = UDim2.new(0, 40, 0, 40)
    NewResizeHandle.BackgroundTransparency = 1
    NewResizeHandle.Text = ""
    NewResizeHandle.ZIndex = 201
    NewResizeHandle.AutoButtonColor = false
    CreateRounded(NewResizeHandle, 10)

    local newResizeDragging = false
    local newResizeStartMousePos, newResizeStartFrameSize
    local minWidth = WindowConfig.Size.X.Offset -- 600
    local maxWidth = 1280
    local maxScaleWidth = 900 -- Ancho donde se alcanza el máximo
    local minImageScale = 1.0 -- 100% del tamaño base original para imágenes en el mínimo
    local maxImageScale = 1.38 -- 138% para imágenes en el máximo
    local minTextScale = 1.0 -- 100% del tamaño base original para textos en el mínimo
    local maxTextScale = 1.5 -- 150% para textos en el máximo

    -- Iniciar arrastre
    NewResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then    
            newResizeDragging = true
            newResizeStartMousePos = input.Position
            newResizeStartFrameSize = Vector2.new(OutlineMain.Size.X.Offset, OutlineMain.Size.Y.Offset)
        end
    end)

    -- Finalizar arrastre
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            newResizeDragging = false
        end
    end)



    -- =========================================================
    -- CONFIGURACION DEL REDIMENSIONAMIENTO
    -- =========================================================

    UserInputService.InputChanged:Connect(function(input)
        if newResizeDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            -- Calcula el cambio de tamaño basado en el movimiento del mouse y la escala de la UI
            local scale = OutlineMain:FindFirstChild("UIScale") and OutlineMain.UIScale.Scale or 1 
            local delta = (input.Position - newResizeStartMousePos) * 1.5 / scale

            -- Calcula las nuevas dimensiones, asegurando que no excedan los límites definidos
            local newWidth = math.clamp(newResizeStartFrameSize.X + delta.X, minWidth, maxWidth)
            local newHeight = math.clamp(newResizeStartFrameSize.Y + delta.Y, WindowConfig.Size.Y.Offset, 576)

            -- Aplica el nuevo tamaño al contenedor principal
            OutlineMain.Size = UDim2.new(0, newWidth, 0, newHeight)

            -- [[ INICIO DE LA CORRECCIÓN ]]
            -- Esta es la parte crucial que faltaba.
            -- Ahora redimensionamos los marcos internos
            -- para que se ajusten al nuevo tamaño de OutlineMain en tiempo real.
            -- El marco 'Main' (con un pequeño padding)
            Main.Size = UDim2.new(1, -16, 1, -16) 
            
            -- El marco 'Page' que contiene el contenido principal
            Page.Size = UDim2.new(0, newWidth - WindowConfig.TabWidth - 16, 0, newHeight - 40)
            
            -- La barra lateral de categorías
            SidebarScroll.Size = UDim2.new(0, WindowConfig.TabWidth, 0, newHeight - 40)
            -- [[ FIN DE LA CORRECCIÓN ]]


            -- Calcula el factor de interpolación 't' para el escalado dinámico
            local t
            if newWidth <= maxScaleWidth then
                t = (newWidth - minWidth) / (maxScaleWidth - minWidth) 
            else
                t = 1
            end
            
            -- Ajusta 't' para que el encogimiento sea más suave
            local adjustedT = newWidth < newResizeStartFrameSize.X and math.sqrt(t) * (newWidth <= minWidth + 50 and 0.8 or 1) or t
            
            -- Calcula los factores de escala finales para imágenes y texto
            local imageScaleFactor = minImageScale + (maxImageScale - minImageScale) * adjustedT
            local textScaleFactor = minTextScale + (maxTextScale - minTextScale) * adjustedT

            -- Aplica el escalado a todas las imágenes cacheadas
            for element, baseSize in pairs(imageElements) do 
                element.Size = UDim2.new(
                    baseSize.X.Scale, baseSize.X.Offset * imageScaleFactor,
                    baseSize.Y.Scale, baseSize.Y.Offset * imageScaleFactor
                )
            end

            -- Aplica el escalado a todos los textos cacheados
            for element, baseTextSize in pairs(textElements) do 
                element.TextSize = baseTextSize * textScaleFactor
            end
        end
    end)




    -- Ajustar el canvas
    inicioPage.CanvasSize = UDim2.new(0, 0, 0, 400)
    -- =========================================================
    -- =========================================================



    -- =========================================================
    -- =========================================================
    -- WORKSPACE PARA CODIGOS ADICIONALES
    -- =========================================================
    -- =========================================================


    -- =========================================================
    -- CONTROLADOR DE LAS NOTIFICACIONES
    -- =========================================================


    do
        local originalNotify = Update.Notify
        local queue = {} -- cola de notificaciones
        local isRunning = false

        -- Función que procesa la cola
        local function processQueue()
            if isRunning then return end
            isRunning = true

            while #queue > 0 do
                  local desc = table.remove(queue, 1)
                originalNotify(Update, desc)
                wait(1.8) -- tiempo visible (ajustá según duración)
            end

            isRunning = false
        end

        -- Nuevo hook para Update.Notify
        Update.Notify = function(self, desc)
            table.insert(queue, desc)
            processQueue()
        end
    end
    -- =========================================================
    -- =========================================================


    
    -- =========================================================
    -- [[ FUNCION PARA LAS CATEGORIAS ]]
    -- =========================================================

    function ApplyCustomBorders()
        task.wait(0)

          local CoreGui = game:GetService("CoreGui")
        local SolitoHub = CoreGui:FindFirstChild("xSOLITOxHUB")
        if not SolitoHub then return end

        local SidebarScroll = SolitoHub:WaitForChild("OutlineMain"):WaitForChild("Main"):WaitForChild("SidebarScroll")
        
        for _, originalBtn in ipairs(SidebarScroll:GetChildren()) do
            if originalBtn:IsA("TextButton") and not originalBtn.Parent:FindFirstChild(originalBtn.Name .. "_Border") then
         
                 local originalSize = originalBtn.Size
                local originalLayoutOrder = originalBtn.LayoutOrder
                local originalZIndex = originalBtn.ZIndex
                
                -- Creamos el marco contenedor usando la estructura que SÍ funciona.
                local BorderFrame = Instance.new("Frame")
                BorderFrame.Name = originalBtn.Name .. "_Border"
                BorderFrame.Size = originalSize
                BorderFrame.LayoutOrder = originalLayoutOrder
                BorderFrame.BackgroundTransparency = 1 
                BorderFrame.ZIndex = originalZIndex
                 BorderFrame.Parent = SidebarScroll 
                CreateRounded(BorderFrame, 12)
                
                -- Metemos el botón original DENTRO del nuevo marco de borde.
                originalBtn.Parent = BorderFrame
                originalBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
                originalBtn.AnchorPoint = Vector2.new(0.5, 0.5)
                originalBtn.Size = UDim2.new(1, 0, 1, 0)
                originalBtn.ZIndex = originalZIndex + 1
                originalBtn.BackgroundTransparency = 1 
                
                -- Le aplicamos el resplandor al botón original, que ahora está dentro del BorderFrame.
                CreateGradientStroke(originalBtn)

                -- Limpiamos SÓLO el borde viejo, pero dejamos tu IndicatorBar intacta.
                local oldStroke = originalBtn:FindFirstChild("FadedShadow")
                if oldStroke then oldStroke:Destroy() end
                
            end
        end
        print("INFO: Bordes de resplandor aplicados. IndicatorBar preservado.")
    end

    ApplyCustomBorders()
    -- =========================================================
    -- =========================================================


    -- =========================================================
    -- BORDE PARA LOS CUADROS DE INICIO
    -- =========================================================

    task.delay(0, function()
        pcall(function() 
            
            local function CreateRounded(Parent, Size)
                if Parent:FindFirstChild("Rounded") then Parent.Rounded:Destroy() end
                local Rounded = Instance.new("UICorner")
                Rounded.Name = "Rounded"
                Rounded.Parent = Parent
                Rounded.CornerRadius = UDim.new(0, Size)
            end

            -- 1. Búsqueda de la GUI
            local coreGui = game:GetService("CoreGui")
            local solitoHub = coreGui:FindFirstChild("xSOLITOxHUB")
            if not solitoHub then return end
            local outlineMain = solitoHub:FindFirstChild("OutlineMain")
            if not outlineMain then return end
            local main = outlineMain:FindFirstChild("Main")
            if not main then return end
            local page = main:FindFirstChild("Page")
            if not page then return end
            local mainPage = page:FindFirstChild("MainPage")
            if not mainPage then return end
            local pageList = mainPage:FindFirstChild("PageList")
            if not pageList then return end
            local inicioPage = pageList:FindFirstChild("Inicio_Page")
               if not inicioPage then return end
            local welcomeFrame = inicioPage:FindFirstChild("WelcomeFrame")
            if not welcomeFrame then return end
            
            -- 2. Creación de los cuadros
            local colorBorde = Color3.fromRGB(1, 94, 255)
            local cuadrosNombres = {"ProfileFrame", "InfoFrame", "StatsFrame", "SocialsFrame"}

            for _, nombre in ipairs(cuadrosNombres) do
                local original = welcomeFrame:FindFirstChild(nombre)
                if original then
                    local impostor = Instance.new("Frame")
                    impostor.Name = "Impostor_" .. nombre
                    impostor.Parent = original.Parent
                    impostor.Size = original.Size - UDim2.fromOffset(10, 10) 
                    impostor.Position = original.Position + UDim2.fromOffset(5, 5) 
                    impostor.AnchorPoint = original.AnchorPoint
                    impostor.BackgroundTransparency = 1
                    impostor.ZIndex = original.ZIndex + 5
                    CreateRounded(impostor, 8)
                 
                       local stroke = Instance.new("UIStroke")
                    stroke.Name = "BordeImpostorAzul"
                    stroke.Color = colorBorde
                    stroke.Thickness = 2
                    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    stroke.Parent = impostor
                end
            end
        end)
    end)


    -- =========================================================
    -- =========================================================



    -- =========================================================
    -- AJUSTES SECUNDARIO DE LA INTERFAZ PRINCIPAL
    -- =========================================================
      local ThemeButton = Instance.new("ImageButton")
    ThemeButton.Name = "ThemeButton"
    ThemeButton.Parent = Top
    ThemeButton.BackgroundTransparency = 1
    ThemeButton.AnchorPoint = Vector2.new(1, 0.5)
    ThemeButton.Position = UDim2.new(1, -120, 0.5, 0)
    ThemeButton.Size = UDim2.new(0, 20, 0, 20)
    ThemeButton.Image = "rbxthumb://type=Asset&id=74711151096915&w=150&h=150"
    ThemeButton.ImageColor3 = Color3.fromRGB(245, 245, 245)
    CreateRounded(ThemeButton, 3)

    -- Fondo translúcido para la ventana de ajustes secundarios (nuevo)
    local ThemeOverlay = Instance.new("Frame")
    ThemeOverlay.Name = "ThemeOverlay"
    ThemeOverlay.Parent = OutlineMain
      ThemeOverlay.Size = UDim2.new(1, 0, 1, 0)
    ThemeOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
    ThemeOverlay.BackgroundTransparency = 1
    ThemeOverlay.ZIndex = 150 -- Debe estar por encima de la interfaz principal, pero debajo de la ventana de ajustes
    ThemeOverlay.Visible = false

    local ThemeWindow = Instance.new("Frame")
    ThemeWindow.Name = "ThemeWindow"
    ThemeWindow.Parent = ThemeOverlay -- Ahora es hijo de ThemeOverlay
    ThemeWindow.BackgroundColor3 = _G.Dark
    ThemeWindow.BackgroundTransparency = 0
    ThemeWindow.Position = UDim2.new(0.5, 0, 0.5, 0) -- Centrado en el overlay
    ThemeWindow.Size = UDim2.new(0, 400, 0, 300) -- Increased size to fit new elements
    ThemeWindow.AnchorPoint = Vector2.new(0.5, 0.5) -- Anclaje al centro para centrado
    ThemeWindow.ZIndex = 151 -- Por encima del overlay
    ThemeWindow.Visible = true -- Visible por defecto para que el overlay controle su visibilidad
    CreateRounded(ThemeWindow, 12)
    CreateGlowStroke(ThemeWindow)

    local ThemeWindowTitle = Instance.new("TextLabel")
    ThemeWindowTitle.Name = "ThemeWindowTitle"
    ThemeWindowTitle.Parent = ThemeWindow
    ThemeWindowTitle.Size = UDim2.new(1, -20, 0, 30)
    ThemeWindowTitle.Position = UDim2.new(0, 20, 0, 15) -- ESQUINA SUPERIOR IZQUIERDA
    ThemeWindowTitle.AnchorPoint = Vector2.new(0, 0) -- ESQUINA SUPERIOR IZQUIERDA
    ThemeWindowTitle.BackgroundTransparency = 1
    ThemeWindowTitle.Font = Enum.Font.GothamBold
    ThemeWindowTitle.Text = "Ajustes de Apariencia"
    ThemeWindowTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ThemeWindowTitle.TextSize = 20 -- MISMO TAMAÑO
    ThemeWindowTitle.TextXAlignment = Enum.TextXAlignment.Left -- ALINEADO A LA IZQUIERDA

    local CloseThemeWindowButton = Instance.new("ImageButton")
    CloseThemeWindowButton.Name = "CloseThemeWindowButton"
    CloseThemeWindowButton.Parent = ThemeWindow
    CloseThemeWindowButton.Size = UDim2.new(0, 26, 0, 26) -- MISMO TAMAÑO
    CloseThemeWindowButton.Position = UDim2.new(1, -15, 0, 15) -- MISMA POSICION
    CloseThemeWindowButton.AnchorPoint = Vector2.new(1, 0)
    CloseThemeWindowButton.BackgroundTransparency = 1
    CloseThemeWindowButton.Image = "rbxassetid://10747384394"
    CloseThemeWindowButton.ImageColor3 = Color3.fromRGB(245, 245, 245)
    CreateRounded(CloseThemeWindowButton, 3)
    CloseThemeWindowButton.MouseButton1Click:Connect(function()
        ThemeOverlay.Visible = false -- Ocultar el overlay
    end)

    local ThemeScrollSettings = Instance.new("ScrollingFrame")
    ThemeScrollSettings.Name = "ThemeScrollSettings"
    ThemeScrollSettings.Parent = ThemeWindow
    ThemeScrollSettings.Active = true
    ThemeScrollSettings.BackgroundTransparency = 1
    ThemeScrollSettings.Position = UDim2.new(0, 0, 0, 50)
    ThemeScrollSettings.Size = UDim2.new(1, 0, 1, -70)
    ThemeScrollSettings.ScrollBarThickness = 1
    ThemeScrollSettings.ScrollingDirection = Enum.ScrollingDirection.Y
    
    local ThemeSettingsListLayout = Instance.new("UIListLayout")
    ThemeSettingsListLayout.Parent = ThemeScrollSettings
    ThemeSettingsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ThemeSettingsListLayout.Padding = UDim.new(0, 20) -- Espacio de 20px entre elementos
    ThemeSettingsListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center -- Centrar elementos del layout

    -- New Transparency Slider for Main Interface
      local MainTransparencyLabel = Instance.new("TextLabel")
    MainTransparencyLabel.Name = "MainTransparencyLabel"
    MainTransparencyLabel.Parent = ThemeScrollSettings
    MainTransparencyLabel.BackgroundTransparency = 1
    MainTransparencyLabel.Position = UDim2.new(0.5, 0, 0, 20) -- Centrado horizontalmente
    MainTransparencyLabel.AnchorPoint = Vector2.new(0.5, 0) -- Anclaje al centro
    MainTransparencyLabel.Size = UDim2.new(0.8, 0, 0, 20)
    MainTransparencyLabel.Font = Enum.Font.Gotham
    MainTransparencyLabel.Text = "Transparencia del Fondo Principal"
    MainTransparencyLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    MainTransparencyLabel.TextSize = 14
    MainTransparencyLabel.TextXAlignment = Enum.TextXAlignment.Center -- Alineado al centro
    MainTransparencyLabel.LayoutOrder = 1

     local MainThemeSlider = Instance.new("Frame")
    MainThemeSlider.Name = "MainThemeSlider"
    MainThemeSlider.Parent = ThemeScrollSettings
    MainThemeSlider.BackgroundColor3 = Color3.fromRGB(25, 25, 25) 
    MainThemeSlider.Position = UDim2.new(0.5, 0, 0, 45) -- Centrado horizontalmente
    MainThemeSlider.Size = UDim2.new(0.8, 0, 0, 12)
    MainThemeSlider.AnchorPoint = Vector2.new(0.5, 0)
    CreateRounded(MainThemeSlider, 6)
    MainThemeSlider.LayoutOrder = 2

    local MainThemeSliderFill = Instance.new("Frame")
    MainThemeSliderFill.Name = "MainThemeSliderFill"
    MainThemeSliderFill.Parent = MainThemeSlider
    MainThemeSliderFill.Size = UDim2.new(0, 0, 1, 0)
    MainThemeSliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CreateRounded(MainThemeSliderFill, 6)

    local MainGradient = Instance.new("UIGradient")
    MainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(1, 94, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 5, 70))
    })
    MainGradient.Rotation = 0
    MainGradient.Parent = MainThemeSliderFill

    local MainThemeSliderHandle = Instance.new("Frame")
    MainThemeSliderHandle.Name = "MainThemeSliderHandle"
    MainThemeSliderHandle.Parent = MainThemeSlider
    MainThemeSliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MainThemeSliderHandle.Position = UDim2.new(0, 0, 0.5, 0)
    MainThemeSliderHandle.Size = UDim2.new(0, 16, 0, 16)
    MainThemeSliderHandle.AnchorPoint = Vector2.new(0.5, 0.5)
    MainThemeSliderHandle.ZIndex = MainThemeSlider.ZIndex + 1
    CreateRounded(MainThemeSliderHandle, 8)

    local isMainTransparencyDragging = false
    local blacklistedItems = {"BackgroundSettings", "SettingsFrame", "ThemeWindow", " Overlay", "DialogFrame", " frame", "ThemeOverlay", "SidebarScroll", "VentanaElegirPartesBG"}
    
    local function updateMainTransparency(inputPos)
        local sliderSize = MainThemeSlider.AbsoluteSize
        local sliderPos = MainThemeSlider.AbsolutePosition
        local relativeX = math.clamp(inputPos.X - sliderPos.X, 0, sliderSize.X)
        local t = relativeX / sliderSize.X
        
        local newTransparency = 0.0 + t * 0.6
        
        for _, obj in ipairs(ScreenGui:GetDescendants()) do
            if obj:IsA("GuiObject") and not table.find(blacklistedItems, obj.Name) then
                if obj.BackgroundColor3 == Color3.fromRGB(0, 0, 0) or obj.BackgroundColor3 == _G.Dark or obj.BackgroundColor3 == _G.LighterDark then
                    obj.BackgroundTransparency = newTransparency
                end
            end
        end
        
        MainThemeSliderFill.Size = UDim2.new(t, 0, 1, 0)
        MainThemeSliderHandle.Position = UDim2.new(t, 0, 0.5, 0)
        SettingsLib.MainTransparency = newTransparency
        getgenv().SaveConfig()
    end
    
    -- Apply initial saved transparency to Main UI
    local initialMainTransparencyT = SettingsLib.MainTransparency / 0.6
    MainThemeSliderFill.Size = UDim2.new(initialMainTransparencyT, 0, 1, 0)
    MainThemeSliderHandle.Position = UDim2.new(initialMainTransparencyT, 0, 0.5, 0)

    MainThemeSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isMainTransparencyDragging = true
            updateMainTransparency(input.Position)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isMainTransparencyDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateMainTransparency(input.Position)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isMainTransparencyDragging = false
        end
    end)

    -- New "Restablecer" button for Main Transparency
    local resetButtonMainTransparency = CreateButton("Restablecer Transparencia", function()
        SettingsLib.MainTransparency = 0.1 -- Default transparency
        getgenv().SaveConfig()

        for _, obj in ipairs(ScreenGui:GetDescendants()) do
            if obj:IsA("GuiObject") and not table.find(blacklistedItems, obj.Name) then
                if obj.BackgroundColor3 == Color3.fromRGB(0, 0, 0) or obj.BackgroundColor3 == _G.Dark or obj.BackgroundColor3 == _G.LighterDark then
                    obj.BackgroundTransparency = SettingsLib.MainTransparency
                end
            end
        end

        MainThemeSliderFill.Size = UDim2.new(0.1 / 0.6, 0, 1, 0) -- Update slider visually
        MainThemeSliderHandle.Position = UDim2.new(0.1 / 0.6, 0, 0.5, 0)
         Update:Notify("Transparencia principal restablecida!")
    end, ThemeScrollSettings)
    resetButtonMainTransparency.LayoutOrder = 3
    resetButtonMainTransparency.Position = resetButtonMainTransparency.Position + UDim2.new(0,0,0,30) -- Mover 30px hacia abajo

    local function CreateToggleButton(title, state, callback, parentFrame)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 60)
    container.BackgroundTransparency = 1
    container.Parent = parentFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.Text = title
    label.Font = Enum.Font.Gotham
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 14
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Parent = container
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.8, 0, 0.5, 0)
    button.Position = UDim2.new(0.1, 0, 0.5, 0)
    button.Font = Enum.Font.Code 
    button.TextSize = 15 
    button.TextColor3 = Color3.fromRGB(255, 255, 255) 
    button.Parent = container
    button.Text = "" -- <--- ¡IMPORTANTE! VACIAR EL TEXTO DEL BOTÓN PRINCIPAL
    CreateRounded(button, 5)
    
    local gradient
    
    -- CREA UN TEXTLABEL SEPARADO PARA EL TEXTO DEL BOTÓN
    local buttonTextLabel = Instance.new("TextLabel")
    buttonTextLabel.Name = "ButtonToggleText"
    buttonTextLabel.Parent = button -- Házlo hijo del botón para que se mueva y escale con él
    buttonTextLabel.Size = UDim2.new(1, 0, 1, 0) -- Ocupa todo el espacio del botón padre
    buttonTextLabel.BackgroundTransparency = 1 -- Completamente transparente
    buttonTextLabel.Font = Enum.Font.Code -- Misma fuente
    buttonTextLabel.TextSize = 15 -- Mismo tamaño de texto
    buttonTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Mismo color de texto
    buttonTextLabel.TextXAlignment = Enum.TextXAlignment.Center
    buttonTextLabel.TextYAlignment = Enum.TextYAlignment.Center
    buttonTextLabel.ZIndex = button.ZIndex + 1 -- <--- ¡IMPORTANTE! Asegúrate de que esté por encima

    local function updateButtonState()
        if state then
            buttonTextLabel.Text = "Activado" -- <--- Asigna el texto a la NUEVA etiqueta
            if not gradient then
                gradient = Instance.new("UIGradient")
                gradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, _G.DefaultGradient.Start),
                    ColorSequenceKeypoint.new(1, _G.DefaultGradient.End)
                })
                gradient.Parent = button
            end
            gradient.Enabled = true
            button.BackgroundColor3 = Color3.fromRGB(255, 255, 255) 
        else
            buttonTextLabel.Text = "Desactivado" -- <--- Asigna el texto a la NUEVA etiqueta
            if gradient then
                gradient.Enabled = false
            end
            button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        end
        button.ZIndex = button.Parent.ZIndex + 1 
    end
    
    button.MouseButton1Click:Connect(function()
        state = not state
        updateButtonState()
        pcall(callback, state)
    end)
    
    updateButtonState()
    return container
end

    local toggleLoadAnimation = CreateToggleButton("Pantalla de carga", SettingsLib.LoadAnimation, function(state)
        SettingsLib.LoadAnimation = state
        getgenv().SaveConfig()
    end, ThemeScrollSettings)
    toggleLoadAnimation.LayoutOrder = 4

    local buttonOriginalPosition = CreateButton("Posición original", function()
        TweenService:Create(OutlineMain, TweenInfo.new(0.3), {Position = UDim2.new(0.5, 0, 0.45, 0)}):Play()
         Update:Notify("Posición de la UI reseteada")
    end, ThemeScrollSettings)
    buttonOriginalPosition.LayoutOrder = 5

    local buttonCredits = CreateButton("Créditos", function()
        local subTitle = NameHub and NameHub:FindFirstChild("SubTitle")
        if subTitle then
            subTitle.Text = "by xsolito_rbl"
        end
        Update:Notify("Sigueme en tiktok @xsolito_rbl!")
    end, ThemeScrollSettings)
    buttonCredits.LayoutOrder = 6

    ThemeButton.MouseButton1Click:Connect(function()
         ThemeOverlay.Visible = not ThemeOverlay.Visible -- Alternar visibilidad del overlay
        if ThemeOverlay.Visible and BackgroundSettings.Visible then
            BackgroundSettings.Visible = false
        end
    end)

    -- FIN DEL BLOQUE
    -- =========================================================
    -- =========================================================


    -- =========================================================
    -- [ PANEL DE OUTFITS DE ACCESO RÁPIDO ]
    -- =========================================================

    local CoreGui = game:GetService("CoreGui")
      local SolitoHub = CoreGui:WaitForChild("xSOLITOxHUB", 10)
    if not SolitoHub then return end

    local OutlineMain = SolitoHub:WaitForChild("OutlineMain", 10)
    if not OutlineMain then return end

    task.spawn(function()
        
    -- (FUNCIÓN DE BORDE (INDEPENDIENTE)

        local function CreateOutfitPanelGradientStroke(Parent)
            -- Esta es una copia de tu función original, pero es local para este panel.
            for _, child in ipairs(Parent:GetChildren()) do
                if child:IsA("UIStroke") and child.Name == "OutfitGlowStroke" then
                    child:Destroy()
                end
            end

            local Stroke = Instance.new("UIStroke")
            Stroke.Name = "OutfitGlowStroke"
            Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            Stroke.Thickness = 2
            Stroke.LineJoinMode = Enum.LineJoinMode.Round
            Stroke.Color = Color3.fromRGB(1, 94, 255) 
            Stroke.Transparency = 0

            local TransparencyGradient = Instance.new("UIGradient")
            TransparencyGradient.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.2), 
                NumberSequenceKeypoint.new(0.5, 0.8),
                NumberSequenceKeypoint.new(1, 1)
            })

            -- CAMBIO: Rotación diferente para un estilo único
            TransparencyGradient.Rotation = 270 
            TransparencyGradient.Parent = Stroke
            Stroke.Parent = Parent
        end
        
        
        -- (CONFIGURACIÓN Y VARIABLES DEL PANEL)
        
        local PanelWidth = 90
        local HandleWidth = 30
         local TOTAL_SLOTS = 24

        local GUARDAR_IMG = "rbxthumb://type=Asset&id=110400387798371&w=150&h=150"
        local CARGAR_IMG = "rbxthumb://type=Asset&id=140023817970341&w=150&h=150"

        local Remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        local SaveOutfitRemote = Remotes and Remotes:FindFirstChild("SaveOutfit")
        local LoadOutfitRemote = Remotes and Remotes:FindFirstChild("LoadOutfit")

        local slotEntries = {}
        local currentlyOpenSlot = nil
        local isPanelExpanded = false
        
        
        
    -- (FUNCIÓN DE DIÁLOGO DE CONFIRMACIÓN DEL PANEL)
        
        local function ShowConfirmationDialog(slotNumber)
            local Overlay = Instance.new("Frame")
            Overlay.Name = "ConfirmationOverlay"
            Overlay.Parent = OutlineMain
              Overlay.Size = UDim2.new(1, 0, 1, 0)
            Overlay.BackgroundColor3 = Color3.new(0, 0, 0)
            Overlay.BackgroundTransparency = 1
            Overlay.ZIndex = 200 

            local DialogFrame = Instance.new("Frame")
            DialogFrame.Parent = Overlay
            DialogFrame.Size = UDim2.new(0, 400, 0, 200)
            DialogFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            DialogFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            DialogFrame.BackgroundColor3 = _G.LighterDark
            DialogFrame.BackgroundTransparency = 0
            CreateRounded(DialogFrame, 12)
            CreateOutfitPanelGradientStroke(DialogFrame)

            local Title = Instance.new("TextLabel")
            Title.Parent = DialogFrame
            Title.Size = UDim2.new(1, 0, 0, 40)
            Title.Position = UDim2.new(0.5, 0, 0, 10)
            Title.AnchorPoint = Vector2.new(0.5, 0)
            Title.BackgroundTransparency = 1
            Title.Font = Enum.Font.GothamBold
            Title.Text = "Advertencia"
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 22

            local Description = Instance.new("TextLabel")
            Description.Parent = DialogFrame
            Description.Size = UDim2.new(0.9, 0, 0, 80)
              Description.Position = UDim2.new(0.5, 0, 0, 50)
            Description.AnchorPoint = Vector2.new(0.5, 0)
            Description.BackgroundTransparency = 1
            Description.Font = Enum.Font.Gotham
            Description.Text = "Estas seguro que quieres guardar tu outfit actual y reemplazar el de este slot?<br/>Esto reemplazará tu outfit guardado<br/>en ese slot de brookhaven<br/>de forma permanente..."
            Description.TextColor3 = Color3.fromRGB(200, 200, 200)
            Description.TextSize = 18
            Description.TextWrapped = true
            Description.RichText = true

            local ButtonContainer = Instance.new("Frame")
            ButtonContainer.Parent = DialogFrame
            ButtonContainer.Size = UDim2.new(1, 0, 0, 50)
              ButtonContainer.Position = UDim2.new(0.5, 0, 1, -15)
            ButtonContainer.AnchorPoint = Vector2.new(0.5, 1)
            ButtonContainer.BackgroundTransparency = 1
            
            local ButtonLayout = Instance.new("UIListLayout")
            ButtonLayout.Parent = ButtonContainer
            ButtonLayout.FillDirection = Enum.FillDirection.Horizontal
              ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            ButtonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            ButtonLayout.Padding = UDim.new(0, 20)

            local function createDialogButton(text, callback)
                local BtnBase = Instance.new("TextButton")
                BtnBase.Parent = ButtonContainer
                  BtnBase.Size = UDim2.new(0, 120, 0, 40)
                BtnBase.Text = ""
                CreateRounded(BtnBase, 8)
                ApplyDefaultGradient(BtnBase)
                BtnBase.MouseButton1Click:Connect(callback)
                local BtnText = Instance.new("TextLabel")
                BtnText.Parent = BtnBase
                BtnText.Size = UDim2.new(1, 0, 1, 0)
                BtnText.BackgroundTransparency = 1
                BtnText.Text = text
            BtnText.Font = Enum.Font.SourceSansBold
                   BtnText.TextSize = 18
                BtnText.TextColor3 = Color3.fromRGB(255, 255, 255)
                BtnText.ZIndex = BtnBase.ZIndex + 1
                return BtnBase
            end
            
              createDialogButton("Cancelar", function() Overlay:Destroy() end)
            createDialogButton("Aceptar", function()
                if SaveOutfitRemote then
                    pcall(SaveOutfitRemote.InvokeServer, SaveOutfitRemote, slotNumber, "Outfit " .. slotNumber)
                    Update:Notify("Outfit guardado en el slot " .. slotNumber)
                 end
                Overlay:Destroy()
            end)
        end
        
        
        -- (LÓGICA Y ESTRUCTURA DE LA UI DE PANEL)

        -- CAMBIO: Posición y tamaño ajustados para calzar perfectamente
        local MainContainer = Instance.new("Frame")
        MainContainer.Name = "OutfitDrawerContainer"
        MainContainer.Parent = OutlineMain
        MainContainer.BackgroundTransparency = 1
        MainContainer.Position = UDim2.new(1, 0, 0, 0) -- Pegado a la derecha sin offset
        MainContainer.Size = UDim2.new(0, HandleWidth + PanelWidth, 1, 0) -- 100% de la altura
        MainContainer.ClipsDescendants = true

        local HandleBar = Instance.new("TextButton")
          HandleBar.Name = "HandleBar"
        HandleBar.Parent = MainContainer
        HandleBar.Text = ""
        HandleBar.Size = UDim2.new(0, HandleWidth, 1, 0)
        HandleBar.BackgroundColor3 = _G.Dark
        HandleBar.BackgroundTransparency = SettingsLib.MainTransparency -- Aplicar transparencia
        CreateRounded(HandleBar, 15) -- Mismo redondeado que la UI principal
        CreateOutfitPanelGradientStroke(HandleBar)

        local VerticalText = Instance.new("TextLabel")
         VerticalText.Parent = HandleBar
        VerticalText.Size = UDim2.new(1, 0, 1, 0)
        VerticalText.BackgroundTransparency = 1
        VerticalText.Rotation = -90
        VerticalText.Font = Enum.Font.GothamBold
        VerticalText.Text = "Tus trajes de Brookhaven"
        VerticalText.TextColor3 = Color3.fromRGB(255, 255, 255)
        VerticalText.TextSize = 14
        
        local NumberListPanel = Instance.new("Frame")
        NumberListPanel.Name = "NumberListPanel"
        NumberListPanel.Parent = MainContainer
        NumberListPanel.BackgroundColor3 = _G.Dark
        NumberListPanel.BackgroundTransparency = SettingsLib.MainTransparency -- Aplicar transparencia
        NumberListPanel.Size = UDim2.new(0, PanelWidth, 1, 0)
        NumberListPanel.Position = UDim2.new(0, -PanelWidth, 0, 0)
        CreateRounded(NumberListPanel, 15) -- Mismo redondeado
        CreateOutfitPanelGradientStroke(NumberListPanel)

        local OutfitScroll = Instance.new("ScrollingFrame")
        OutfitScroll.Parent = NumberListPanel
        OutfitScroll.Size = UDim2.new(1, 0, 1, 0)
        OutfitScroll.BackgroundTransparency = 1
        OutfitScroll.ScrollBarThickness = 0
        OutfitScroll.ScrollingDirection = Enum.ScrollingDirection.Y
        OutfitScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

        local OutfitLayout = Instance.new("UIListLayout")
        OutfitLayout.Parent = OutfitScroll
        OutfitLayout.Padding = UDim.new(0, 5)
         OutfitLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        local ScrollPadding = Instance.new("UIPadding")
        ScrollPadding.Parent = OutfitScroll
        ScrollPadding.PaddingTop = UDim.new(0, 10)
        ScrollPadding.PaddingBottom = UDim.new(0, 10)
        ScrollPadding.PaddingLeft = UDim.new(0, 5)
        ScrollPadding.PaddingRight = UDim.new(0, 5)

        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
          local collapsedHeight = 24
        local expandedHeight = 64

        local function UpdateAllRowStates()
            for i = 1, TOTAL_SLOTS do
                local entry = slotEntries[i]
                local isSelected = (i == currentlyOpenSlot)
                
                  local goalSize = isSelected and UDim2.new(0.9, 0, 0, expandedHeight) or UDim2.new(0.9, 0, 0, collapsedHeight)
                game:GetService("TweenService"):Create(entry.Frame, tweenInfo, {Size = goalSize}):Play()
                
                entry.ActionButtons.Visible = isSelected
                entry.Indicator.Visible = isSelected
             end
        end

        local function OnNumberButtonClick(slotNumber)
            if currentlyOpenSlot == slotNumber then
                currentlyOpenSlot = nil
            else
                currentlyOpenSlot = slotNumber
             end
            UpdateAllRowStates()
        end

        local function CreateSlotEntry(slotNumber)
            local EntryFrame = Instance.new("Frame")
            EntryFrame.Parent = OutfitScroll
            EntryFrame.Size = UDim2.new(0.9, 0, 0, collapsedHeight)
            EntryFrame.BackgroundTransparency = 1
             EntryFrame.ClipsDescendants = true
            
            local NumBtn = Instance.new("TextButton")
            NumBtn.Parent = EntryFrame
            NumBtn.Size = UDim2.new(1, 0, 0, collapsedHeight)
            NumBtn.Text = ""
            CreateRounded(NumBtn, 8)
              NumBtn.MouseButton1Click:Connect(function() OnNumberButtonClick(slotNumber) end)
            
            local gradient = Instance.new("UIGradient")
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHex("#0442FF")),
                ColorSequenceKeypoint.new(1, Color3.fromHex("#131313"))
            })
             gradient.Rotation = 90
            gradient.Parent = NumBtn

            local NumberText = Instance.new("TextLabel")
            NumberText.Parent = NumBtn
            NumberText.Size = UDim2.new(1, 0, 1, 0)
            NumberText.BackgroundTransparency = 1
            NumberText.Text = slotNumber
              NumberText.Font = Enum.Font.GothamBold
            NumberText.TextSize = 22
            NumberText.TextColor3 = Color3.fromRGB(255, 255, 255)
            NumberText.ZIndex = NumBtn.ZIndex + 1

            local Indicator = Instance.new("Frame")
            Indicator.Parent = NumBtn
            Indicator.BackgroundColor3 = _G.Primary
            Indicator.Size = UDim2.new(0, 0, 0, 0)
            Indicator.Position = UDim2.new(0, 5, 0.5, 0)
            Indicator.AnchorPoint = Vector2.new(0.5, 0.5)
            Indicator.Visible = false
            CreateRounded(Indicator, 3)
            
            local ActionButtons = Instance.new("Frame")
            ActionButtons.Parent = EntryFrame
            ActionButtons.Size = UDim2.new(1, 0, 1, -collapsedHeight)
            ActionButtons.Position = UDim2.new(0, 0, 0, collapsedHeight)
            ActionButtons.BackgroundTransparency = 1
            ActionButtons.Visible = false
            
             local actionLayout = Instance.new("UIListLayout")
            actionLayout.Parent = ActionButtons
            actionLayout.FillDirection = Enum.FillDirection.Horizontal
            actionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            actionLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            actionLayout.Padding = UDim.new(0, 8)
            
              local SaveBtn = Instance.new("ImageButton")
            SaveBtn.Parent = ActionButtons
            SaveBtn.Size = UDim2.new(0, 28, 0, 28)
            SaveBtn.Image = GUARDAR_IMG
            SaveBtn.BackgroundTransparency = 1
            SaveBtn.MouseButton1Click:Connect(function() ShowConfirmationDialog(slotNumber) end)
            
              local LoadBtn = Instance.new("ImageButton")
            LoadBtn.Parent = ActionButtons
            LoadBtn.Size = UDim2.new(0, 28, 0, 28)
            LoadBtn.Image = CARGAR_IMG
            LoadBtn.BackgroundTransparency = 1
            LoadBtn.MouseButton1Click:Connect(function()
                if LoadOutfitRemote then
                     pcall(LoadOutfitRemote.InvokeServer, LoadOutfitRemote, slotNumber)
                    Update:Notify("Cargando outfit " .. slotNumber)
                end
            end)
            
            return { Frame = EntryFrame, Button = NumBtn, Indicator = Indicator, ActionButtons = ActionButtons }
        end

        for i = 1, TOTAL_SLOTS do
            slotEntries[i] = CreateSlotEntry(i)
        end
        
        HandleBar.MouseButton1Click:Connect(function()
            isPanelExpanded = not isPanelExpanded
            local goalPosition = isPanelExpanded and UDim2.new(0, HandleWidth, 0, 0) or UDim2.new(0, -PanelWidth, 0, 0)
            game:GetService("TweenService"):Create(NumberListPanel, tweenInfo, {Position = goalPosition}):Play()

            if not isPanelExpanded then
                currentlyOpenSlot = nil
            UpdateAllRowStates() -- Changed from UpdateAllButtonStates()
            end
        end)
          
        isPanelExpanded = false
        NumberListPanel.Position = UDim2.new(0, -PanelWidth, 0, 0)
        
    end)

    -- FIN DEL BLOQUE
    -- =========================================================
    -- =========================================================
    
    
    -- =========================================================
-- BLOQUE INDEPENDIENTE PARA AÑADIR IMÁGENES Y TEXTOS A BOTONES DE REDES SOCIALES
-- Se ejecuta después de que toda la interfaz principal esté creada.
-- =========================================================

task.delay(0.5, function() -- Pequeño retraso para asegurar que la UI esté completamente cargada
    pcall(function()
        local CoreGui = game:GetService("CoreGui")
        local SolitoHub = CoreGui:FindFirstChild("xSOLITOxHUB")
        if not SolitoHub then return end

        local OutlineMain = SolitoHub:FindFirstChild("OutlineMain")
        if not OutlineMain then return end

        local Main = OutlineMain:FindFirstChild("Main")
        if not Main then return end

        local Page = Main:FindFirstChild("Page")
        if not Page then return end
        
        local MainPage = Page:FindFirstChild("MainPage")
        if not MainPage then return end

        local InicioPage = MainPage:FindFirstChild("PageList"):FindFirstChild("Inicio_Page")
        if not InicioPage then return end

        local welcomeFrame = InicioPage:FindFirstChild("WelcomeFrame")
        if not welcomeFrame then return end

        local socialsFrame = welcomeFrame:FindFirstChild("SocialsFrame")
        if not socialsFrame then return end

        local socialButtons = {
            {originalButtonName = "InstaButton", imageId = 18355586412, displayText = "Insta"},
            {originalButtonName = "RobloxButton", imageId = 12189937834, displayText = "Roblox"},
            {originalButtonName = "YouTubeButton", imageId = 15654893567, displayText = "Youtube"},
            {originalButtonName = "DiscordButton", imageId = 10367063084, displayText = "Discord"}
        }

        for _, data in pairs(socialButtons) do
            local button = socialsFrame:FindFirstChild(data.originalButtonName)
            if button and not button:FindFirstChild(data.originalButtonName .. "Icon") then
                button.Text = "" 
                button.TextXAlignment = Enum.TextXAlignment.Center 
                button.TextWrapped = true

                local icon = Instance.new("ImageLabel")
                icon.Name = data.originalButtonName .. "Icon" 
                icon.Parent = button
            
                -- Ajuste de tamaño para la imagen de YouTube
                if data.originalButtonName == "YouTubeButton" then
                    icon.Size = UDim2.new(0, 25, 0, 25 * 1.5) -- Ancho 25, Altura 25 * 1.5 (37.5px)
                else
                    icon.Size = UDim2.new(0, 25, 0, 25) -- Mismo tamaño que íconos de categoría (25x25)
                end
                
                -- La posición del icono se mantiene como estaba originalmente para la alineación a la izquierda
                icon.Position = UDim2.new(0, 5, 0.5, 0) 
                icon.AnchorPoint = Vector2.new(0, 0.5) 
                icon.BackgroundTransparency = 1
                icon.Image = "rbxthumb://type=Asset&id=" .. tostring(data.imageId) .. "&w=150&h=150"
                icon.ScaleType = Enum.ScaleType.Fit
                icon.ZIndex = button.ZIndex + 1 

                local iconCorner = Instance.new("UICorner")
                iconCorner.CornerRadius = UDim.new(0, 5) 
                iconCorner.Parent = icon

                local buttonTextLabel = Instance.new("TextLabel")
                buttonTextLabel.Name = "SocialButtonTextLabel" 
                buttonTextLabel.Parent = button
                
                -- Calculamos el ancho real del icono (offset de la izquierda + su tamaño)
                local iconCalculatedWidth = icon.Position.X.Offset + icon.Size.X.Offset -- Esto da 5 + 25 = 30 para la mayoría, y 5 + 25 = 30 para Youtube (ancho es el mismo)
                
                -- Margen deseado entre el icono y el texto (puedes ajustar este valor)
                local spacing = 5 
                
                -- Nueva posición del texto: al final del icono + el espaciado
                buttonTextLabel.Position = UDim2.new(0, iconCalculatedWidth + spacing, 0, 0)
                
                -- El tamaño del TextLabel se ajusta para el resto del ancho disponible
                -- 1 (escala del padre) - (el porcentaje que toma el icono + el espaciado + el offset inicial)
                buttonTextLabel.Size = UDim2.new(1, -(iconCalculatedWidth + spacing + 5), 1, 0) -- -5 es un pequeño padding a la derecha
                
                buttonTextLabel.BackgroundTransparency = 1
                buttonTextLabel.Font = button.Font 
                buttonTextLabel.TextSize = button.TextSize 
                buttonTextLabel.TextColor3 = button.TextColor3 
                buttonTextLabel.TextXAlignment = Enum.TextXAlignment.Left 
                buttonTextLabel.TextYAlignment = Enum.TextYAlignment.Center
                buttonTextLabel.Text = data.displayText 
                buttonTextLabel.ZIndex = icon.ZIndex 
            end
        end
    end)
end)

-- =========================================================
-- FIN DEL BLOQUE INDEPENDIENTE
-- =========================================================


    -- Actualizar estadísticas
    spawn(function()
        while wait(1) do
            local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
            pingLabel.Text = "Ping: " .. ping
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            fpsLabel.Text = "FPS: " .. fps
            playersLabel.Text = "Jugadores: " .. #Players:GetPlayers()
        end
    end)


    ChangePage("Inicio")

    local uitab = {}
    function uitab:Tab(text, img)
        -- Función vacía para mantener compatibilidad con código anterior
    end
    return uitab
end

-- Configuración del botón flotante
ImageButton.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = not ScreenGui.Enabled
end)

-- Inicialización
if Update:LoadAnimation() then
    ScreenGui.Enabled = false
    Update:StartLoad()
else
    ScreenGui.Enabled = true
end

-- Reiniciar la transparencia al inicio y luego aplicar el valor guardado
local tempTransparency = SettingsLib.MainTransparency
SettingsLib.MainTransparency = 0 -- Establecer a 0 temporalmente
Update:Window({SubTitle = "v7.0 Para Brookhaven RP", Size = UDim2.new(0, 700, 0, 400), TabWidth = 170})

-- Aplicar la transparencia guardada rápidamente
task.delay(0.1, function() -- Pequeño retraso para asegurar que la UI se haya creado
    local OutlineMainFrame = game:GetService("CoreGui").xSOLITOxHUB.OutlineMain
    local blacklistedItems = {"BackgroundSettings", "SettingsFrame", "ThemeWindow", " Overlay", "DialogFrame", " frame", "ThemeOverlay", "SidebarScroll", "VentanaElegirPartesBG"}
    
    local function applyTransparency(value)
        for _, obj in ipairs(ScreenGui:GetDescendants()) do
            if obj:IsA("GuiObject") and not table.find(blacklistedItems, obj.Name) then
                if obj.BackgroundColor3 == Color3.fromRGB(0, 0, 0) or obj.BackgroundColor3 == _G.Dark or obj.BackgroundColor3 == _G.LighterDark then
                    obj.BackgroundTransparency = value
                end
            end
        end
        local notifFrame = game:GetService("CoreGui"):FindFirstChild("NotificationFrame")
        if notifFrame and notifFrame:FindFirstChild("OutlineFrame") then
            notifFrame.OutlineFrame.BackgroundTransparency = value
        end
    end
    
    applyTransparency(tempTransparency)
    SettingsLib.MainTransparency = tempTransparency
    
    -- Actualizar visualmente el slider
    local ThemeWindow = OutlineMainFrame:FindFirstChild("ThemeOverlay"):FindFirstChild("ThemeWindow")
    if ThemeWindow then
        local ThemeScrollSettings = ThemeWindow:FindFirstChild("ThemeScrollSettings")
        if ThemeScrollSettings then
            local MainThemeSlider = ThemeScrollSettings:FindFirstChild("MainThemeSlider")
            if MainThemeSlider then
                local MainThemeSliderFill = MainThemeSlider:FindFirstChild("MainThemeSliderFill")
                local MainThemeSliderHandle = MainThemeSlider:FindFirstChild("MainThemeSliderHandle")
                if MainThemeSliderFill and MainThemeSliderHandle then
                    local initialMainTransparencyT = (tempTransparency - 0.0) / 0.6
                    MainThemeSliderFill.Size = UDim2.new(initialMainTransparencyT, 0, 1, 0)
                    MainThemeSliderHandle.Position = UDim2.new(initialMainTransparencyT, 0, 0.5, 0)
                end
            end
        end
    end
end)

-- =========================================================
-- BLOQUE DE CONTROL DE TELETRANSPORTE DEL ÍCONO FLOTANTE FINAL
-- Espera a que la pantalla de carga se destruya y luego teletransporta el ícono.
-- DEBE IR AL ABSOLUTO FINAL DEL SCRIPT.
-- =========================================================

task.spawn(function()
    local floatingButtonGuiRef = nil
    
    task.wait(1) 

    floatingButtonGuiRef = game:GetService("CoreGui"):FindFirstChild("FloatingButtonGui")
    if not floatingButtonGuiRef then
        local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            floatingButtonGuiRef = playerGui:FindFirstChild("FloatingButtonGui")
        end
    end

    if not floatingButtonGuiRef then
        return
    end

    local outlineButton = floatingButtonGuiRef:FindFirstChild("OutlineButton")
    if not outlineButton then
        return
    end

    local loaderGui = game:GetService("CoreGui"):FindFirstChild("Loader")
    if loaderGui then
        repeat task.wait() until not game:GetService("CoreGui"):FindFirstChild("Loader")
    end

    -- MODIFICACIÓN: Teletransportamos el OutlineButton a su posición final (-50px más arriba).
    outlineButton.Position = UDim2.new(0.738, 0, 0.945, -100)

    -- Opcional: Podrías añadir un Tween aquí si quieres una animación suave de llegada:
    -- game:GetService("TweenService"):Create(outlineButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.738, 0, 0.945, -50)}):Play()
end)

-- =========================================================
-- FIN DEL BLOQUE DE TELETRANSPORTE
-- =========================================================
