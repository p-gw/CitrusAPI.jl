export export_responses

function export_responses(client::LimeSurveyClient, survey_id::Int, document_type::String; language::Union{Nothing,String}=nothing, completion_status::Union{Nothing,String}="all", heading_type::Union{Nothing,String}="code", response_type::Union{Nothing,String}="short", from::Union{Nothing,Int}=nothing, to::Union{Nothing,Int}=nothing, fields::Union{Nothing,AbstractArray}=nothing)
    payload = construct_payload("export_responses", [client.session_key, survey_id, document_type, language, completion_status, heading_type, response_type, from, to, fields])
    response = call_limesurvey_api(client, payload)
    return response
end

function export_responses(client::LimeSurveyClient, survey_id::Int, sink=nothing; kwargs...)
    isnothing(sink) && throw(ArgumentError("Provide a valid sink argument"))
    response = export_responses(client, survey_id, "csv"; kwargs...)
    df = base64csv_to_sink(response.result, sink)
    return df
end
