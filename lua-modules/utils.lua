local _M = {};

function _M.printHtmlLine(prefix, content)
    ngx.print("<p>");
    ngx.print(prefix, " : ", content);
    ngx.print("</p>");
end

function _M.ensureNotNil(e)
    if (not e) then
        return e;
    else
        return '';
    end
end

return _M;
