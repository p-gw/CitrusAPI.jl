export export_statistics

function export_statistics(client::Client, survey_id::Int; document_type::String="pdf", language::Union{Nothing,String}=nothing, graph::Bool=false, group_ids::Union{Nothing,Int,Vector{Int}}=nothing)
    graph_string = graph ? "1" : "0"
    payload = construct_payload("export_statistics", [client.session_key, survey_id, document_type, language, graph_string, group_ids])
    response = call_limesurvey_api(client, payload)
    return response
end
