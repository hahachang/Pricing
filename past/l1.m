%% Psych 216A Matlab Tutorial #1
% This matlab tutorial is intended to compliment lecture #1.  Throughout
% this course we will provide examples of how to implement the concepts
% that are covered in lecture.
%
% Written by Jason D. Yeatman March 2012

%% (1) Exploring a simple data set; one variable, one condition

% Simulating data is incredibly useful.  The function randn generates data
% containing values that are randomly drawn from a gaussian distribution
% with a mean of 0 and a standard deviation of 1.  We will be using this
% function regularly throughout the course.

% create a 1x100 vector of Gaussian data
d0   = randn(1, 100);
% calculate the mean of our data
m0   = mean(d0);
% calculate the standard deviation
sd0  = std(d0);

% plot a histogram of the data with 15 bins.
figure(1);
hist(d0,15);

% mark the location of the mean +/- 1 standard deviation.  To do this we
% are going to plot a circle at the height of the tallest bin at the
% location of the mean. To add more graphics to the plot we must first turn
% hold on so matlab knows to continue adding things to the same figure
% window rather than plotting data in a new figure.

hold on;
% rather than plotting the bin heights we can assign them to a variable h
h = hist(d0,15);
% find the maximum bin height
binmax = max(h);

% plot the location of the mean
plot(m0,binmax,'ko','markerfacecolor','r', 'markersize',10);

% plot a line the width of 1 standard deviation
plot([m0-sd0, m0+sd0],[binmax, binmax], '-r', 'linewidth', 4);

% now let's calculate the median and the interquartile range
med0 = median(d0);

% to calculate the interquartile range first sort the data so that values
% are in order
d0sorted = sort(d0,'ascend');

% then find the values at the 25th and 75th percentile.  Since we have 100
% values this is simple.
iqr0 = d0sorted([25, 75]);

% alternatively, you can use the prctile.m command to calculate
% the percentiles automatically, e.g. iqr0 = prctile(d0,[25 75]).

% plot the median and interquartile range on the same plot
plot(med0,binmax-1,'ko','markerfacecolor','c', 'markersize',10)
plot(iqr0,[binmax-1, binmax-1], '-c', 'linewidth',4);

% notice that the mean and the median are nearly identical for this data.
% This is an important feature of the gaussian distribution.  If data is
% Gaussian then (1) the mean and the median will on-average approximate
% each other (more so, the more data you have) and (2) mean +/- 1 standard
% deviation spans from the 16th to the 84th percentile (i.e. 50% +/- 68%/2).
% Lets check this assertion by plotting these percentiles around the mean
ci68 = d0sorted([16, 84]);
plot(ci68, [binmax, binmax], '-k','linewidth',2);

% now let's look at the effect of an outlier. Notice that when we add
% outliers to the data the mean does not accurately describe the
% central tendency of the data and the standard deviation does not
% accurately reflect the spread in the data.

% Create a new dataset with the same values as d0 and a few outliers
% horzcat simply adds the new values at the end of the vector d0sorted
d1sorted = horzcat(d0sorted, 40, 41, 45); 
m1 = mean(d1sorted);
sd1 = std(d1sorted);
med1 = median(d1sorted);
ci68 = d1sorted([16, 84]);
iqr1 = d1sorted([25, 75]);

% Now plot the results in a new figure
figure(2); hold on;
hist(d1sorted,15);
h = hist(d1sorted,15);
binmax = max(h);
plot(m1,binmax,'ko','markerfacecolor','r', 'markersize',10);
plot([m1-sd1, m1+sd1],[binmax, binmax], '-r', 'linewidth', 4);
plot(med1,binmax-1,'ko','markerfacecolor','c', 'markersize',10);
plot(iqr1,[binmax-1, binmax-1], '-c', 'linewidth',4);
plot(ci68, [binmax, binmax], '-k','linewidth',2);

% Notice that in this plot the mean is much higher than the median and the
% standard deviation is massive.  Neither the median nor the percentiles
% are drastically affected by the outliers.  Notice that the mean is higher
% than the 84th percentile.  This means that the mean is higher than 84% of
% the values in the data.  Given this distribution the mean and standard
% deviation are poor representations of the central tendency and spread of
% the data.

%% (2) Probability distributions
% The equation for a gaussian is
% p(x) = (1 / (s*sqrt(2*pi))) *exp(-((x-m).^2)/(2*s^2))
% Where m is the mean and s is the standard deviation.  
% We can plot the gaussian function with the appropriate mean
% and standard deviation on both histograms and see how well they fit the
% data

% First we are going to create a vector of x values ranging from the
% minimum value in d0 to the maximum value in d0 spaced by an interval of
% 0.01
x = min(d0):0.01:max(d0);

% now we will loop over the x values and calculate the height of the
% gaussian with the equation above.  This is done by plugging each x value
% into the equation one at a time
for ii = 1:length(x)
    y(ii) = (1 / (sd0*sqrt(2*pi))) * exp(-((x(ii)-m0).^2)/(2*sd0^2));
end

% or, even faster is to perform the computation in vectorized form.
% In general, avoid for-loops whenever possible.  the dot operators
% perform arithmetic element-wise and they are useful for writing
% vectorized code.  for example, why is .* different from * ?
y = (1 / (sd0*sqrt(2*pi))) * exp(-((x-m0).^2)/(2*sd0^2));

% Now we will open a new figure window and plot the gaussian over the
% histagram
figure(3); hold on;

% this plots a histogram, but the y-axis is now in units of relative
% fractions instead of absolute counts.  by doing so, we can now plot the
% actual Gaussian probability distribution on top of the histogram and it
% will comparable in scale.
[nn,xx] = hist(d0);
% This will compute the total area of the histogram by multiplying the bin
% width by the height of the bins.
area = diff(xx(1:2)) * sum(nn);
% Now when we plot the histogram bins we scale them by the total area
% ocupied by the histogram to rescale the histogram to have an area of 1.
% This is an essential feature of a probability distribution
bar(xx,nn/area);
% Now we plot a line with the calculated height of the gaussian, y, for
% each value, x.
plot(x,y,'-r','linewidth',4);
clear x y

% calculate height of the gaussian and plot for d1
figure(4); hold on;
x = min(d1sorted):0.01:max(d1sorted);
y = (1 / (sd1*sqrt(2*pi))) * exp(-((x-m1).^2)/(2*sd1^2));
[nn,xx] = hist(d1sorted);
area = diff(xx(1:2)) * sum(nn);
bar(xx,nn/area);
plot(x,y,'-r','linewidth',4);
clear x y

% Notice that the Gaussian is a good description of the data when the data
% does in fact come from a Gaussian distribution but is a poor
% description when the data is non-Gaussian because of the outliers.

%% (3) Error bars
% First lets simulate a population of 10,000 data points.
% Assume that for whatever we are  measuring this represents the full
% population of measurements.
s = 10000; % population size
N = randn(1,s); % population

% To randomly sample from this population we will use the rand function.
% This function randomely generates numbers between 0 and 1.  We can
% multiply these random numbers by 10,000 and round them so the correspond
% to data points in our popultaion, N.  The ceil function will round
% numbers up to the nearest integer

% here we will sample 100 data points from our population, implying that we
% had colected 100 measurements out of the full population.

sampleSiz = 100; % number of measurements

n = N(ceil(rand(1,sampleSiz) .* s)); % our sample of the population

% The standard error of the mean for this sample is
sem1 = std(n) ./ sqrt(length(n))

% and the 95% confidence interval is
ci1 = [mean(n) - 2*sem1, mean(n) + 2*sem1]

% we can show that the 95% confidence interval obtained from the standard
% error of the mean aproximates the variability in the mean that would be
% obtained when many independent random samples are taken from the
% population

% compute the resampled distribution of the means
mu = [];
for ii = 1:10000
    % take a new random sample for each iteration
    n1 = N(ceil(rand(1,sampleSiz) .* s));
    mu(ii) = mean(n1);
end
sem2 = std(mu)
% compute the 2.5th and 97.5th percetiles. We select the top and bottom
% 2.5% of the data, the resulting interval contains 95% of the data.
ci95 = prctile(mu,[2.5 97.5])  

% visualize results
figure; hold on;
hist(n); 
L(1)=plot(mean(n),2,'y.','markersize',40); 
plot(ci1,[2 2],'y','linewidth',6);
plot(mu,2,'rx','markersize',4);
plot(ci95,[2 2],'k');
L(2)=plot(mean(N),5,'rx','markersize',20);
legend(L,'sample mean','population mean');


%% (4) Non-parametric approaches to error bars
% As we showed above when the data is gaussian then the standard error of
% the mean, can be calculated with the equation sd ./ sqrt(n).  In the
% above simulation roughly 95% of the sample means fell within the 95%
% confidence interval derived from the standard error. This will not be the
% case if the data is not gaussian.  If we do not want to make the gaussian
% assumption we can calculate central tendency (median) and error by
% randomly sampling from our data with replacement.

% here is our sample of 20 data points from our population N
sampleSiz = 20; % number of measurements
s = 10000; % population size
n = N(ceil(rand(1,sampleSiz) .* s)); %our sample of the population

% now we can bootstrap this data to generate a confidence interval around
% the mean and median.
me = []; mn = [];
for ii = 1:10000
    % here is a random sample from our data
    sample = n(ceil(rand(1,sampleSiz) .* sampleSiz));
    % and we can take the median of this sample
    me(ii) = median(sample);
    % and the mean of this sample
    mn(ii) = mean(sample);
end

% compute median of the resampled distribution of medians
med = median(me);
% compute the 2.5th and 97.5th percetiles of the median.
ci95med = prctile(me,[2.5 97.5]);
% mean of the resampled distribution of means
xbar = mean(mn);
% compute the 2.5th and 97.5th percetiles of the mean.
ci95mn = prctile(mn,[2.5 97.5]); 

% Above, we performed bootstrapping manually, so that you have a better
% understanding of what bootstrapping is.  However, MATLAB has a
% built-in command called bootstrp.m, which you may find useful.

% Now repeat the above code using a highly non-Gaussian distribution.
s = 10000; % number of bootstraps
sampleSiz = 20; % number of measurements
N = randn(1,s).^2;
n = N(ceil(rand(1,sampleSiz) .* s));

% now we can bootstrap this data to generate a confidence interval around
% the mean and the median.
me = []; mn = [];
for ii = 1:10000
    % here is a random sample from our data
    sample = n(ceil(rand(1,sampleSiz) .* sampleSiz));
    % and we can take the median of this sample
    me(ii) = median(sample);
    % and the mean of this sample
    mn(ii) = mean(sample);
end

% median of the resampled distribution of medians
med = median(me); 
% mean of the resampled distribution of means
xbar = mean(mn);

% compute the 2.5th and 97.5th percetiles of the median and the mean.
ci95med = prctile(me,[2.5 97.5]);  
ci95mn = prctile(mn,[2.5 97.5]);  

% Can you think of a good way to visualize these results?