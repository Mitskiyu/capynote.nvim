local uv = vim.uv

---@class cn.OAuth
local oauth = {}

oauth.port = 65530
oauth.client = "1482154586897649704"
oauth.base_url = "https://discord.com/oauth2/authorize?response_type=code"

function oauth.start()
  local redirect = "http%3A%2F%2F127.0.0.1%3A" .. tostring(oauth.port)
  local url = string.format(
    "%s&client_id=%s&scope=identify%%20bot&redirect_uri=%s",
    oauth.base_url,
    oauth.client,
    redirect
  )

  -- start callback server
  oauth.server()
  local cmd, err = vim.ui.open(url)
  if err then
    vim.notify(err, vim.log.levels.ERROR)
  elseif cmd then
    cmd:wait()
  end
end

---@param chunk string
---@return string
function oauth.code(chunk)
  local i = string.find(chunk, "code=")
  local j = string.find(chunk, "&", i + 5)
  return string.sub(chunk, i + 5, j - 1)
end

---@param code string
function oauth.exchange(code) end

---@private
function oauth.server()
  local server = uv.new_tcp()
  server:bind("127.0.0.1", oauth.port)
  server:listen(1, function(err)
    assert(not err, err)
    local client = uv.new_tcp()
    server:accept(client)
    client:read_start(function(err, chunk)
      assert(not err, err)
      if chunk then
        local code = oauth.code(chunk)
        print(code) -- exchange code for token, need pkce?
        client:write("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\ncapynote ok!\n")
        client:shutdown()
        client:close()
        server:close()
      else
        client:shutdown()
        client:close()
      end
    end)
  end)
  print("server started on port: " .. oauth.port)
end

return oauth
