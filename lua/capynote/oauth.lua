local uv = vim.uv

---@class cn.OAuth
local oauth = {}

---@private
---@return integer
function oauth.server()
  local server = uv.new_tcp()
  server:bind("127.0.0.1", 0)
  local port = server:getsockname().port
  server:listen(1, function(err)
    assert(not err, err)
    local client = uv.new_tcp()
    server:accept(client)
    client:read_start(function(err, chunk)
      assert(not err, err)
      if chunk then
        print(chunk)
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
  print("server started on port: " .. port)
  return port
end

return oauth
