export import_survey!

function import_survey!(client::Client, data::String, data_type::String; name::Union{Nothing,String}=nothing, id::Union{Nothing,Int}=nothing)
    payload = construct_payload("import_survey", [client.session_key, data, data_type, name, id])
    response = call_limesurvey_api(client, payload)
    return response
end

function import_survey!(client::Client, file; kwargs...)
    isfile(file) || error("Not a file")
    file_name = filename(file)
    file_ext = fileextension(file_name)
    file_ext in ["lss", "csv", "txt", "lsa"] || error("Invalid file format")
    data_encoded = base64encode(read(file))
    response = import_survey!(client, data_encoded, file_ext; kwargs...)
    return response
end
