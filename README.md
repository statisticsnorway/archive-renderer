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
- *In Progress* (ref: [MIMIR-134](https://statistics-norway.atlassian.net/browse/MIMIR-134))
