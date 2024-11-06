**BolivarCoin**

https://github.com/validierungcc/BolivarCoin-docker

https://github.com/BOLI-Project/BolivarCoin


minimal example compose.yaml

     ---
    services:
        bolivarcoin:
            container_name: bolivarcoin
            image: vfvalidierung/bolivarcoin:latest
            restart: unless-stopped
            ports:
                - '3893:3893'
                - '127.0.0.1:3563:3563'
            volumes:
                - 'bolivarcoin_data:/bolivar/.Bolivarcoin'
    volumes:
       bolivarcoin_data:

**RPC Access**

    curl --user 'bolivarrpc:<password>' --data-binary '{"jsonrpc":"2.0","id":"curltext","method":"getinfo","params":[]}' -H "Content-Type: application/json" http://127.0.0.1:3563
