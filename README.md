**PakCoin**

https://github.com/validierungcc/pakcoin-docker

https://github.com/Pakcoin-project/pakcoin


minimal example compose.yaml

     ---
    services:
        pakcoin:
            container_name: pakcoin
            image: vfvalidierung/pakcoin:latest
            restart: unless-stopped
            ports:
                - '7867:7867'
                - '127.0.0.1:7866:7866'
            volumes:
                - 'pakcoin_data:/pakcoin/.pakcoin'
    volumes:
       pakcoin_data:

**RPC Access**

    curl --user 'pakcoinrpc:<password>' --data-binary '{"jsonrpc":"2.0","id":"curltext","method":"getinfo","params":[]}' -H "Content-Type: application/json" http://127.0.0.1:7866
