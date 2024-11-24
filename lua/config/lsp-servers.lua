return {
	templ = {},
	biome = {},
	cssls = {},
	volar = {},
	gopls = {},
	jsonls = {},
	bashls = {},
	lua_ls = {},
	clangd = {},
	svelte = {},
	pyright = {},
	intelephense = {},
	rust_analyzer = {},
	vtsls = {
		filetypes = {
			"typescript",
			"javascript",
			"javascriptreact",
			"typescriptreact",
			"vue",
		},
		settings = {
			typescript = {
				format = {
					enable = false,
				},
				tsserver = {
					maxTsServerMemory = 5096,
				},
			},
			vtsls = {
				tsserver = {
					globalPlugins = {},
				},
			},
		},
		before_init = function(params, config)
			local vuePluginConfig = {
				name = "@vue/typescript-plugin",
				location = require("mason-registry").get_package("vue-language-server"):get_install_path()
					.. "/node_modules/@vue/language-server",
				languages = { "vue" },
				configNamespace = "typescript",
				enableForWorkspaceTypeScriptVersions = true,
			}
			table.insert(config.settings.vtsls.tsserver.globalPlugins, vuePluginConfig)
		end,
	},
	html = {
		filetypes = {
			"html",
			"edge",
			"templ",
			"blade",
		},
	},
	emmet_language_server = {
		filetypes = {
			"html",
			"edge",
			"templ",
			"blade",
			"vue",
		},
	},
}
