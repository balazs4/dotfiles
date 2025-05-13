function i3windows(json) {
  function select(item, parent_item) {
    if (parent_item === null) return null;
    if (item.window_type === 'normal' || item.window_type === 'unknown') {
      return [
        item.id,
        (parent_item?.name || '??').padStart(2, ' '),
        item.window_properties.instance.padEnd(16, ' '),
        item.window_properties.title,
      ].join('  ');
    }
  }
  function traverse(item, parent_item = null) {
    const children = item.nodes.map((child) => {
      return traverse(child, item.type === 'workspace' ? item : parent_item);
    });
    return [select(item, parent_item), ...children.flat()];
  }
  return traverse(json).filter(Boolean).join('\n');
};

function flat(json) {
  const nskv = {};
  let pad = 0;

  function namespace(prefix, obj) {
    Object.entries(obj).map((item) => {
      const [key, value] = item;
      const nskey = [prefix, key].filter(Boolean).join('.');
      if (typeof value === typeof {} && value) {
        namespace(nskey, value);
        return;
      }
      if (nskey.length > pad) {
        pad = nskey.length;
      }
      nskv[nskey] =
        typeof value === 'string' ? value.replace(/\n/g, '\\n') : value;
    });
  }

  namespace(undefined, json);

  return Object.entries(nskv)
    .map((kv) => [kv[0].padEnd(pad), kv[1]].join('\t'))
    .join('\n');
};

// fx@34.0.0 needs global
// fx@36.0.0 does not need global, but it panic sometimes
global.i3windows = i3windows;
global.flat = flat;

