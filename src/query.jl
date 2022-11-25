function construct_payload(method::AbstractString, params)
    request_id = string(UUIDs.uuid4())
    payload = Dict(
        "method" => method,
        "params" => params,
        "id" => request_id
    )
    json_payload = JSON3.write(payload)
    return json_payload
end

function construct_headers()
    headers = Dict("Content-type" => "application/json")
    return headers
end

function call_limesurvey_api(client::CitrusClient, payload; authenticated=true)
    if (authenticated && isnothing(client.session_key))
        throw(AuthenticationError("Authentication is required to run this query"))
    end

    headers = construct_headers()
    response = HTTP.post(client.url, headers, payload)
    parsed_body = JSON3.read(response.body)

    if !isnothing(parsed_body.error)
        throw(LimeSurveyError(parsed_body.error))
    end

    if parsed_body.result isa JSON3.Object && haskey(parsed_body.result, :status)
        err = replace(parsed_body.result.status, "Error: " => "")
        throw(LimeSurveyError(err))
    end

    return parsed_body
end
