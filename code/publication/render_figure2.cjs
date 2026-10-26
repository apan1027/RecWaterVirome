// Authors (code-document order): Jinlong Ru, Cunli Pan.
// Reproduce the accepted publication rasterization; no data or statistical work.
const sharp = require('sharp');
const path = require('path');
(async () => {
  const folder = process.argv[2];
  if (!folder) throw new Error('Supply the folder containing Figure2.svg');
  const buffer = await sharp(path.join(folder, 'Figure2.svg'), { density: 72 })
    .resize(2125, 2917, { fit: 'fill' }).flatten({ background: '#fff' }).png().toBuffer();
  await sharp(buffer).withMetadata({ density: 300 }).toFile(path.join(folder, 'Figure2.png'));
  await sharp(buffer).withMetadata({ density: 300 }).tiff({ compression: 'lzw' })
    .toFile(path.join(folder, 'Figure_2.tif'));
})().catch(error => { process.stderr.write(String(error) + '\n'); process.exitCode = 1; });
