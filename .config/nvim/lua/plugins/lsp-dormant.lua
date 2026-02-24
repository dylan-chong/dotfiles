return {
  dir = vim.fn.stdpath("config"),
  name = "lsp-dormant",
  config = function()
    local dormant = true
    local overlay_buf = nil
    local overlay_win = nil
    local idle_timer = nil
    local IDLE_TIMEOUT_MS = 3 * 60 * 60 * 1000
    -- local IDLE_TIMEOUT_MS = 5 * 1000
    local PREFIX = "[lsp-dormant] "

    local wake_up

    local function log(msg)
      print(PREFIX .. msg)
    end

    local original_lsp_start = vim.lsp.start
    vim.lsp.start = function(config, opts)
      local name = config and config.name or "unknown"
      if dormant then
        log("vim.lsp.start BLOCKED for " .. name .. " (dormant)")
        return nil
      end
      log("vim.lsp.start called for " .. name)
      return original_lsp_start(config, opts)
    end

    local function stop_all_lsp()
      local clients = vim.lsp.get_clients()
      log("Stopping " .. #clients .. " LSP client(s)")
      for _, client in ipairs(clients) do
        log("  Force-stopping: " .. client.name .. " (id=" .. client.id .. ")")
        client.stop(true)
      end
    end

    local function start_all_lsp()
      local count = 0
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= "" then
          count = count + 1
          local ft = vim.bo[buf].filetype
          log("  Re-emitting FileType for buf " .. buf .. " (ft=" .. ft .. ")")
          vim.api.nvim_buf_call(buf, function()
            vim.api.nvim_exec_autocmds("FileType", { pattern = ft })
          end)
        end
      end
      log("Re-emitted FileType for " .. count .. " buffer(s)")
    end

    local function update_overlay_size()
      if overlay_win and vim.api.nvim_win_is_valid(overlay_win) then
        local width = vim.o.columns
        local height = vim.o.lines
        vim.api.nvim_win_set_config(overlay_win, {
          relative = "editor",
          width = width,
          height = height,
          row = 0,
          col = 0,
        })
        if overlay_buf and vim.api.nvim_buf_is_valid(overlay_buf) then
          vim.bo[overlay_buf].modifiable = true
          local msg = "Press Enter to activate"
          local lines = {}
          for i = 1, height do
            if i == math.floor(height / 2) then
              lines[i] = string.rep(" ", math.floor((width - #msg) / 2)) .. msg
            else
              lines[i] = ""
            end
          end
          vim.api.nvim_buf_set_lines(overlay_buf, 0, -1, false, lines)
          vim.bo[overlay_buf].modifiable = false
        end
        log("Overlay resized to " .. width .. "x" .. height)
      end
    end

    local function show_overlay()
      if overlay_win and vim.api.nvim_win_is_valid(overlay_win) then
        log("Overlay already visible, skipping")
        return
      end

      overlay_buf = vim.api.nvim_create_buf(false, true)
      vim.bo[overlay_buf].bufhidden = "wipe"

      local width = vim.o.columns
      local height = vim.o.lines
      local msg = "Press Enter to activate"
      local lines = {}
      for i = 1, height do
        if i == math.floor(height / 2) then
          lines[i] = string.rep(" ", math.floor((width - #msg) / 2)) .. msg
        else
          lines[i] = ""
        end
      end
      vim.api.nvim_buf_set_lines(overlay_buf, 0, -1, false, lines)
      vim.bo[overlay_buf].modifiable = false

      overlay_win = vim.api.nvim_open_win(overlay_buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = 0,
        col = 0,
        style = "minimal",
        zindex = 100,
      })

      vim.keymap.set("n", "<CR>", function()
        wake_up()
      end, { buffer = overlay_buf, nowait = true })

      log("Overlay shown")
    end

    local function hide_overlay()
      if overlay_win and vim.api.nvim_win_is_valid(overlay_win) then
        vim.api.nvim_win_close(overlay_win, true)
        log("Overlay closed")
      end
      overlay_win = nil
      overlay_buf = nil
    end

    local reset_idle_timer

    local function go_dormant()
      if dormant then
        log("Already dormant, skipping")
        return
      end
      dormant = true
      log("Going dormant")

      if idle_timer then
        idle_timer:stop()
        idle_timer = nil
        log("Idle timer stopped")
      end

      vim.cmd("stopinsert")
      stop_all_lsp()
      show_overlay()
    end

    wake_up = function()
      if not dormant then
        log("Already awake, skipping")
        return
      end
      dormant = false
      log("Waking up")

      hide_overlay()
      start_all_lsp()
      reset_idle_timer()
    end

    reset_idle_timer = function()
      if idle_timer then
        idle_timer:stop()
        idle_timer:close()
      end
      idle_timer = vim.uv.new_timer()
      idle_timer:start(IDLE_TIMEOUT_MS, 0, vim.schedule_wrap(function()
        log("Idle timeout reached (" .. IDLE_TIMEOUT_MS .. "ms)")
        go_dormant()
      end))
    end

    vim.api.nvim_create_autocmd("VimResized", {
      callback = function()
        update_overlay_size()
      end,
    })

    vim.api.nvim_create_autocmd(
      { "CursorMoved", "CursorMovedI", "InsertEnter", "TextChanged", "TextChangedI" },
      {
        callback = function()
          if not dormant then
            reset_idle_timer()
          end
        end,
      }
    )

    vim.api.nvim_create_autocmd("VimEnter", {
      once = true,
      callback = function()
        log("VimEnter fired")
        vim.schedule(function()
          stop_all_lsp()
          show_overlay()
        end)
      end,
    })

    log("Plugin loaded")
  end,
}
