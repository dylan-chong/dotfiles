return {
  dir = vim.fn.stdpath("config"),
  name = "lsp-dont-suck-all-my-ram-forever",
  config = function()
    local dormant = true
    local idle_timer = nil
    local IDLE_TIMEOUT_MS = 3 * 60 * 60 * 1000
    -- local IDLE_TIMEOUT_MS = 10 * 1000
    local PREFIX = "[lsp-dont-suck-all-my-ram-forever] "

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
    end

    wake_up = function()
      if not dormant then
        return
      end
      dormant = false
      log("Waking up")

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

    vim.defer_fn(function()
      vim.api.nvim_create_autocmd(
        { "CursorMoved", "CursorMovedI", "InsertEnter", "TextChanged", "TextChangedI" },
        {
          callback = function()
            if dormant then
              wake_up()
            else
              reset_idle_timer()
            end
          end,
        }
      )
      log("Activity listener registered")
    end, 2000)

    log("Plugin loaded (dormant)")
  end,
}
