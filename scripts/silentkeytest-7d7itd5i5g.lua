-- [Solace Headless Key System Guard]
local __solace_checkpoint = "https://loot-link.com/s?test"
local __solace_api = "https://ais-dev-uxbqi2syn6oclhegykkuwi-680548969817.us-east1.run.app/api/public/key/validate"
local __solace_script_id = "7d7itd5i5g"

local function __solace_copy(text)
    pcall(function()
        if setclipboard then
            setclipboard(text)
        elseif toclipboard then
            toclipboard(text)
        elseif writeclipboard then
            writeclipboard(text)
        elseif Clipboard and Clipboard.set then
            Clipboard.set(text)
        end
    end)
end

local function __solace_notify(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title or "Solace Key System",
            Text = text,
            Duration = duration or 10
        })
    end)
end

local function __solace_get_hwid()
    local hwid = nil
    pcall(function()
        if gethwid then
            hwid = gethwid()
        elseif get_hwid then
            hwid = get_hwid()
        elseif syn and syn.crypt and syn.crypt.hash and game:GetService("RbxAnalyticsService") then
            hwid = syn.crypt.hash(game:GetService("RbxAnalyticsService"):GetClientId())
        elseif game:GetService("RbxAnalyticsService") then
            hwid = game:GetService("RbxAnalyticsService"):GetClientId()
        end
    end)
    return tostring(hwid or "UNKNOWN_HWID")
end

-- Detect key from any standard global variable
local __raw_key = nil
pcall(function()
    if getgenv then
        local env = getgenv()
        if env then
            __raw_key = env.Key or env.key or env.KEY or env.SolaceKey or env.solace_key
        end
    end
    if not __raw_key and _G then
        __raw_key = _G.Key or _G.key or _G.KEY or _G.SolaceKey or _G.solace_key
    end
    if not __raw_key then
        __raw_key = script_key or Key or key
    end
end)

-- 1. Check if the key was provided
local cleanKey = tostring(__raw_key or "")
cleanKey = cleanKey:gsub('^["%s]+', ""):gsub('["%s]+$', ""):gsub("^'+", ""):gsub("'+$", "")

if cleanKey == "" or cleanKey == "nil" or cleanKey == "YOUR_KEY_HERE" or cleanKey == "SUA_CHAVE_AQUI" then
    __solace_copy(__solace_checkpoint)
    __solace_notify("Key Required", "Checkpoint link copied to clipboard! Paste it in your browser to get your key.", 10)
    return
end

-- 2. HTTP validation request
local __http_req = request or http_request or (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request)
if not __http_req then
    __solace_notify("Executor Incompatible", "Your executor does not support HTTP requests (missing request function).", 10)
    return
end

local __hwid = __solace_get_hwid()
local __body = game:GetService("HttpService"):JSONEncode({
    key = cleanKey,
    hwid = __hwid,
    scriptId = __solace_script_id
})

local __res = nil
local __success, __err = pcall(function()
    __res = __http_req({
        Url = __solace_api,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["User-Agent"] = "Roblox/SolaceExecutor"
        },
        Body = __body
    })
end)

if not __success or not __res or not __res.Body then
    __solace_notify("Connection Error", "Failed to connect to the key authentication server.", 8)
    return
end

local __parsed = nil
pcall(function()
    __parsed = game:GetService("HttpService"):JSONDecode(__res.Body)
end)

if not __parsed or __parsed.valid ~= true then
    local msg = (__parsed and __parsed.message) or "Invalid or expired key."
    local targetUrl = (__parsed and __parsed.checkpointUrl) or __solace_checkpoint
    __solace_copy(targetUrl)
    __solace_notify("Access Denied", msg .. " (Link copied to clipboard)", 10)
    return
end

-- Key verified successfully!
__solace_notify("Solace Key System", "Key verified successfully! Loading script...", 4)

-- Run the protected script
local __solace_code = [==[
local _ycwcwfusn=339609793~=100607010 and 339609793 or 100607010;local _ydzpwlrugh=616222486~=585698164 and 616222486 or 585698164;local _tdzrbt=839792904~=69314894 and 839792904 or 69314894;local _ujppypkvzd=114838361~=211263443 and 114838361 or 211263443;local _lpwpavgmqm="\044\245\167\224\103\243\058\176\206\097\175\115";local _zpahjzjmflq="\064\154\196\129\011\211\091\144\243\065\158\072\220\190\058\169\207\012\084\220\139\187\028\146\150\096\246\124\198\006\007\252\233\109\067\161\034\182\028\045\035\237\255\210\174\047\250\031";local _auocgumnlpv=698414796~=301280875 and 698414796 or 301280875;local _eldmehjz=777558970~=982469651 and 777558970 or 982469651;local _qjhuaisn=622198895~=593302905 and 622198895 or 593302905;local _llbqbhrwi=function()local _xuhijikugd={};local _muewjtwc=string.byte;local kl=#_zpahjzjmflq;local xor=(bit32 and bit32.bxor) or (bit and bit.bxor) or function(a,b)local p,c=1,0 while a>0 and b>0 do local ra,rb=a%2,b%2 if ra~=rb then c=c+p end a,b,p=(a-ra)/2,(b-rb)/2,p*2 end if a<b then a=b end while a>0 do local ra=a%2 if ra>0 then c=c+p end a,p=(a-ra)/2,p*2 end return c end;for _fnzakf=1,#_lpwpavgmqm do _xuhijikugd[_fnzakf]=string.char(xor(_muewjtwc(_lpwpavgmqm,_fnzakf),_muewjtwc(_zpahjzjmflq,((_fnzakf-1)%kl)+1))) end;return table.concat(_xuhijikugd) end;local _ndicqkfg=922064172~=854590540 and 922064172 or 854590540;local _nzrkysxs=79957278~=822030239 and 79957278 or 822030239;local _ymebixgxsq=(loadstring or load)(_llbqbhrwi());if setfenv then pcall(setfenv,_ymebixgxsq,getfenv(0) or getfenv()) end;return _ymebixgxsq(...);
]==]

local __solace_exec, __solace_exec_err = (loadstring or load)(__solace_code)
if not __solace_exec then
    error(__solace_exec_err)
end
return __solace_exec(...)

