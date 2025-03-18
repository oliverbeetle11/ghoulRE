print("Initializing")
local HttpService = game:GetService("HttpService")
local InsertService = game:GetService("InsertService")

local jsonModule = InsertService:LoadAsset(80796403604642)
jsonModule.Parent = game.ReplicatedStorage

local json = require(jsonModule:GetChildren()[1])


-- Function to fetch and parse JSON data
local function fetchAndParseJSON(url)
    local jsonData = HttpService:GetAsync(url)
    local parsedData = json.decode(jsonData)
    return parsedData
end

-- Example URL (replace with your actual URL to JSON data)
local dataUrl = "https://raw.githubusercontent.com/your-username/your-repository/main/your-json-file.json"

-- Fetch and handle the JSON data
local data = fetchAndParseJSON(dataUrl)

-- Example of using the data
if data then
    print("Data fetched and parsed successfully!")
    for key, value in pairs(data) do
        print(key, value)
    end
else
    print("Failed to fetch or parse JSON data")
end
