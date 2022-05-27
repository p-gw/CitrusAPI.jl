export add_survey!

"""
    add_survey!(client, survey_id, title, language; format)

Adds an empty survey with `survey_id` , `title` and default language `language`.
Optional parameter `format` sets the question appearance format of the survey.

See also: https://api.limesurvey.org/classes/remotecontrol_handle.html#method_add_survey
"""
function add_survey!(client::LimeSurveyClient, survey_id::Int, title::AbstractString, language::AbstractString; format::AbstractString="G")
    payload = construct_payload("add_survey", [client.session_key, survey_id, title, language, format])
    response = call_limesurvey_api(client, payload)
    return response
end
