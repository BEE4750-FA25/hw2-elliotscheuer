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
    #interpolate to find correct alpha values
    if T <= -10
        alpha = alpha_i
    elseif T <= 10
        alpha = alpha_i+(alpha_0-alpha_i)*(T+10)/20
    else
        alpha = alpha_0
    end
    in_rad = (1-alpha)*S/4
    out_rad = A-B*T
    T = T +(dt/C)*(in_rad - out_rad) #discretized forward euler equation as found in 3.1
    return T #returns the "current" temperature based off of previous step's temperature
end
#model parameters
T_initial = -60:5:30 #series of intial temps
dt = 0.1
C= 51
alpha_i = 0.5
alpha_0 = 0.3
S= 1368
S_neo = 1272 #Neoproteorozoic solar constant
B = -1.3
A= 221.2
time = 200


function run_snowball(time, T0, dt, C, alpha_i, alpha_0, S, A, B) #change S to S_neo for 3.2
    steps = Int64(time/dt) #total amount of steps
    temp_out= zeros(steps+1)
    temp_out[1]= T0 #let the first temp in the series be the intial temp
    for i in 2:steps #run the snowball step for the total length of time
        T = do_snowball(temp_out[i-1], dt, C, alpha_i, alpha_0, S, A, B)
        temp_out[i] = T
    end
    return temp_out #returns list of length time/dt temperatures
end

all_temps = []


for T0 in T_initial #find the series of temperatures for each intial condition
    label_T = string.(T0)
    temp_out = run_snowball(time, T0, dt, C, alpha_i, alpha_0, S_neo, A, B)
    push!(all_temps,temp_out)
end


plot(0:dt:time, all_temps,
     xlabel="Time (years)", ylabel="Temperature (°C)",
     title="Snowball Climate Model Simulation (S=1368)",
     label=[L"-60°C" L"-55°C" L"-50°C" L"-45°C" L"-40°C" L"-35°C" L"-30°C" L"-25°C" L"-20°C" L"-15°C" L"-10°C" L"-5°C" L"0°C" L"5°C" L"10°C" L"15°C" L"20°C" L"25°C" L"30°C"])
     hline!([14], color=:red, linestyle=:dash, label="T = 14 °C") ##hline added for part 3.3 to demonstrate initial conditions that converge above T=14

### Problem two, originally written on Ally's computer

function problem2(Q0,C0,Q1,v,C1,k,D,Q2,C2,x)
    #calculating box 1 during mixing
    Qmix = Q0 + Q1
    Mmix = Q0*C0 + Q1*C1
    Cmix = Mmix / Qmix
   
    #calculating ODE
    A = Qmix/(v*1000)
    q = D/(v*A)
    lamda = k/v


    ODE = (q/lamda) + ((Cmix/1000) - (q/lamda))*exp(-lamda*x)


    return ODE


end


Q0 = 250000
C0 = 0.5
Q1 = 40000
C1 = 9
k = 0.36
D = 54
v = 10
x = 15


Q2= 60000
C2= 7
xnew = 20


meow = problem2(Q0,C0,Q1,v,C1,k,D,Q2,C2,x)
print(meow)
print("                ")


function problem2box2(Q0,C0,Q1,v,C1,k,D,Q2,C2,x,xnew)
    #from first ODE:
    Qmix = Q0 + Q1
    Mmix = Q0*C0 + Q1*C1
    Cmix = Mmix / Qmix
    #calculating ODE
    A = Qmix/(v*1000)
    q = D/(v*A)


    #calculating box 2 during mixing
    Qtotal = Qmix + Q2
    Mtotal = Qmix*meow + Q2*(C2/1000)


    Ctotal = Mtotal/Qtotal
   
   
    #calculating ODE
    Anew = Qtotal/(v*1000)
    qnew = D/(v*Anew)
    lamda = k/v


    ODE2 = (qnew/lamda) + ((Ctotal) - (qnew/lamda))*exp(-lamda*(xnew-15))


    return ODE2


end


meowbox2 = problem2box2(Q0,C0,Q1,v,C1,k,D,Q2,C2,x,xnew)
print(meowbox2)



