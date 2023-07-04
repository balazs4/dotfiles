// Linux Darwin

//carbon function i3windows(json) {
//carbon   const select = (item, parent) => {
//carbon     if (item.window_type !== 'normal') return null;
//carbon     return [
//carbon       item.id,
//carbon       parent.name.padStart(2, ' '),
//carbon       item.window_properties.instance.padEnd(16, ' '),
//carbon       item.window_properties.title,
//carbon     ].join('  ');
//carbon   };
//carbon   const traverse = (item, parent = null) => {
//carbon     return [
//carbon       select(item, parent),
//carbon       ...item.nodes
//carbon         .map((child) =>
//carbon           traverse(child, item.type === 'workspace' ? item : parent)
//carbon         )
//carbon         .flat(),
//carbon     ];
//carbon   };
//carbon   return traverse(json).filter(Boolean).join('\n');
//carbon }

function jwt(json){
  return json.redirects[0].headers['set-cookie'].split(';')[0].split('=')[1];
}
