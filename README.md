**BolivarCoin**

https://github.com/validierungcc/BolivarCoin-docker

https://github.com/BOLI-Project/BolivarCoin


minimal example docker-compose.yml

     ---
    services:
        bolivar:
            container_name: bolivar
            image: vfvalidierung/bolivarcoin:latest
            restart: unless-stopped
            ports:
                - '4555:4555'
                - '127.0.0.1:4444:4444'
            volumes:
                - 'bolivarcoin_data:/bolivar/.Bolivarcoin'
    volumes:
       bolivarcoin_data:

**RPC Access**

    curl --user 'bolivarrpc:<password>' --data-binary '{"jsonrpc":"2.0","id":"curltext","method":"getinfo","params":[]}' -H "Content-Type: application/json" http://127.0.0.1:4444
