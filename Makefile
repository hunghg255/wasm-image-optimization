SHELL=/bin/bash
target: esm workers cjs
esm: src/libImage.cpp
	mkdir -p dist/esm
	emcc -O3 --bind -msimd128 \
    -s WASM=1 -s ALLOW_MEMORY_GROWTH=1 -s ENVIRONMENT=web -s DYNAMIC_EXECUTION=0 -s MODULARIZE=1 -s EXPORT_ES6=1 \
    -s USE_SDL=2 -s USE_SDL_IMAGE=2 \
    -s SDL2_IMAGE_FORMATS='["png","jpg","webp","svg"]' \
    -I libwebp -I libwebp/src $< \
    -o dist/esm/$(basename $(<F)).js \
    libwebp/src/{dsp,enc,utils,dec}/*.c libwebp/sharpyuv/*.c
workers: src/libImage.cpp
	mkdir -p dist/workers
	emcc -O3 --bind -msimd128 \
    -s WASM=1 -s ALLOW_MEMORY_GROWTH=1 -s ENVIRONMENT=web -s DYNAMIC_EXECUTION=0 -s MODULARIZE=1 \
    -s USE_SDL=2 -s USE_SDL_IMAGE=2 \
    -s SDL2_IMAGE_FORMATS='["png","jpg","webp","svg"]' \
    -I libwebp -I libwebp/src $< \
    -o dist/workers/$(basename $(<F)).js \
    libwebp/src/{dsp,enc,utils,dec}/*.c libwebp/sharpyuv/*.c
	rm dist/workers/$(basename $(<F)).wasm
