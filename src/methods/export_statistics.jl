export export_statistics

"""
    export_statistics(client, survey_id; document_type="pdf", language=nothing, graph=false, group_ids=nothing)

Export survey statistics for remote survey with `survey_id` as a base64 encoded string.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_export_statistics>
"""
function export_statistics(
    client::CitrusClient,
    survey_id::Int;
    document_type::String = "pdf",
    language::Union{Nothing,String} = nothing,
    graph::Bool = false,
    group_ids::Union{Nothing,Int,Vector{Int}} = nothing,
)
    graph_string = graph ? "1" : "0"
    payload = construct_payload(
        "export_statistics",
        [client.session_key, survey_id, document_type, language, graph_string, group_ids],
    )
    response = call_limesurvey_api(client, payload)
    return response
end
