#Set up
import Pkg
Pkg.activate(@__DIR__)
Pkg.instantiate()
using Plots
using LaTeXStrings
using CSV
using DataFrames
using Roots

## problem 3

function do_snowball(T, dt, C, alpha_i, alpha_0, S, A, B)
    if T <= -10
        alpha = alpha_i
    elseif T <= 10
        alpha = alpha_i+(alpha_0+alpha_i)*(T+10)/20
    else
        alpha = alpha_0
    end
    in_rad = (1-alpha)*S/4
    out_rad = -A-B*T
    T = T +(dt/C)*(in_rad + out_rad)
    return T
end

T_initial = -60:30:10
dt = 0.1
C= 51
alpha_i = 0.5
alpha_0 = 0.3
S= 1368
B = -1.3
A= 221.2
time = 200
steps = Int64(time*dt)
temp_out= zeros(steps)



