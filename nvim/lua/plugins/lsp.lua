-- ~/.config/nvim/lua/plugins/lsp.lua
return {
	-- ── Mason: installs LSP/formatter/linter binaries ─────────────────────────
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				-- Web dev LSPs
				"html-lsp",
				"css-lsp",
				"typescript-language-server",
				"tailwindcss-language-server",
				"eslint-lsp",
				"emmet-language-server",
				"json-lsp",
				-- Formatters
				"prettier",
				"stylua",
				-- Other
				"lua-language-server",
			},
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			-- Auto-install ensure_installed on startup
			local mr = require("mason-registry")
			mr.refresh(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
		end,
	},

	-- ── Mason-lspconfig bridge ────────────────────────────────────────────────
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		event = "BufReadPre",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"html",
					"cssls",
					"ts_ls",
					"tailwindcss",
					"eslint",
					"emmet_language_server",
					"jsonls",
					"lua_ls",
				},
				automatic_installation = true,
			})
		end,
	},

	-- ── nvim-lspconfig ────────────────────────────────────────────────────────
{
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local on_attach = function(_, bufnr)
                vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
            end

            -- New API: vim.lsp.config + vim.lsp.enable (lspconfig v1.0+)
            local servers = {
                html    = {},
                cssls   = {},
                jsonls  = {},
                ts_ls   = {
                    settings = {
                        typescript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "all",
                                includeInlayVariableTypeHints  = true,
                            },
                        },
                    },
                },
                tailwindcss = {
                    filetypes = {
                        "html", "css",
                        "javascript", "javascriptreact",
                        "typescript", "typescriptreact",
                    },
                    settings = {
                        tailwindCSS = {
                            classAttributes = { "class", "className", "classList" },
                        },
                    },
                },
                eslint  = {},
                emmet_language_server = {
                    filetypes = {
                        "html", "css", "scss",
                        "javascriptreact", "typescriptreact",
                    },
                },
                lua_ls  = {
                    settings = {
                        Lua = {
                            runtime     = { version = "LuaJIT" },
                            workspace   = {
                                checkThirdParty = false,
                                library = vim.api.nvim_get_runtime_file("", true),
                            },
                            diagnostics = { globals = { "vim" } },
                            telemetry   = { enable = false },
                        },
                    },
                },
            }

            for server, extra_opts in pairs(servers) do
                vim.lsp.config(server, vim.tbl_deep_extend("force", {
                    capabilities = capabilities,
                    on_attach    = on_attach,
                }, extra_opts))
                vim.lsp.enable(server)
            end

            -- eslint: fix on save
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern  = { "*.js", "*.jsx", "*.ts", "*.tsx" },
                callback = function()
                    local clients = vim.lsp.get_clients { name = "eslint", bufnr = 0 }
                    if #clients > 0 then vim.cmd "EslintFixAll" end
                end,
            })

            -- Diagnostic UI
            vim.diagnostic.config {
                virtual_text     = { prefix = "●" },
                signs            = true,
                underline        = true,
                update_in_insert = false,
                severity_sort    = true,
                float = {
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            }

            vim.lsp.handlers["textDocument/hover"] =
                vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
            vim.lsp.handlers["textDocument/signatureHelp"] =
                vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
        end,
    },
	-- ── Breadcrumbs ───────────────────────────────────────────────────────────
	{
		"SmiteshP/nvim-navic",
		lazy = true,
		init = function()
			vim.g.navic_silence = true
			-- auto-attach in lspconfig on_attach would be ideal; navic.attach(client, bufnr)
		end,
		opts = {
			lsp = { auto_attach = true },
			highlight = true,
			separator = " › ",
			depth_limit = 5,
		},
		config = function(_, opts)
			require("nvim-navic").setup(opts)
			vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
		end,
	},
}
