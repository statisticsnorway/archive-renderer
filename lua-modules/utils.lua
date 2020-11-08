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

function _M.escapePattern (str)
    return string.gsub(str, "([^%w])", "%%%1")
end

-- 1.2.3. mike testing.. mike testing!
function _M.escesc ()
    local orig = 'https://openwayback.staging-bip-app.ssb.no/wayback/20201027141355/https://www.qa.ssb.no/utdanning/abc';
    local pat = _M.escapePattern('https://openwayback.staging-bip-app.ssb.no/wayback/')
            .. '(%d*)'
            .. _M.escapePattern('/https://www.qa.ssb.no/');
    local rep = 'http://openwayback-ar.ssbno.svc.cluster.local/';

    ngx.print("<p> orig | " .. orig .. "</p>");
    ngx.print("<p> pat | " .. pat .. "</p>");
    ngx.print("<p> rep | " .. rep .. "</p>");

    local res = string.gsub(orig, pat, rep);
    ngx.print("<p> res | " .. res .. "</p>");
    return res;
end

-- 1.2.3. mike testing.. mike testing!
function _M.testEscape()
    local orig = 'https://openwayback.staging-bip-app.ssb.no/wayback/20201027141355/https://www.qa.ssb.no/';
    local pat = 'https://openwayback.staging-bip-app.ssb.no';
    local rep = 'http://openwayback-ar.ssbno.svc.cluster.local/';

    ngx.log(ngx.DEBUG, pat);

    local res = string.gsub(orig, _M.escapePattern(pat), rep);

    ngx.log(ngx.DEBUG, orig .. ' => ' .. res);
    return pat .. ' / ' .. res;
end

return _M;
