-- JDTLS (Java LSP) configuration
local jdtls = require('jdtls')
local root_dir = require('jdtls.setup').find_root({
  '.git',
  'mvnw',
  'gradlew',
  'pom.xml',
  'build.gradle',
})
if not root_dir then
  return
end

if vim.fn.executable('jdtls') == 0 then
  vim.notify_once('JDTLS is not installed. Run: brew install jdtls', vim.log.levels.WARN)
  return
end

local project_name = vim.fn.fnamemodify(root_dir, ':t')
local workspace_dir = vim.fn.stdpath('cache') .. '/jdtls/workspace/' .. project_name

local debug_bundles = vim.fn.glob(
  vim.fn.expand('~/.local/share/java/java-debug/com.microsoft.java.debug.plugin/target/*.jar'),
  false,
  true
)
local test_bundles =
  vim.fn.glob(vim.fn.expand('~/.local/share/java/vscode-java-test/server/*.jar'), false, true)

local bundles = vim.list_extend(vim.deepcopy(debug_bundles), test_bundles)

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  cmd = {
    'jdtls',
    '-data',
    workspace_dir,
  },

  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = root_dir,

  capabilities = capabilities,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      signatureHelp = { enabled = true },
      format = {
        enabled = false,
        -- Formatting works by default, but you can refer to a specific file/URL if you choose
        -- settings = {
        --   url = "https://github.com/google/styleguide/blob/gh-pages/intellij-java-google-style.xml",
        --   profile = "GoogleStyle",
        -- },
      },
    },
    completion = {
      favoriteStaticMembers = {
        'org.hamcrest.MatcherAssert.assertThat',
        'org.hamcrest.Matchers.*',
        'org.hamcrest.CoreMatchers.*',
        'org.junit.jupiter.api.Assertions.*',
        'java.util.Objects.requireNonNull',
        'java.util.Objects.requireNonNullElse',
        'org.mockito.Mockito.*',
      },
      importOrder = {
        'java',
        'javax',
        'com',
        'org',
      },
    },
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
      },
      useBlocks = true,
    },
  },
  -- Needed for auto-completion with method signatures and placeholders
  flags = {
    allow_incremental_sync = true,
  },
  init_options = {
    -- References the bundles defined above to support Debugging and Unit Testing
    bundles = bundles,
  },
}

-- Needed for debugging
config['on_attach'] = function(client, bufnr)
  if #debug_bundles > 0 then
    jdtls.setup_dap({ hotcodereplace = 'auto' })
    require('jdtls.dap').setup_dap_main_class_configs()
  end
end

-- This starts a new client & server, or attaches to an existing client & server based on the `root_dir`.
jdtls.start_or_attach(config)
require('jdtls.setup').add_commands()
