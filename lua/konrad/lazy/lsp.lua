return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "williamboman/mason.nvim",
        "ray-x/lsp_signature.nvim",
        "nvim-telescope/telescope.nvim",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-vsnip",
        "hrsh7th/vim-vsnip",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
    },
    config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local lsp_signature = require("lsp_signature")
        local cmp = require('cmp')
        local on_attach = function(client, bufnr)
            vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
            if client.server_capabilities.inlayHintProvider then vim.lsp.inlay_hint.enable(true) end
            lsp_signature.on_attach({}, bufnr)
            local opts = { buffer = bufnr, remap = false }
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
            vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
            vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
            vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
            vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
            vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
        end

        vim.lsp.config("pyright",{
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "basic",
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "workspace",
                    },
                    venvPath = vim.fn.expand('%:p:h'),
                    pythonPath = (function()
                        local function get_python_path()
                            if vim.env.VIRTUAL_ENV then
                                return vim.env.VIRTUAL_ENV .. "/bin/python"
                            end
                            local cwd = vim.fn.getcwd()
                            local paths = {
                                cwd .. "/.venv/bin/python",
                                cwd .. "/venv/bin/python",
                            }
                            for _, path in ipairs(paths) do
                                if vim.fn.filereadable(path) == 1 then
                                    return path
                                end
                            end
                            return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
                        end
                        return get_python_path()
                    end)()
                }
            },
        })
        vim.lsp.enable({"pyright"})

        vim.lsp.config("lua_ls",{
            capabilities = capabilities,
            on_attach = on_attach,
            on_init = function(client)
                if client.workspace_folders then
                    local path = client.workspace_folders[1].name
                    if
                        path ~= vim.fn.stdpath("config")
                        and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
                    then
                        return
                    end
                end
                client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                    runtime = {
                        version = "LuaJIT",
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME,
                            "${3rd}/luv/library",
                        },
                    },
                })
            end,
            settings = {
                Lua = {
                    telemetry = {
                        enable = false,
                    },
                },
            },
        })
        vim.lsp.enable({"lua_ls"})

        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'vsnip' },
            }, {
                { name = 'buffer' },
                { name = 'path' },
            })
        })

        vim.diagnostic.config({
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
        vim.o.updatetime = 300
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = function()
                local float_buf, win = vim.diagnostic.open_float(nil, {
                    focus = false,
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                    max_width = 80,
                })
                if win then
                    vim.api.nvim_win_set_option(win, 'wrap', true)
                    vim.api.nvim_win_set_option(win, 'linebreak', true)
                
                    vim.api.nvim_create_autocmd({"BufLeave", "WinScrolled", "InsertEnter"}, {
                        once = true,
                        callback = function()
                            if vim.api.nvim_win_is_valid(win) then
                                vim.api.nvim_win_close(win, true)
                            end
                        end
                    })
                end
            end
        })
    require("mason").setup()
    require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "lua_ls", "copilot"},
        automatic_installation = true,
    })
    end,
}
