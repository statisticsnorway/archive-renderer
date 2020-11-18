# Archive Renderer

Rendering service for content archived in openwayback

## Packages used
- [OpenResty](https://openresty.org) : Nginx + [Lua](https://lua.org) modules
- [LuaRocks](https://luarocks.org) : Package manager for Lua
  - [resty:http](https://github.com/ledgetech/lua-resty-http) : Lua HTTP client for OpenResty
  - [Gumbo](https://github.com/craigbarnes/lua-gumbo) : HtmlParser for lua
- (devel) [docker-compose](https://docs.docker.com/compose/)

## Development

1. Install docker-compose
1. checkout this repository
1. checkout [openwayback](https://github.com/statisticsnorway/openwayback) repository as a sibling. docker-compose uses '../openwayback' context 
   to build and start OWB. 
1. Start the network
   ```bash
   $ docker-compose up --build
   ```
1. Visit : http://localhost:6060
   - **Note 1**: OWB seems to be adamant on using port 8080. At the time of this writing we could not get it 
     to work on a custom port. Please contribute if you have a way of doing it! 
   - **Note 2**: To get a content archive into OWB, simply drop your warc.gz file under an `ssb-archive` folder in the
     OWB project root. It is mounted automatically by docker-compose.
     
## Staging / Prod
- `archive-renderer` and `openwayback` communicate directly through k8s (see platform-dev/openwayback-ar.yaml config)
- It is important to instruct nginx to use the k8s dns (), consequently. 
  ```nginx
  resolver kube-dns.kube-system.svc.cluster.local ipv6=off;
  ```
- Pay careful attention to the environment variables AR's flux config
