export export_responses

"""
    export_responses(client, survey_id, document_type; language=nothing, completion_status="all", heading_type="code", response_type="short", from=nothing, to=nothing, fields=nothing)

Export responses from remote survey with `survey_id` as `document_type` as a base64 encoded string.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_export_responses>
"""
function export_responses(client::CitrusClient, survey_id::Int, document_type::String; language::Union{Nothing,String}=nothing, completion_status::Union{Nothing,String}="all", heading_type::Union{Nothing,String}="code", response_type::Union{Nothing,String}="short", from::Union{Nothing,Int}=nothing, to::Union{Nothing,Int}=nothing, fields::Union{Nothing,AbstractArray}=nothing)
    payload = construct_payload("export_responses", [client.session_key, survey_id, document_type, language, completion_status, heading_type, response_type, from, to, fields])
    response = call_limesurvey_api(client, payload)
    return response
end

"""
    export_responses(client, survey_id, sink; kwargs...)

Export responses from remote survy with `survey_id` as a Tables.jl compatible `sink`, e.g. `DataFrame`.
"""
function export_responses(client::CitrusClient, survey_id::Int, sink=nothing; kwargs...)
    isnothing(sink) && throw(ArgumentError("Provide a valid sink argument"))
    response = export_responses(client, survey_id, "csv"; kwargs...)
    df = base64csv_to_sink(response.result, sink)
    return df
end
