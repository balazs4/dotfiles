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

const find = (predicate) => (level) => {
  if (predicate(level)) return level;
  const [found = null] = level.nodes
    .map((node) => find(predicate)(node))
    .filter((x) => x);
  return found;
};

function youtubevideos(json) {
  const findarrays = (obj) => {
    if (obj.length) return obj;
    return Object.values(obj)
      .map((child) => findarrays(child))
      .flat();
  };
  const arrays = findarrays(json).flat();
  if (arrays === null || arrays === undefined) return undefined;
  const videos = arrays.find((x) =>
    x?.itemSectionRenderer?.contents.find((xx) => xx?.videoRenderer)
  )?.itemSectionRenderer?.contents;
  if (videos === null || videos === undefined) return undefined;

  return videos
    .filter((x) => x?.videoRenderer?.videoId)
    .filter((x) => x)
    .map((x) =>
      [
        x.videoRenderer.videoId,
        x.videoRenderer.lengthText.simpleText.padStart(8),
        x.videoRenderer.viewCountText.simpleText.padStart(16),
        x.videoRenderer.title.runs[0].text,
      ].join('\t')
    )
    .join('\n');
}
