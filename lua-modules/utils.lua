local _M = {};

function _M.printHtmlLine(prefix, content)
    ngx.print("<p>");
    ngx.print(prefix, " : ", content);
    ngx.print("</p>");
end

return _M;
