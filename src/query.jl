function construct_payload(method::AbstractString, params)
    request_id = string(UUIDs.uuid4())
    payload = Dict("method" => method, "params" => params, "id" => request_id)
    json_payload = JSON3.write(payload, dateformat = dateformat"yyyy-mm-dd HH:MM:SS")
    return json_payload
end

function construct_headers()
    headers = Dict("Content-type" => "application/json")
    return headers
end

function call_limesurvey_api(client::CitrusClient, payload; authenticated = true)
    if (authenticated && isnothing(client.session_key))
        throw(AuthenticationError("Authentication is required to run this query"))
    end

    headers = construct_headers()
    response = HTTP.post(client.url, headers, payload; client.http_args...)
    parsed_body = JSON3.read(response.body)

    if !isnothing(parsed_body.error)
        throw(LimeSurveyError(parsed_body.error))
    end

    if parsed_body.result isa JSON3.Object && haskey(parsed_body.result, :status)
        err = parsed_body.result.status
        if err != "OK"
            err = replace(err, "Error: " => "")
            throw(LimeSurveyError(err))
        end
    end

    return parsed_body.result
end
