export import_question!

function import_question!(client::CitrusClient, survey_id::Int, group_id::Int, data::String, data_type::String; mandatory=false, title::Union{Nothing,String}=nothing, text::Union{Nothing,String}=nothing, help::Union{Nothing,String}=nothing)
    is_mandatory = mandatory ? "Y" : "N"
    payload = construct_payload("import_question", [client.session_key, survey_id, group_id, data, data_type, is_mandatory, title, text, help])
    response = call_limesurvey_api(client, payload)
    return response
end

function import_question!(client::CitrusClient, survey_id::Int, group_id::Int, file; kwargs...)
    isfile(file) || error("Not a file")
    file_name = filename(file)
    file_ext = fileextension(file_name)
    isequal(file_ext, "lsq") || error("Invalid file format")
    data_encoded = base64encode(read(file))
    response = import_question!(client, survey_id, group_id, data_encoded, file_ext; kwargs...)
    return response
end
