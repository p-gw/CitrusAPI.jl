filename(path) = last(splitpath(path))

function fileextension(file; keep_dot=false)
    ext = last(splitext(file))
    keep_dot || return replace(ext, "." => "")
    return ext
end

base64_to_string(x::AbstractString) = x |> base64decode |> String

function base64csv_to_sink(x::AbstractString, sink; kwargs...)
    csv_string = base64_to_string(x)
    csv_io = IOBuffer(csv_string)
    tbl = CSV.read(csv_io, sink; kwargs...)
    return tbl
end

mutable struct LimeSurveyError <: Exception
    msg::String
end

Base.showerror(io::IO, e::LimeSurveyError) = print(io, "LimeSurveyError: ", e.msg)

mutable struct AuthenticationError <: Exception
    msg::String
end

Base.showerror(io::IO, e::AuthenticationError) = print(io, "AuthenticationError: ", e.msg)
