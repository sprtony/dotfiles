local M = {}

local function lftp_dir()
  local home = vim.uv.os_homedir()
  local dir = home .. "/.lftp"
  vim.fn.mkdir(dir, "p")
  return dir
end

local function bookmark_path()
  return lftp_dir() .. "/bookmarks"
end

local function rc_path()
  return lftp_dir() .. "/rc"
end

local function ensure_rc()
  local path = rc_path()
  local needed = {
    ["set ftp:passive-mode yes"] = true,
    ["set ssl:verify-certificate no"] = true,
  }
  local f = io.open(path, "r")
  if f then
    for line in f:lines() do
      needed[line] = nil
    end
    f:close()
  end
  local out = io.open(path, "a")
  if not out then
    return
  end
  for line in pairs(needed) do
    out:write(line .. "\n")
  end
  out:close()
  vim.fn.setfperm(path, "rw-------")
end

local function slug(text)
  return text:gsub("[^%w]", "-"):gsub("-+", "-"):lower()
end

local function scheme(cfg)
  local p = tostring(cfg.protocol or "ftp"):lower()
  if p == "sftp" or p == "ftps" then
    return p
  end
  return "ftp"
end

local function default_port(cfg)
  if scheme(cfg) == "sftp" then
    return 22
  end
  return 21
end

local function url_encode(text)
  return (tostring(text or ""):gsub("[^%w%-%._~]", function(c)
    return string.format("%%%02X", string.byte(c))
  end))
end

local function url_encode_path(path)
  local parts = {}
  for seg in tostring(path or "/"):gmatch("[^/]+") do
    parts[#parts + 1] = url_encode(seg)
  end
  return "/" .. table.concat(parts, "/")
end

local function build_url(cfg)
  return string.format("%s://%s:%s@%s:%s%s",
    scheme(cfg),
    url_encode(cfg.username),
    url_encode(cfg.password),
    cfg.host or "",
    cfg.port or default_port(cfg),
    url_encode_path(cfg.remotePath or "/")
  )
end

local function set_lines(cfg)
  local lines = {
    "set ftp:passive-mode yes",
    "set ssl:verify-certificate no",
  }
  if scheme(cfg) == "sftp" then
    lines[#lines + 1] = "set sftp:auto-confirm yes"
  end
  return lines
end

local function dq(text)
  return '"' .. tostring(text or ""):gsub("\\", "\\\\"):gsub('"', '\\"') .. '"'
end

function M.bookmark_name(root, cfg)
  local base = slug(vim.fn.fnamemodify(root, ":t"))
  local host = slug(cfg.host or "host")
  return string.format("herdr-%s-%s", base, host)
end

function M.ensure_bookmark(root, cfg)
  ensure_rc()
  local name = M.bookmark_name(root, cfg)
  local path = bookmark_path()
  local url = build_url(cfg)

  local lines = {}
  local f = io.open(path, "r")
  if f then
    for line in f:lines() do
      local key = line:match("^(%S+)%s")
      if key ~= name then
        table.insert(lines, line)
      end
    end
    f:close()
  end
  table.insert(lines, string.format("%s %s", name, url))

  local out = io.open(path, "w")
  if not out then
    error("no se pudo escribir bookmark lftp")
  end
  for _, line in ipairs(lines) do
    out:write(line .. "\n")
  end
  out:close()
  vim.fn.setfperm(path, "rw-------")

  return name
end

function M.interactive_cmd(root, cfg)
  local name = M.ensure_bookmark(root, cfg)
  return string.format("lftp %s", name)
end

local function write_script(lines)
  local path = vim.fn.tempname() .. ".lftp"
  local f = io.open(path, "w")
  if not f then
    error("no se pudo crear script lftp")
  end
  for _, line in ipairs(lines) do
    f:write(line .. "\n")
  end
  f:close()
  vim.fn.setfperm(path, "rw-------")
  return path
end

local function script_cmd(root, cfg, body)
  local name = M.ensure_bookmark(root, cfg)
  local lines = { "open " .. name }
  vim.list_extend(lines, set_lines(cfg))
  vim.list_extend(lines, body)
  lines[#lines + 1] = "bye"
  local script = write_script(lines)
  return { "lftp", "-f", script }
end

function M.download_file_cmd(root, cfg, rel_path, dest)
  return script_cmd(root, cfg, {
    "get " .. dq(rel_path) .. " -o " .. dq(dest),
  })
end

function M.upload_file_cmd(root, cfg, local_path, rel_path)
  return script_cmd(root, cfg, {
    "put " .. dq(local_path) .. " -o " .. dq(rel_path),
  })
end

function M.mirror_up_cmd(root, cfg, local_dir, rel_dir)
  return script_cmd(root, cfg, {
    "mirror -R " .. dq(local_dir) .. " " .. dq(rel_dir),
  })
end

function M.mirror_down_cmd(root, cfg, rel_dir, local_dir)
  return script_cmd(root, cfg, {
    "mirror " .. dq(rel_dir) .. " " .. dq(local_dir),
  })
end

return M
