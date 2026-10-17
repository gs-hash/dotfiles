local ls = require('luasnip')

return {
  ls.parser.parse_snippet({
    trig = 'foreach',
    name = 'foreach (custom)',
    dscr = 'Iterate over a C# collection',
    priority = 2000,
  }, 'foreach (${1:var} ${2:item} in ${3:collection})\n{\n\t$0\n}'),
}
