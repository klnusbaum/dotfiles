local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
return {
    s("preamble", {
        t({
            "#!/usr/bin/env bash",
            "set -euo pipefail",
            "",
            "",
        }),
    }),
}
