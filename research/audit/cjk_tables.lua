-- Give paragraphs room to wrap in the scoped discussion tables.
local widths = {
  ["对象"] = {0.22, 0.37, 0.36},
  ["结论"] = {0.50, 0.46},
}

function Table(table)
  local row = table.head.rows[1]
  if not row or #row.cells == 0 then
    return table
  end
  local columns = widths[pandoc.utils.stringify(row.cells[1].contents)]
  if not columns or #columns ~= #table.colspecs then
    return table
  end
  local specs = {}
  for index, spec in ipairs(table.colspecs) do
    specs[index] = {spec[1], columns[index]}
  end
  table.colspecs = specs
  return table
end
