# activate endpoints
include("methods/activate_survey.jl")
include("methods/activate_tokens.jl")

# add endpoints
include("methods/add_group.jl")
include("methods/add_language.jl")
include("methods/add_participants.jl")
include("methods/add_response.jl")
include("methods/add_survey.jl")

# copy endpoints
include("methods/copy_survey.jl")

# delete endpoints
include("methods/delete_group.jl")
include("methods/delete_language.jl")
include("methods/delete_participants.jl")
include("methods/delete_question.jl")
include("methods/delete_response.jl")
include("methods/delete_survey.jl")

# import endpoints
include("methods/cpd_import_participants.jl")
include("methods/import_group.jl")
include("methods/import_question.jl")
include("methods/import_survey.jl")

# invite endpoints
include("methods/invite_participants.jl")

# mail endpoints
include("methods/mail_registered_participants.jl")

# remind enpoints
include("methods/remind_participants.jl")

# export endpoints
include("methods/export_responses.jl")
include("methods/export_responses_by_token.jl")
include("methods/export_statistics.jl")
include("methods/export_timeline.jl")

# list endpoints
include("methods/list_groups.jl")
include("methods/list_participants.jl")
include("methods/list_questions.jl")
include("methods/list_survey_groups.jl")
include("methods/list_surveys.jl")
include("methods/list_users.jl")

# get endpoints
include("methods/get_group_properties.jl")
include("methods/get_language_properties.jl")
include("methods/get_participant_properties.jl")
include("methods/get_question_properties.jl")
include("methods/get_response_ids.jl")
include("methods/get_site_settings.jl")
include("methods/get_summary.jl")
include("methods/get_survey_properties.jl")
include("methods/get_uploaded_files.jl")

# set endpoints
include("methods/set_group_properties.jl")
include("methods/set_language_properties.jl")
include("methods/set_participant_properties.jl")
include("methods/set_question_properties.jl")
include("methods/set_quota_properties.jl")
include("methods/set_survey_properties.jl")

# update endpoints
include("methods/update_response.jl")

# upload endpoints
include("methods/upload_file.jl")

# session key endpoints
include("methods/get_session_key.jl")
include("methods/release_session_key.jl")
