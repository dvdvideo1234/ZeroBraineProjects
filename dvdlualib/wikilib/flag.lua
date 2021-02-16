local wikiFlag = {
    icon = false, -- (TRUE) Use icons for arguments
    erro = false, -- (TRUE) Generate an error on dupe or no docs
    extr = false, -- (TRUE) Use the external wiremod types
    remv = false, -- (TRUE) Replace void type with empty string
    quot = false, -- (TRUE) Place backticks on words containing control symbols links []
    qref = false, -- (TRUE) Quote the string in the link reference
    wdsc = false, -- (TRUE) Outputs the direct wire-based description in the markdown overhead
    mosp = false, -- (TRUE) Enables monospace font for the function names
    ufbr = false, -- (TRUE) Enables reference links generation  when processing tokens
    prep = false, -- (TRUE) Replace key in the link pattern in the replace table. Call formatting
    nxtp = false, -- (TRUE) Utilizes the wire NUMBER datatype when one is not provided ( forced )
    prnt = false, -- (TRUE) Show the parent directory in the tree
    hide = false, -- (TRUE) Show hidden directories
    size = false, -- (TRUE) Show file size when drawing a tree
    unqr = false, -- (TRUE) Use unique reference for every replaced token
    hash = false, -- (TRUE) Show directory hash address
    urls = false, -- (TRUE) Use URLs for the files /wikiFolder.__furl/
    namr = false, -- (TRUE) Use Repo name for the tree name root
}

return wikiFlag
