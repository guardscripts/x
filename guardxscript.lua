--for GuardX Executor, run this script to attach to roblox with GuardX
repeat wait() until game:GetService'Players'.LocalPlayer;

local PlaceName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name 
local PlayerName = game:GetService("Players").LocalPlayer.Name 
local HttpService = game:GetService("HttpService") 

if syn then
    if syn.websocket then
        ws = syn.websocket.connect("ws://localhost:4544") 
    else 
        unsupported = true
    end
elseif WebSocket then
    ws = WebSocket.connect("ws://localhost:4544") 
elseif KRNL_LOADED then
    ws = Krnl.Websocket.connect("ws://localhost:4544") 
else
    unsupported = true
end
local WebSocketScript = "" 
if not unsupported then
    ws.OnMessage:Connect(function(Message) 
        if Message == "BEGIN SCRIPT" then
            WebSocketScript = "" 
        elseif Message == "END SCRIPT" then
            loadstring(WebSocketScript)() 
        else
            WebSocketScript = WebSocketScript .. Message 
        end
    end)
    
    ws:Send(HttpService:JSONEncode({
        type = "init",
        sender = PlayerName,
        game = PlaceName
    }))
    
    game:GetService("LogService").MessageOut:Connect(function(Message)
        ws:Send(HttpService:JSONEncode({
            type = "log",
            message = Message
        }))
    end)
end
