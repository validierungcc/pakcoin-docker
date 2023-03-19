**Deutsche eMark**

https://deutsche-emark.org/


Example docker-compose.yml

    version: '3.7'
    services:
        emark:
            container_name: emark
            image: validierungcc/emark
            restart: unless-stopped
            ports:
                - '127.0.0.1:4444:4444'
                - '4555:4555'
            volumes:
                - '/root/eMark:/emark/.eMark-volume-2'

Sync will take weeks without a snapshot. A snapshot can be acquired from the official homepage.

**RPC Access**

Currently only by logging into the container:

    docker exec -it emark bash

Then you can access it with curl.

    curl --user '<user>:<password>' --data-binary '{"jsonrpc":"2.0","id":"1","method":"getinfo","params":[]}' -H "Content-Type: application/json" http://127.0.0.1:4444
