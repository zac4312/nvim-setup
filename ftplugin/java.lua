local jdtls = require("jdtls")

local root_markers = {
    ".git",
    "mvnw",
    "gradlew",
    "pom.xml",
    "build.gradle",
}

local root_dir = require("jdtls.setup").find_root(root_markers)

if root_dir == "" then
    return
end

local workspace_folder =
    vim.fn.stdpath("data") ..
    "/site/java/workspace-root/" ..
    vim.fn.fnamemodify(root_dir, ":p:h:t")

local config = {
    cmd = { "jdtls" },
    root_dir = root_dir,
    workspace_folder = workspace_folder,
}

jdtls.start_or_attach(config)
