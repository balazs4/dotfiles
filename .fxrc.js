// Linux

global.i3windows = function (json) {
  const select = (item, parent) => {
    if (item.window_type !== 'normal') return null;
    return [
      item.id,
      parent.name.padStart(2, ' '),
      item.window_properties.instance.padEnd(16, ' '),
      item.window_properties.title,
    ].join('  ');
  };
  const traverse = (item, parent = null) => {
    const children = item.nodes.map((child) => {
      return traverse(child, item.type === 'workspace' ? item : parent);
    });
    return [select(item, parent), ...children.flat()];
  };
  return traverse(json).filter(Boolean).join('\n');
};
