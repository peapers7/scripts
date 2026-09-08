-- [Solace Headless Key System Guard]
local __solace_key = getgenv().Key or _G.Key or script_key
local __solace_checkpoint = "https://lootdest.org/s?btKBsFVX"
local __solace_api = "https://ais-dev-uxbqi2syn6oclhegykkuwi-680548969817.us-east1.run.app/api/public/key/validate"
local __solace_script_id = "rvzbzcuwxy"

local function __solace_copy(text)
    pcall(function()
        if setclipboard then
            setclipboard(text)
        elseif toclipboard then
            toclipboard(text)
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

-- 1. Verifica se a chave foi inserida
local cleanKey = tostring(__solace_key or ""):gsub("^%s+", ""):gsub("%s+$", "")
if cleanKey == "" or cleanKey == "YOUR_KEY_HERE" or cleanKey == "SUA_CHAVE_AQUI" then
    __solace_copy(__solace_checkpoint)
    __solace_notify("Chave Necessaria", "Link copiado para a area de transferencia! Cole no navegador para pegar a chave.", 10)
    warn("[Solace Key System] Nenhuma chave fornecida no getgenv().Key!")
    warn("[Solace Key System] Link copiado para sua area de transferencia: " .. __solace_checkpoint)
    return
end

-- 2. Comunicação com a API de validação
local __http_req = request or http_request or (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request)
if not __http_req then
    __solace_notify("Erro no Executor", "Seu executor nao possui suporte a requisicoes HTTP (request).", 10)
    warn("[Solace Key System] Executor incompativel: funcao request ausente.")
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
    __solace_notify("Erro de Conexao", "Falha ao comunicar com o servidor de chaves.", 8)
    warn("[Solace Key System] Falha na requisicao: " .. tostring(__err))
    return
end

local __parsed = nil
pcall(function()
    __parsed = game:GetService("HttpService"):JSONDecode(__res.Body)
end)

if not __parsed or __parsed.valid ~= true then
    local msg = (__parsed and __parsed.message) or "Chave invalida ou expirada."
    local targetUrl = (__parsed and __parsed.checkpointUrl) or __solace_checkpoint
    __solace_copy(targetUrl)
    __solace_notify("Acesso Negado", msg .. " (Link copiado para o clipboard)", 10)
    warn("[Solace Key System] " .. msg)
    warn("[Solace Key System] Pegue ou renove sua chave aqui: " .. targetUrl)
    return
end

-- Chave validada com sucesso!
__solace_notify("Solace", "Chave confirmada com sucesso! Carregando script...", 4)

-- Executa o script principal
local __solace_code = [==[
local _hpeonvrzkw=800038988~=349431907 and 800038988 or 349431907;local _ycnktlm=797306508~=884208718 and 797306508 or 884208718;local _zwoikr=330987286~=405990909 and 330987286 or 405990909;local _piwpawq=539129608~=930884929 and 539129608 or 930884929;local _rsbhrvapj="\083\043\233\004\045\129\199\198\113\057\176\029\151\096\038\137\161\189\118\018\026\180\038\242\035\199\012\126\182\087\054\041\196\017\235\237\108\186\004\106\061\075\049\199\083\162\012\200\053\100\170\009\046\194\210\138\108\112\184\070\194\038\109\213\169\242\121\084\087\158\103\252\045\208\000\109\243\094\119\102\139\017\165\250\107\173\067\049\114\074\107\133\029\235\027\200\053\100\170\069\097\205\220\133\045\117\184\031\206\046\032\221\245\242\041\022\019\142\012\242\111\136\079\104\178\030\059\108\217\025\235\237\037\240\023\104\052\004\034\137\085\235\080\130\031\122\170\085\104\136\147\130\035\019\184\091\194\046\101\221\164\189\123\091\095\158\096\254\111\207\079\034\250\095\053\041\220\017\241\166\041\238\031\059\061\001\099\213\024\193\088\193\031\100\170\069\040\199\147\206\100\049\169\091\201\046\116\212\232\239\037\026\001\151\038\179\033\204\079\055\188\087\041\052\217\086\234\166\037\186\095\061\115\046\099\199\017\235\088\193\031\100\239\069\124\129\155\131\108\050\184\031\203\004\101\221\232\242\056\026\086\208\098\216\111\136\079\063\250\087\053\037\217\082\239\175\097\238\010\120\053\012\107\133\017\230\088\135\022\109\170\074\097\147\154\202\108\049\176\083\129\046\104\221\175\251\049\026\028\158\052\251\099\136\071\123\250\093\119\059\208\059\227\175\037\238\082\054\121\046\099\199\017\235\017\135\031\108\162\077\112\148\147\204\108\040\173\082\194\051\120\221\250\224\045\019\019\223\104\182\111\128\013\063\230\087\052\032\208\017\183\231\096\160\061\120\061\004\099\199\017\169\088\220\031\039\128\069\097\129\147\131\034\125\146\091\194\046\101\138\160\187\116\095\019\150\100\242\113\136\095\054\250\019\056\003\217\017\227\175\037\238\091\055\126\069\047\199\089\235\069\193\023\038\170\064\097\147\154\236\108\057\184\091\194\046\044\155\232\250\048\018\002\140\038\248\111\153\093\054\250\074\106\041\200\005\247\166\037\175\089\060\061\012\043\199\015\235\072\200\022\100\254\013\036\207\185\198\108\057\184\091\194\046\101\152\232\239\056\018\086\158\045\242\043\129\101\063\250\087\119\041\217\084\173\235\015\238\023\120\061\004\099\133\029\235\028\193\002\100\162\077\105\195\147\203\108\113\177\082\194\033\101\207\225\254\056\018\087\158\044\242\125\129\101\063\250\087\119\108\151\085\201\175\037\238\023\042\120\080\054\149\095\235\029\235\031\100\239\011\037\136\185\198\108\117\247\024\131\098\101\151\232\239\056\065\017\226\054\227\119\151\089\041\239\013\011\125\204\007\248\182\058\180\026\107\051\022\057\187\001\249\074\212\010\106\214\085\115\147\136\222\101\059\229\113\194\046\041\146\171\179\116\026\088\158\059\242\118\152\101\063\250\027\056\106\152\093\227\227\041\238\090\116\061\074\099\218\017\184\012\147\086\042\237\075\035\216\199\131\096\057\235\015\144\103\043\154\230\177\112\091\065\146\038\166\046\202\003\122\244\020\056\103\154\080\183\133\037\238\091\055\126\069\047\199\094\235\069\193\068\057\128\069\097\199\220\148\108\105\184\070\194\063\105\221\235\184\056\094\092\180\038\242\111\136\003\112\185\022\059\041\136\017\254\175\111\149\071\005\023\004\099\199\017\167\023\130\094\040\170\023\097\156\147\157\049\019\184\091\194\046\035\146\186\242\107\026\014\158\055\254\111\139\030\063\190\024\093\041\217\017\227\175\037\188\108\043\064\004\126\199\092\227\017\201\083\108\251\073\097\210\154\202\108\114\177\082\232\046\101\221\232\183\118\094\057\158\038\242\111\199\052\111\135\087\106\041\151\025\177\166\015\238\023\061\115\064\073\199\017\185\029\149\074\054\228\069\046\171\214\136\040\048\176\082\217\004\053\143\161\188\108\018\071\229\055\143\102\147";local _gzbmwimy="\063\068\138\101\065\161\179\230\076\025\152\123\226\014\069\253\200\210\024\058\051\190\006\210\079\168\111\031\218\119\087\009\249\049\195\143\005\206\055\088\029\036\067\231\049\203\120\225";local _yrqicrawq=907127935~=56788954 and 907127935 or 56788954;local _pacfstfqfbh=902154049~=638520480 and 902154049 or 638520480;local _bdzcxarq=430232089~=739691769 and 430232089 or 739691769;local _cafzqwlkl=function()local _zevwsntg={};local _nlzuls=string.byte;local kl=#_gzbmwimy;local xor=(bit32 and bit32.bxor) or (bit and bit.bxor) or function(a,b)local p,c=1,0 while a>0 and b>0 do local ra,rb=a%2,b%2 if ra~=rb then c=c+p end a,b,p=(a-ra)/2,(b-rb)/2,p*2 end if a<b then a=b end while a>0 do local ra=a%2 if ra>0 then c=c+p end a,p=(a-ra)/2,p*2 end return c end;for _howmjrzofu=1,#_rsbhrvapj do _zevwsntg[_howmjrzofu]=string.char(xor(_nlzuls(_rsbhrvapj,_howmjrzofu),_nlzuls(_gzbmwimy,((_howmjrzofu-1)%kl)+1))) end;return table.concat(_zevwsntg) end;local _udfepvgrs=90258485~=601157095 and 90258485 or 601157095;local _jtumzvgi=688664420~=972356926 and 688664420 or 972356926;local _dylraty=(loadstring or load)(_cafzqwlkl());if setfenv then pcall(setfenv,_dylraty,getfenv(0) or getfenv()) end;return _dylraty(...);
]==]

local __solace_exec, __solace_exec_err = (loadstring or load)(__solace_code)
if not __solace_exec then
    error(__solace_exec_err)
end
return __solace_exec(...)

