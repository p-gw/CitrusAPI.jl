export get_group_properties

"""
    get_group_properties(client, group_id; settings=nothing, language=nothing)

Get the properties of a remote group with `group_id`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_get_group_properties>
"""
function get_group_properties(
    client::CitrusClient,
    group_id::Int;
    settings::Union{Nothing,AbstractArray} = nothing,
    language::Union{Nothing,String} = nothing,
)
    payload = construct_payload(
        "get_group_properties",
        [client.session_key, group_id, settings, language],
    )
    response = call_limesurvey_api(client, payload)
    return response
end
