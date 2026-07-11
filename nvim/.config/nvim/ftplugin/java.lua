-- JDTLS (Java LSP) configuration
local jdtls = require('jdtls')
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.env.HOME .. '/.cache/jdtls/workspace/' .. project_name
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

local keymaps = require('spider.lsp_keymaps')

local bundles = {}

vim.list_extend(
  bundles,
  vim.split(
    vim.fn.glob(
      vim.env.HOME .. '/.local/share/java/java-debug/com.microsoft.java.debug.plugin/target/*.jar',
      1
    ),
    '\n'
  )
)

vim.list_extend(
  bundles,
  vim.split(
    vim.fn.glob(vim.env.HOME .. '/.local/share/java/vscode-java-test/server/*.jar', 1),
    '\n'
  )
)

local launcher_jar =
  vim.fn.glob(vim.env.HOME .. '/.local/share/jdtls/plugins/org.eclipse.equinox.launcher_*.jar', 1)

launcher_jar = vim.split(launcher_jar, '\n')[1]

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    '/usr/lib/jvm/java-21-openjdk-amd64/bin/java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-javaagent:' .. vim.env.HOME .. '/.local/share/java/lombok/lombok.jar',
    '-Xmx4g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    -- Eclipse jdtls location
    '-jar',
    launcher_jar,
    -- TODO Update this to point to the correct jdtls subdirectory for your OS (config_linux, config_mac, config_win, etc)
    '-configuration',
    vim.env.HOME .. '/.local/share/jdtls/config_linux',
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
      home = '/usr/lib/jvm/java-21-openjdk-amd64',
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
        -- TODO Update this by adding any runtimes that you need to support your Java projects and removing any that you don't have installed
        runtimes = {
          {
            name = 'JavaSE-21',
            path = '/usr/lib/jvm/java-21-openjdk-amd64',
          },
        },
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
  -- 🔑 Twoje keymapy LSP
  keymaps.on_attach(client, bufnr)

  jdtls.setup_dap({ hotcodereplace = 'auto' })
  require('jdtls.dap').setup_dap_main_class_configs()
end

-- This starts a new client & server, or attaches to an existing client & server based on the `root_dir`.
jdtls.start_or_attach(config)
require('jdtls.setup').add_commands()
