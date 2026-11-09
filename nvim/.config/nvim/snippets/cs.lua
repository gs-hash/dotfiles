local ls = require('luasnip')

return {
  ls.parser.parse_snippet(
    { trig = 'class', name = 'Class from filename', priority = 2000 },
    'class ${1:${TM_FILENAME_BASE}}\n{\n    $0\n}'
  ),
}
