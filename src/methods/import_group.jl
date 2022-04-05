export import_group!

function import_group!(client::Client, survey_id::Int, data::String, data_type::String; name::Union{Nothing,String}=nothing, description::Union{Nothing,String}=nothing)
    payload = construct_payload("import_group", [client.session_key, survey_id, data, data_type, name, description])
    response = call_limesurvey_api(client, payload)
    return response
end

function import_group!(client, survey_id, file; kwargs...)
    isfile(file) || error("Not a file")
    file_name = filename(file)
    file_ext = fileextension(file_name)
    file_ext in ["lsg", "csv"] || error("Invalid file format")
    data_encoded = base64encode(read(file))
    response = import_group!(client, survey_id, data_encoded, file_ext; kwargs...)
    return response
end
