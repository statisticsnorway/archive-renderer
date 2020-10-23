local composer = require("composer");
local owbUrl = os.getenv("OWB_URL");

ngx.header["Content-Type"] = "text/html";

local pageContent = composer.extractPage(owbUrl .. ngx.var.contentPath);

ngx.say(pageContent);
