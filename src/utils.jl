filename(path) = last(splitpath(path))

function fileextension(file; keep_dot=false)
    ext = last(splitext(file))
    keep_dot || return replace(ext, "." => "")
    return ext
end
