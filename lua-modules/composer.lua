local httpResty = require("resty.http");
local gumbo = require("gumbo");

local _M = {};

function _M.printHtmlLine(prefix, content)
    ngx.print("<p>");
    ngx.print(prefix, " : ", content);
    ngx.print("</p>");
end

function _M.fetchUrl (pageUrl)
    local http = httpResty.new();

    -- _M.printHtmlLine('Attempting to fetch', pageUrl);
    local res, err = http:request_uri(pageUrl, {
        method = "GET",
        scheme = "http",
        headers = {
            ["Content-Type"] = "text/html"
        }
    });

    if err then
        return nil, err;
    end

    local status = tonumber(res.status);
    if (status > 300 and status < 400) then
        local redirectUrl = res.headers["Location"];
        -- _M.printHtmlLine("Redirecting to", redirectUrl);
        return _M.fetchUrl(redirectUrl);
    end

    return res, err;
end

-- TODO: use proper header and footer blocks (from /system/ramme.* ?)
function _M.wrap(content)
    return '<div style="display:block; margin: 0.5rem 0; background: #ffc"><p>Header</p></div>'
            .. '<hr />'
            .. content.innerHTML
            .. '<hr />'
            .. '<div style="display: block; margin: 0.5rem 0; background: #ffc"><p>Footer</p></div>';
end

function _M.extractPage(pageUrl)
    local res, err = _M.fetchUrl(pageUrl);

    if err then
        _M.printHtmlLine("error", err);
        return ;
    end

    if not res then
        _M.printHtmlLine("No content");
        return ;
    end

    local body = gumbo.parse(res.body);
    local content = body:getElementById('content');

    if (content == nil) then
        _M.printHtmlLine('Could not extract "content" from body');
        ngx.print(body.innerHTML);
        return ;
    end

    return _M.wrap(content);
end

return _M;
