#!/bin/bash

cd "$(dirname "$0")"

if [ -f "51-sources.sh.cpt" ]; then
    echo "Decrypting 51-sources.sh.cpt..."

    if [ "${TDLAS_SETUP}" = "true" ]; then
        echo "Using predefined decryption key..."
        ccrypt -d -c -K "${TDLAS_DECRYPTION_KEY}" 51-sources.sh.cpt >> 51-sources.sh
    else
        echo "Enter password..."
        ccrypt -d -c 51-sources.sh.cpt >> 51-sources.sh
    fi
fi

if [ -f "51-sources.sh" ]; then
    mv -v 51-sources.sh ./temp/
    chmod +x "./temp/51-sources.sh"
    ./temp/51-sources.sh

    if [[ "${TDLAS_TYPE}" = "das" || "${TDLAS_TYPE}" = "DAS" ]]; then
        cd ~/sources/das
        mkdir build
        cd build
        cmake -S .. -B . -D CMAKE_BUILD_TYPE=Release
        make -j4
        sudo make install
        sudo ln -sf /opt/tdlas/das /usr/local/bin/das
        sudo ln -sf /opt/tdlas/broadcast_receiver /usr/local/bin/broadcast_receiver
    fi

    if [[ "${TDLAS_TYPE}" = "wms" || "${TDLAS_TYPE}" = "WMS" ]]; then
        cd ~/sources/cfwms
        mkdir build
        cd build
        cmake -S .. -B . -D CMAKE_BUILD_TYPE=Release
        make -j4
        sudo make install
        sudo ln -sf /opt/tdlas/cfwms /usr/local/bin/cfwms
    fi

    if [[ "${TDLAS_TYPE}" = "tdlas" || "${TDLAS_TYPE}" = "TDLAS" ]]; then
        cd ~/sources/tdlas
        mkdir build
        cd build
        cmake -S .. -B . -D CMAKE_BUILD_TYPE=Release
        make -j4
        sudo make install
        sudo ln -sf /opt/tdlas/tdlas /usr/local/bin/tdlas
        sudo ln -sf /opt/tdlas/dashboard /usr/local/bin/tdlasinfo
        sudo ln -sf /opt/tdlas/broadcast_receiver /usr/local/bin/tdlasbr
    fi
fi