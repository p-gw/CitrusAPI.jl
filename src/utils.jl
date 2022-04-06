# file utils
filename(path) = last(splitpath(path))

function fileextension(file; keep_dot=false)
    ext = last(splitext(file))
    keep_dot || return replace(ext, "." => "")
    return ext
end

# parsing utils
base64_to_string(x::AbstractString) = x |> base64decode |> String

function base64csv_to_dataframe(x::AbstractString; kwargs...)::DataFrame
    csv_string = base64_to_string(x)
    csv_io = IOBuffer(csv_string)
    df = CSV.read(csv_io, DataFrame; kwargs...)
    return df
end
