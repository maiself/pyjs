#!/bin/bash
set -e

# create build/work dir
mkdir -p build_tests
cd build_tests


if true; then
    # install wasm env
    # rm -rf $MAMBA_ROOT_PREFIX/envs/pyjs-node-testsar
    micromamba create -n pyjs-node-testsar \
        --platform=emscripten-32 \
        -c https://repo.mamba.pm/emscripten-forge \
        -c https://repo.mamba.pm/conda-forge \
        --yes \
        python pybind11 nlohmann_json pybind11_json numpy pytest bzip2 sqlite zlib libffi pyb2d pydantic



    # # # donload empack config
    # EMPACK_CONFIG=empack_config.yaml
    # echo "donwload empack config"
    # wget -O $EMPACK_CONFIG https://raw.githubusercontent.com/emscripten-forge/recipes/main/empack_config.yaml



    # pack the environment in a js/data file
    empack pack env \
        --env-prefix $MAMBA_ROOT_PREFIX/envs/pyjs-node-testsar \
        --outname python_data \
        --config empack_config.yaml \
        --export-name "global.Module"




fi


# let cmake know where the env is
export PREFIX=$MAMBA_ROOT_PREFIX/envs/pyjs-node-testsar
export CMAKE_PREFIX_PATH=$PREFIX
export CMAKE_SYSTEM_PREFIX_PATH=$PREFIX

# build pyjs
emcmake cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ON \
    -DBUILD_RUNTIME_BROWSER=OFF \
    -DBUILD_RUNTIME_NODE=ON \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    ..


make -j12 node_tests


# make install
# cp ../examples/repl.html .

# python -m http.server
