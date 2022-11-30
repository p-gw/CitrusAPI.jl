using CitrusAPI
using Test

using Base64
using CSV
using DataFrames
using JSON3

function dataframe_to_base64csv(df::DataFrame)
    io = IOBuffer()
    CSV.write(io, df)
    df_encoded = io.data[io.data.!=0x00] |> String |> base64encode
    return df_encoded
end

@testset "CitrusAPI.jl" begin
    @testset "utils.jl" begin
        @test CitrusAPI.filename("test.csv") == "test.csv"
        @test CitrusAPI.filename("./test.csv") == "test.csv"
        @test CitrusAPI.filename("C:/Program Files/test.csv") == "test.csv"

        @test CitrusAPI.fileextension("test.csv") == "csv"
        @test CitrusAPI.fileextension("test.1.csv") == "csv"
        @test CitrusAPI.fileextension("test_1.csv") == "csv"
        @test CitrusAPI.fileextension("./test.csv") == "csv"
        @test CitrusAPI.fileextension("./test.1.csv") == "csv"
        @test CitrusAPI.fileextension("C:/Program Files/test.csv") == "csv"

        encoded = base64encode("Teststring")
        @test CitrusAPI.base64_to_string(encoded) == "Teststring"

        df = DataFrame(a=1:3, b=["a", "b", "c"])
        df_encoded = dataframe_to_base64csv(df)
        @test CitrusAPI.base64csv_to_sink(df_encoded, DataFrame) == df
    end

    @testset "CitrusClient" begin
        url = "https://www.test.co"
        c = CitrusClient(url)
        @test c.url == url
        @test isnothing(c.session_key)
    end

    @testset "API Payloads" begin
        headers = CitrusAPI.construct_headers()
        @test headers isa Dict
        @test headers["Content-type"] == "application/json"

        payload = CitrusAPI.construct_payload("test_method", [1, "a", []])
        @test payload isa String

        payload_obj = JSON3.read(payload)
        @test payload_obj.method == "test_method"
        @test payload_obj.id isa String
        @test payload_obj.params == [1, "a", []]
    end

    @testset "API Methods" begin
        c = CitrusClient("http://127.0.0.1:8082/index.php/admin/remotecontrol")

        @testset "Connection" begin
            @test_throws LimeSurveyError("Invalid user name or password") get_session_key(c, "", "")
            @test_throws LimeSurveyError("Invalid user name or password") connect!(c, "", "")

            @test_throws AuthenticationError release_session_key(c)
            @test_throws AuthenticationError disconnect!(c)

            session_key = connect!(c, "admin", "password")
            @test session_key == c.session_key
            @test disconnect!(c) == "OK"
        end

        connect!(c, "admin", "password")

        @test get_site_settings(c, "versionnumber") isa String
        LS_VERSION = VersionNumber(get_site_settings(c, "versionnumber"))

        @testset "Surveys" begin
            @test_throws LimeSurveyError("No surveys found") list_surveys(c)

            # add some basic surveys
            s1 = add_survey!(c, 123456, "testsurvey-1", "en")
            s2 = add_survey!(c, 111111, "testsurvey-2", "en")
            s3 = add_survey!(c, 222222, "testsurvey-3", "en")

            @test s1 == 123456
            @test s2 == 111111
            @test s3 == 222222

            # surveys require valid languages
            @test_throws LimeSurveyError("Faulty parameters") add_survey!(c, 999999, "testsurvey-4", "invalid language")

            # duplicate survey ids lead to randomized survey ids
            s5 = add_survey!(c, 123456, "testsurvey-5", "en")
            @test s5 != 123456

            # list surveys
            surveys = list_surveys(c)
            @test length(surveys) == 4

            # list surveys (DataFrame sink)
            surveys = list_surveys(c, DataFrame)
            @test surveys isa DataFrame
            @test nrow(surveys) == 4
            @test names(surveys) == ["sid", "surveyls_title", "startdate", "expires", "active"]

            # import surveys
            s6 = import_survey!(c, "limesurvey/999999.lss")
            @test s6 == 999999

            # activate surveys
            @test_throws LimeSurveyError("Invalid survey ID") activate_survey!(c, 100000)
            @test_throws LimeSurveyError("Invalid survey ID") is_active(c, 100000)

            @test_throws LimeSurveyError("Survey does not pass consistency check") activate_survey!(c, s1)
            @test is_active(c, s1) == false

            res = activate_survey!(c, s6)  # s6 contains questions and should be ready to activate
            @test res.status == "OK"
            @test is_active(c, s6) == true

            # copying surves
            res = copy_survey!(c, s6, "survey copy")
            s7 = res.newsid
            @test res.status == "OK"
            @test s7 != s6

            # deleting surveys
            surveys = list_surveys(c, DataFrame)
            @test nrow(surveys) == 6
            @test surveys.sid == string.([s1, s2, s3, s5, s6, s7])
            res = delete_survey!(c, s7)
            @test res.status == "OK"

            surveys = list_surveys(c, DataFrame)
            @test nrow(surveys) == 5
            @test surveys.sid == string.([s1, s2, s3, s5, s6])

            # get survey properties
            s6_props = get_survey_properties(c, s6)
            @test s6_props.sid == string(s6)
            @test s6_props.admin == "Lime Administrator"

            # set survey properties
            new_props = set_survey_properties!(c, s6, Dict("admin" => "Test"))
            @test new_props.admin == true

            s6_new_props = get_survey_properties(c, s6)
            @test s6_new_props.admin == "Test"

            # add language
            @test add_language!(c, s1, "de").status == "OK"
            @test get_survey_properties(c, s1).additional_languages == "de"

            # delete language
            @test delete_language!(c, s1, "de").status == "OK"
            @test get_survey_properties(c, s1).additional_languages == ""

            # get language properties
            default_props = get_language_properties(c, s1)
            @test default_props.surveyls_language == "en"
            @test default_props == get_language_properties(c, s1; language="en")

            props_noexist = get_language_properties(c, s1; language="de")
            @test isnothing(props_noexist.surveyls_language)

            # set language properties
            set_lang = set_language_properties!(c, s1, Dict("surveyls_title" => "testtitle"))
            @test set_lang.status == "OK"
            @test set_lang.surveyls_title == true
            @test get_language_properties(c, s1).surveyls_title == "testtitle"

            # clean up remaining surveys
            for s in [s1, s2, s3, s5, s6]
                res = delete_survey!(c, s)
                @test res.status == "OK"
            end
        end

        @testset "Groups" begin
            s1 = add_survey!(c, 100_000, "testsurvey", "en")
            s2 = add_survey!(c, 100_001, "testsurvey", "en")
            s3 = import_survey!(c, "limesurvey/999999.lss")

            # add question groups
            g1 = add_group!(c, s1, "first group")
            g2 = add_group!(c, s1, "second group", description="description")

            @test g1 isa Integer
            @test g2 isa Integer

            # list groups (basic)
            groups = list_groups(c, s1)
            @test length(groups) == 2

            group1 = groups[findfirst(x -> x.group_order == "0", groups)]
            @test group1.group_name == "first group"
            @test group1.description == ""

            group2 = groups[findfirst(x -> x.group_order == "1", groups)]
            @test group2.group_name == "second group"
            @test group2.description == "description"

            @test_throws LimeSurveyError("No groups found") list_groups(c, s2)

            # list groups (DataFrame sink)
            groups = list_groups(c, s1, DataFrame)
            sort!(groups, :group_order)  # make sure groups are ordered correctly

            @test nrow(groups) == 2
            @test groups[1, :group_name] == "first group"
            @test groups[2, :group_name] == "second group"
            @test groups[1, :description] == ""
            @test groups[2, :description] == "description"

            groups = list_groups(c, s3)
            @test length(groups) == 2

            group1 = groups[findfirst(x -> x.group_order == "1", groups)]
            @test group1.group_name == "question group 1"
            @test group1.description == ""

            group2 = groups[findfirst(x -> x.group_order == "2", groups)]
            @test group2.group_name == "question group 2"
            @test group2.description == ""

            # delete group
            @test delete_group!(c, s1, g2) == g2
            @test_throws LimeSurveyError delete_group!(c, s1, 999)

            # TODO: import_group

            # get group properties
            props = get_group_properties(c, g1)
            @test props.gid == string(g1)
            @test props.group_name == "first group"
            @test props.description == ""

            # set_group_properties
            # TODO: figure out why this fails with LimeSurveyError: No valid Data
            # props = set_group_properties!(c, g1, Dict("description" => "some description"))
            # @test props.description == true
            # props = get_group_properties(c, g1)
            # @test props.description == "some description"

            # clean up surveys
            for s in [s1, s2, s3]
                res = delete_survey!(c, s)
                @test res.status == "OK"
            end
        end

        @testset "Questions" begin
            s = import_survey!(c, "limesurvey/999999.lss")

            # list questions
            questions = list_questions(c, s)
            @test length(questions) == 2
            @test questions[1].question == "Make a long statement!"
            @test questions[1].help == "need help?"
            @test questions[2].question == "Rate on a scale from 1 to 5!"
            @test questions[2].help == "need help?"

            groups = list_groups(c, s)
            gid = parse(Int, last(groups).gid)
            questions_g2 = list_questions(c, s, gid)
            @test length(questions_g2) == 1
            @test questions_g2[1].question == questions[2].question

            # delete question
            qid = parse(Int, questions_g2[1].qid)
            @test_throws LimeSurveyError delete_question!(c, 123)
            @test delete_question!(c, qid) == qid
            @test_throws LimeSurveyError("No questions found") list_questions(c, s, gid)

            # TODO: import question

            # get question properties
            qid = parse(Int, questions[1].qid)
            props = get_question_properties(c, qid)
            @test props.title == "q1"

            # set_question_properties
            props = set_question_properties!(c, qid, Dict("title" => "question1"))
            @test props.title == true
            props = get_question_properties(c, qid)
            @test props.title == "question1"

            # clean up survey
            res = delete_survey!(c, s)
            @test res.status == "OK"
        end

        @testset "Participants" begin
            s = import_survey!(c, "limesurvey/999999.lss")

            # activate tokens
            @test activate_tokens!(c, s).status == "OK"
            @test_throws LimeSurveyError activate_tokens!(c, s)

            # add participants
            participants = [
                Dict("email" => "test1@test.co", "firstname" => "participant", "lastname" => "1"),
                Dict("email" => "test2@test.co", "firstname" => "participant", "lastname" => "2")
            ]

            participants_response = add_participants!(c, s, participants)
            @test length(participants_response) == 2
            @test get.(participants_response, :email) == ["test1@test.co", "test2@test.co"]
            @test get.(participants_response, :firstname) == ["participant", "participant"]
            @test get.(participants_response, :lastname) == ["1", "2"]

            # list participants
            @test length(list_participants(c, s)) == 2
            @test_throws LimeSurveyError("No survey participants found.") list_participants(c, s, 100)

            # get participant properties
            tid = "1"
            token = first(participants_response).token
            @test get_participant_properties(c, s, Dict("tid" => tid)).tid == tid
            @test get_participant_properties(c, s, Dict("token" => token)).token == token
            @test collect(keys(get_participant_properties(c, s, Dict("tid" => tid), properties=["tid", "token"]))) == [:tid, :token]

            # set participant properties
            new_mail = "a@b.co"
            new_participant = set_participant_properties!(c, s, Dict("tid" => tid), Dict("email" => new_mail))
            @test new_participant.email == new_mail
            @test get_participant_properties(c, s, Dict("tid" => tid)).email == new_mail

            # delete participants
            deleted_participants = delete_participants!(c, s, [1])
            @test length(deleted_participants) == 1
            @test deleted_participants[:1] == "Deleted"

            # cpd_import_participants
            # invite_participants
            # mail_registered_participants
            # remind_participants

            # clean up survey
            res = delete_survey!(c, s)
            @test res.status == "OK"
        end

        @testset "Responses" begin
            s = import_survey!(c, "limesurvey/999999.lss")
            q = first(list_questions(c, s))

            activate_survey!(c, s)
            set_survey_properties!(c, s, Dict("alloweditaftercompletion" => "Y"))

            activate_tokens!(c, s)
            add_participants!(c, s, Dict("email" => "test@test.co", "firstname" => "A", "lastname" => "B"))
            token = get_participant_properties(c, s, Dict("tid" => "1")).token

            # export responses
            @test_throws LimeSurveyError export_responses(c, s, "csv")

            # add response
            @test add_response!(c, s, Dict()) == "1"

            qid = q.sid * "X" * q.gid * "X" * q.qid
            @test add_response!(c, s, Dict(qid => "a response")) == "2"

            @test export_responses(c, s, "csv") isa String
            responses = export_responses(c, s, DataFrame)
            @test nrow(responses) == 2
            @test isequal(responses.q1, [missing, "a response"])
            @test isequal(responses.q2, [missing, missing])

            # delete response
            deleted_response = delete_response!(c, s, 1)
            @test deleted_response[:1] == "deleted"
            @test nrow(export_responses(c, s, DataFrame)) == 1

            # update response
            @test update_response!(c, s, Dict("id" => "2", qid => "updated response")) == true
            responses = export_responses(c, s, DataFrame)
            @test nrow(responses) == 1
            @test responses.q1 == ["updated response"]

            # export responses by token
            response = add_response!(c, s, Dict("token" => token))
            @test export_responses_by_token(c, s, "csv", token) isa String
            @test nrow(export_responses_by_token(c, s, token, DataFrame)) == 1

            # get response ids
            @test get_response_ids(c, s, token) == [parse(Int, response)]

            # get summary
            summary = get_summary(c, s)
            @test summary.completed_responses == "2"
            @test summary.incomplete_responses == "0"
            @test summary.full_responses == "2"

            # export statistics
            @test export_statistics(c, s) isa String

            # TODO: export timeline
            # TODO: get uploaded files
            participants = list_participants(c, s)
            token = first(participants).token
            @test length(get_uploaded_files(c, s, token)) == 0

            # TODO: upload file

            # clean up survey
            res = delete_survey!(c, s)
            @test res.status == "OK"
        end

        # list_survey_groups
        @show survey_groups = list_survey_groups(c)
        @test length(survey_groups) == 1

        # list_users
        @test length(list_users(c)) == 1
        @test nrow(list_users(c, DataFrame)) == 1

        # set_quota_properties
    end
end
