local composer = require("composer");
local owbArchivePrefix = os.getenv("OWB_ACCESS_URL")
        .. "/wayback/"
        .. os.getenv("SITE_URL")
        .. "/";

ngx.log(ngx.DEBUG, "owb url for page", owbArchivePrefix .. ngx.var.contentPath);

local headerUrl = os.getenv("SITE_URL") .. '/system/topp';
local headerRes, headerErr = composer.fetchUrl(headerUrl);

--[[
--
-- uncomment the following lines and include in final response when footer is ready!
-- if there is no /system/bunn, we could use the same logic used for pageContent
-- and extract header and footer portions from /system/ramme
--
-- local footerUrl = os.getenv("SITE_URL") .. '/system/bunn';
-- local footerRes, footerErr = composer.fetchUrl(os.getenv("SITE_URL") .. "/system/bunn");
--
--]]

ngx.header["Content-Type"] = "text/html";

if headerErr then
    ngx.say(headerErr);
else
    local header = headerRes.body;
    -- ngx.log(ngx.DEBUG, header);

    local pageContent = composer.extractPage(owbArchivePrefix .. ngx.var.contentPath);
    -- ngx.log(ngx.DEBUG, pageContent);

    local final = (header .. pageContent);
    -- ngx.log(ngx.DEBUG, final);

    ngx.say(final);
end
