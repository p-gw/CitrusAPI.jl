export import_group!

"""
    import_group!(client, survey_id, data, data_type; name=nothing, description=nothing)
    import_group!(client, survey_id, file; name=nothing, description=nothing)

Import a question group and add it to a remote survey with `survey_id`.
`data` is a Base64 encoded string of the group data.
It can be derived from a valid `lsg` or `csv` file which is specified by `data_type`.

A group can also be imported directly from a valid `lsg` or `csv` file by specifying `file`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_import_group>
"""
function import_group!(
    client::CitrusClient,
    survey_id::Int,
    data::String,
    data_type::String;
    name::Union{Nothing,String} = nothing,
    description::Union{Nothing,String} = nothing,
)
    payload = construct_payload(
        "import_group",
        [client.session_key, survey_id, data, data_type, name, description],
    )
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
