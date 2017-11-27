function Bayesfactor = computeBF_np(obtained,sd)
%Dienes, Z. (2014). Using Bayes to get the most out of non-significant results. Frontiers in psychology, 5.
%uniform distribution of [0 10] was used in the MS
%
normaly = @(mn, variance, x) 2.718283^(- (x - mn)*(x - mn)/(2*variance))/realsqrt(2*pi*variance);
sd2 = sd*sd;

meanoftheory = 0;
sdtheory = 1;
omega = sdtheory*sdtheory;
tail = 2;

lower=0;
upper=10; 
uniform=1; %use a uniform prior from 0 to 10
area = 0;
if uniform == 1
    theta = lower;
else theta = meanoftheory - 5*(omega)^0.5;
end

if uniform == 1
    incr = (upper- lower)/2000;
else incr =  (omega)^0.5/200;
end

for A = -1000:1000
    theta = theta + incr;
    if uniform == 1
        dist_theta = 0;
        if and(theta >= lower, theta <= upper)
            dist_theta = 1/(upper-lower);
        end
    else %distribution is normal
        if tail == 2
            dist_theta = normaly(meanoftheory, omega, theta);
        else
            dist_theta = 0;
            if theta > 0
                dist_theta = 2*normaly(meanoftheory, omega, theta);
            end
        end
    end
    
    height = dist_theta * normaly(theta, sd2, obtained); %p(population value=theta|theory)*p(data|theta)
    area = area + height*incr; %integrating the above over theta
end


Likelihoodtheory = area;
Likelihoodnull = normaly(0, sd2, obtained);
Bayesfactor = Likelihoodtheory/Likelihoodnull;