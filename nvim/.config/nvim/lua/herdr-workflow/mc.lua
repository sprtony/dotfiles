local M = {}

local function netrc_path()
  return vim.uv.os_homedir() .. "/.netrc"
end

function M.ensure_netrc(cfg)
  local path = netrc_path()
  local entry = string.format("machine %s login %s password %s",
    cfg.host,
    cfg.username or "",
    cfg.password or ""
  )

  local lines = {}
  local f = io.open(path, "r")
  if f then
    local skip = false
    for line in f:lines() do
      local host = line:match("^machine%s+(%S+)")
      if host == cfg.host then
        skip = true
      elseif host then
        skip = false
      end
      if not skip then
        table.insert(lines, line)
      end
    end
    f:close()
  end
  table.insert(lines, entry)

  local out = io.open(path, "w")
  if not out then
    error("no se pudo escribir .netrc")
  end
  for _, line in ipairs(lines) do
    out:write(line .. "\n")
  end
  out:close()
  vim.fn.setfperm(path, "rw-------")
end

function M.interactive_cmd(root, cfg)
  M.ensure_netrc(cfg)
  local port_part = ""
  if cfg.port and cfg.port ~= 21 then
    port_part = ":" .. cfg.port
  end
  local remote_path = cfg.remotePath or "/"
  if remote_path:sub(1, 1) ~= "/" then
    remote_path = "/" .. remote_path
  end
  local protocol = tostring(cfg.protocol or "ftp"):lower()
  local scheme = (protocol == "sftp") and "sftp" or "ftp"
  local url = string.format("%s://%s%s%s", scheme, cfg.host, port_part, remote_path)
  return string.format("mc %s %s", vim.fn.shellescape(root), url)
end

return M
