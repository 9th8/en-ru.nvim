local M = {}
-- nvim_create_autocmd shortcut
local autocmd = vim.api.nvim_create_autocmd


local switch_lib = vim.fs.normalize('~/.local/lib/libInputSourceSwitcher.dylib')

local function get_current_layout()
    return vim.fn.libcall(switch_lib, 'Xkb_Switch_getXkbLayout', '')
end

local saved_layout = get_current_layout()

local user_us_layout_variation = 'com.apple.keylayout.ABC'

function M.setup()
    -- When leaving insert mode:
    -- 1. Save the current layout
    -- 2. Switch to the US layout
    autocmd(
        'InsertLeave',
        {
            pattern = "*",
            callback = function ()
                vim.schedule(function()
                    saved_layout = get_current_layout()
                    vim.fn.libcall(switch_lib, 'Xkb_Switch_setXkbLayout', user_us_layout_variation)
                end)
            end
        }
    )

    -- When Neovim gets focus:
    -- 1. Save the current layout
    -- 2. Switch to the US layout if Normal mode or Visual mode is the current mode
    autocmd(
        'FocusGained',
        {
            pattern = "*",
            callback = function ()
                vim.schedule(function()
                    saved_layout = get_current_layout()
                    local current_mode = vim.api.nvim_get_mode().mode
                    if current_mode == "n" or current_mode == "no" or current_mode == "v" or current_mode == "V" or current_mode == "^V" then
                        vim.fn.libcall(switch_lib, 'Xkb_Switch_setXkbLayout', user_us_layout_variation)
                    end
                end)
            end
        }
    )

    -- When entering Insert mode:
    -- 1. Switch to the previously saved layout
    autocmd(
        'InsertEnter',
        {
            pattern = "*",
            callback = function ()
                vim.schedule(function()
                    vim.fn.libcall(switch_lib, 'Xkb_Switch_setXkbLayout', saved_layout)
                end)
            end
        }
    )

    -- When Neovim loses focus:
    -- 1. Switch to the previously saved layout
    autocmd(
        'FocusLost',
        {
            pattern = "*",
            callback = function ()
                vim.schedule(function()
                    vim.fn.libcall(switch_lib, 'Xkb_Switch_setXkbLayout', saved_layout)
                end)
            end
        }
    )
end


return M
