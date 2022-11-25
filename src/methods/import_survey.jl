export import_survey!

"""
    import_survey(client, data, data_type; kwargs...)
    import_survey(client, file; kwargs...)

Import a survey to a remote LimeSurvey server.
`data` is a Base64 encoded string of the survey data.
It can be derived from a valid `lss`, `csv`, `txt` or `lsa` file.
The file type is specified by `data_type`.

A survey can also be imported directly froma valid `file`.

## Keyword arguments
- `name`: The new survey name (default: `nothing`)
- `survey_id`: The new survey id (default: `nothing`)

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_import_survey>
"""
function import_survey!(client::CitrusClient, data::String, data_type::String; name::Union{Nothing,String}=nothing, survey_id::Union{Nothing,Int}=nothing)
    payload = construct_payload("import_survey", [client.session_key, data, data_type, name, survey_id])
    response = call_limesurvey_api(client, payload)
    return response
end

function import_survey!(client::CitrusClient, file; kwargs...)
    isfile(file) || error("Not a file")
    file_name = filename(file)
    file_ext = fileextension(file_name)
    file_ext in ["lss", "csv", "txt", "lsa"] || error("Invalid file format")
    data_encoded = base64encode(read(file))
    response = import_survey!(client, data_encoded, file_ext; kwargs...)
    return response
end
