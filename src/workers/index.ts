import LibImage from './libImage.js';
import WASM from '../esm/libImage.wasm';

const libImage = LibImage({
  instantiateWasm: async (imports, receiver) => {
    receiver(await WebAssembly.instantiate(WASM, imports));
  },
});

export const optimizeImage = async ({
  image,
  width = 0,
  height = 0,
  quality = 100,
}: {
  image: BufferSource;
  width?: number;
  height?: number;
  quality?: number;
}) => libImage.then(({ optimize }) => optimize(image, width, height, quality));
