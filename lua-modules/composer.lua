local httpResty = require("resty.http");
local gumbo = require("gumbo");
local utils = require("./utils");

local _M = {};

function _M.fetchUrl (pageUrl)
    local http = httpResty.new();

    -- utils.printHtmlLine('Attempting to fetch', pageUrl);
    local res, err = http:request_uri(pageUrl, {
        method = "GET",
        scheme = "http",
        headers = {
            ["Content-Type"] = "text/html"
        }
    });

    if err then
        utils.printHtmlLine("Error", err);
        ngx.log(ngx.ERR, err);
        return nil, err;
    end

    local status = tonumber(res.status);
    if (status > 300 and status < 400) then
        local redirectUrl = res.headers["Location"];
        -- utils.printHtmlLine("Redirecting to", redirectUrl);
        return _M.fetchUrl(redirectUrl);
    end

    return res, err;
end

-- TODO: use proper header and footer blocks (from /system/ramme.* ?)
function _M.wrap(content)
    return '<div id="page"><div class="sitewrapper">'
            .. content.innerHTML
            .. '</div></div>';
end

-- "http://owb:8080/wayback/(.-)/https://www.qa.ssb.no/";
local OWB_URL_PATTERN = os.getenv("OWB_URL")
        .. '/wayback/(.-)/'
        .. os.getenv("SITE_URL");

-- * NOTE: ------------------------- *
-- * This operation is destructive!! *
-- * ------------------------------- *
function _M.replaceUrls(document, srcUrl, targetUrl)
    for i, element in ipairs(document.links) do
        local origUrl = element:getAttribute("href");
        local subUrl = string.gsub(origUrl, OWB_URL_PATTERN, targetUrl);

        ngx.log(ngx.DEBUG, "Replaced " .. origUrl .. " => " .. subUrl);
        ngx.log(ngx.DEBUG, "(should have used: " .. OWB_URL_PATTERN .. ' => ' .. targetUrl .. ')');

        element:setAttribute("href", subUrl);
    end
end

function _M.errorPayload (msg, err)
    return '<div style="display: block; background: #fcc">'
            .. '<p>' .. utils.ensureNotNil(msg) .. '</p>'
            .. '<p>' .. utils.ensureNotNil(err) .. '</p>'
            .. '</div>';
end

-- arg content: is the content node (NOT html string)
function _M.replaceOWBUrls (document)
    return _M.replaceUrls(document, os.getenv("OWB_URL"), os.getenv("RENDERER_URL"));
end

function _M.extractPage(pageUrl, contentId)
    local res, err = _M.fetchUrl(pageUrl);

    if err then
        return _M.errorPayload('Error while fetching' .. pageUrl, err);
    end

    if not res then
        return _M.errorPayload("Empty result from " .. pageUrl);
    end

    local body = gumbo.parse(res.body);
    _M.replaceOWBUrls(body);

    local content = body:getElementById(contentId or 'content');

    if (content == nil) then
        utils.printHtmlLine('Could not extract "content" from body');
        ngx.log(ngx.ERR, body.innerHTML);
        return _M.errorPayload(
                "Could not extract '"
                        .. contentId
                        .. "' element from html ('"
                        .. pageUrl
                        .. "')");
    end

    return _M.wrap(content);
end

return _M;
