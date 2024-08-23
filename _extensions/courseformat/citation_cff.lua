return {
  ["citation"] = function(args, kwargs)
    -- Read the CFF file into a table
    local file = io.open("CITATION.cff", "r")
    local lines = {}
    for line in file:lines() do
        table.insert(lines, line)
    end
    file:close()

    -- Initialize variables to store citation details
    local title, year, month, url = "", "", "", "<the URL specified in citation CFF>"
    local authors = {}

    -- Process each line of the CFF file
    local i = 1
    while i <= #lines do
        local line = lines[i]
        -- Extract title
        if line:match("^title:") then
            title = line:match("^title:%s*(.+)$")
        -- Extract date (year and month)
        elseif line:match("^date%-released:") then
            local date = line:match("^date%-released:%s*'(%d+%-%d+%-%d+)'")
            if date then
                year = date:sub(1, 4)
                month = tonumber(date:sub(6, 7))
            end
        -- Extract authors
        elseif line:match("family%-names:") then
            local family_name = line:match("family%-names:%s*(.+)$")
            local given_name = lines[i - 1]:match("given%-names:%s*(.+)$")
            local affiliation = lines[i + 1] and lines[i + 1]:match("affiliation:%s*(.+)$") or ""
            local orcid = lines[i + 2] and lines[i + 2]:match("orcid:%s*'(.+)'") or ""
            local alias = lines[i + 3] and lines[i + 3]:match("alias:%s*'(.+)'") or ""

            table.insert(authors, {
                family = family_name,
                given = given_name,
                affiliation = affiliation,
                orcid = orcid,
                roles = alias
            })
        -- Extract URL if available
        elseif line:match("^url:") then
            url = line:match("^url:%s*'(.+)'$")
        end
        i = i + 1
    end

    -- Generate APA-style author list
    local apa_authors = {}
    for _, author in ipairs(authors) do
        local name = author.family .. ", " .. string.sub(author.given, 1, 1) .. "."
        table.insert(apa_authors, name)
    end
    local apa_author_str = table.concat(apa_authors, ", ")

    -- Generate APA citation
    local apa_citation = apa_author_str .. " (" .. year .. "). " .. title .. ". " .. url

    -- Generate BibTeX citation
    local bibtex_authors = {}
    for _, author in ipairs(authors) do
        local name = author.family .. ", " .. author.given
        table.insert(bibtex_authors, name)
    end
    local bibtex_author_str = table.concat(bibtex_authors, " and ")

    local bibtex_citation = string.format([[
@misc{YourReferenceHere,
  author = {%s},
  month = {%d},
  title = {%s},
  url = {%s},
  year = {%s}
}]], bibtex_author_str, month, title, url, year)

    -- Generate the author information HTML
    local author_info = "<ul>"
    for _, author in ipairs(authors) do
        local name = author.given .. " " .. author.family
        local orcid_icon = author.orcid and '<a href="' .. author.orcid .. '" target="_blank"><i class="fa-brands fa-orcid" style="color:#a6ce39"></i></a>' or ""
        local affiliation = author.affiliation and '<em>Affiliation</em>: ' .. author.affiliation .. '<br>' or ""
        local roles = author.roles and '<em>Roles</em>: ' .. author.roles or ""

        author_info = author_info .. string.format([[
<li><strong>%s</strong> %s<br>
%s %s
</li>
]], name, orcid_icon, affiliation, roles)
    end
    author_info = author_info .. "</ul>"

    -- Generate the final output in HTML format
    local output = [[
<p>You can cite these materials as:</p>
<blockquote>
<p>]] .. apa_citation .. [[</p>
</blockquote>
<p>Or in BibTeX format:</p>
<pre class="sourceCode bibtex"><code class="sourceCode bibtex">]] .. bibtex_citation .. [[</code></pre>
<p><strong>About the authors:</strong></p>
]] .. author_info .. [[
]]

    -- Return the output as raw HTML
    return pandoc.RawBlock("html", output)
  end
}
