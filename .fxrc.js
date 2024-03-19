//carbon global.i3windows = function (json) {
//carbon   function select(item, parent_item) {
//carbon     if (item.window_type !== 'normal') return null;
//carbon     return [
//carbon       item.id,
//carbon       parent_item.name.padStart(2, ' '),
//carbon       item.window_properties.instance.padEnd(16, ' '),
//carbon       item.window_properties.title,
//carbon     ].join('  ');
//carbon   }
//carbon
//carbon   function traverse(item, parent_item = null) {
//carbon     const children = item.nodes.map((child) => {
//carbon       return traverse(child, item.type === 'workspace' ? item : parent_item);
//carbon     });
//carbon     return [select(item, parent_item), ...children.flat()];
//carbon   }
//carbon
//carbon   return traverse(json).filter(Boolean).join('\n');
//carbon };
