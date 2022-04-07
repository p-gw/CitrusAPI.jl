using LimeSurvey
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

@testset "LimeSurvey.jl" begin
    @testset "utils.jl" begin
        @test LimeSurvey.filename("test.csv") == "test.csv"
        @test LimeSurvey.filename("./test.csv") == "test.csv"
        @test LimeSurvey.filename("C:/Program Files/test.csv") == "test.csv"

        @test LimeSurvey.fileextension("test.csv") == "csv"
        @test LimeSurvey.fileextension("test.1.csv") == "csv"
        @test LimeSurvey.fileextension("test_1.csv") == "csv"
        @test LimeSurvey.fileextension("./test.csv") == "csv"
        @test LimeSurvey.fileextension("./test.1.csv") == "csv"
        @test LimeSurvey.fileextension("C:/Program Files/test.csv") == "csv"

        encoded = base64encode("Teststring")
        @test LimeSurvey.base64_to_string(encoded) == "Teststring"

        df = DataFrame(a=1:3, b=["a", "b", "c"])
        df_encoded = dataframe_to_base64csv(df)
        @test LimeSurvey.base64csv_to_sink(df_encoded, DataFrame) == df
    end

    @testset "Client" begin
        url = "https://www.test.co"
        c = Client(url)
        @test c.url == url
        @test isnothing(c.session_key)
    end

    @testset "payloads" begin
        headers = LimeSurvey.construct_headers()
        @test headers isa Dict
        @test headers["Content-type"] == "application/json"

        payload = LimeSurvey.construct_payload("test_method", [1, "a", []])
        @test payload isa String

        payload_obj = JSON3.read(payload)
        @test payload_obj.method == "test_method"
        @test payload_obj.id isa String
        @test payload_obj.params == [1, "a", []]
    end
end
