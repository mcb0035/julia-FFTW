using Base.Test
export testall

function testall()::Void
    for i=2:10
        z = [1:i;]
        p = plan_fft(z)
#    @test typeof(p) == FFTWchanges.cFFTWplan{Complex{Float64}, -1, false, 1}
        @test p*z ≈ Base.fft(z)
    end
    return nothing
end
