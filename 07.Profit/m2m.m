function [ Mapping_result ] = m2m (Target,Filter)
%M2M by M
	%Create m2m to chose and get Target's value and extend to the bigger matrix
	%Because matlab provides two kind mapping methods that are "V2V by V" and  "V2M by M" ,but they don't provide the "M2M by M"
	% Example
	% V2V by V (Matlab has provided)
		% octave:61> Target = rand(5,1)
		% Target =

		   % 0.25347
		   % 0.43005
		   % 0.45745
		   % 0.19113
		   % 0.58975

		% octave:62> Filter = [2 3 1 5 4]'
		% Filter =

		   % 2
		   % 3
		   % 1
		   % 5
		   % 4

		% octave:63> Target(Filter)
		% ans =

		   % 0.43005
		   % 0.45745
		   % 0.25347
		   % 0.58975
		   % 0.19113
	
	% V2M by M (Matlab has provided)
		% octave:65> Target = rand(5,1)
		% Target =

		   % 0.785582
		   % 0.569570
		   % 0.855044
		   % 0.910236
		   % 0.071220

		% octave:66> Filter = [2 3 1 5 4;1 2 3 4 5; 5 4 3 2 1]'
		% Filter =

		   % 2   1   5
		   % 3   2   4
		   % 1   3   3
		   % 5   4   2
		   % 4   5   1

		% octave:67> Target(Filter)
		% ans =

		   % 0.569570   0.785582   0.071220
		   % 0.855044   0.569570   0.910236
		   % 0.785582   0.855044   0.855044
		   % 0.071220   0.910236   0.569570
		   % 0.910236   0.071220   0.785582
	
	% M2M by M (Matlab hasn't provided)
	% Wrong Example
		% octave:68> Target = rand(5,5)
		% Target =

		   % 0.571649   0.492933   0.324133   0.830824   0.764597
		   % 0.189477   0.840143   0.489635   0.187841   0.857060
		   % 0.808981   0.243241   0.851421   0.470189   0.765653
		   % 0.774050   0.732144   0.124777   0.013534   0.233650
		   % 0.792751   0.396876   0.566783   0.135197   0.107273

		% octave:69> Filter = repmat([1:5]',1,5)
		% Filter =

		   % 1   1   1   1   1
		   % 2   2   2   2   2
		   % 3   3   3   3   3
		   % 4   4   4   4   4
		   % 5   5   5   5   5

		% octave:70> Target(Filter)
		% ans =

		   % 0.57165   0.57165   0.57165   0.57165   0.57165
		   % 0.18948   0.18948   0.18948   0.18948   0.18948
		   % 0.80898   0.80898   0.80898   0.80898   0.80898
		   % 0.77405   0.77405   0.77405   0.77405   0.77405
		   % 0.79275   0.79275   0.79275   0.79275   0.79275
		%SO the result is wrong. The value of each column is the same.
	
	
	
	%If Taget's size is [M X 1] which means it's vector, the easy way to chose and get Target's value is Taget(order), no matter "order" is vector or matrix
	%But if Taget and order are Matrix, we can't use this way to mapping and extend.
	%So we can use the Target's address to archive the goal.   
	% M2M by M
	% octave:73> m2m(Target,Filter)
	% warning: operator +: automatic broadcasting operation applied
	% Mapping_result =

	   % 0.571649   0.492933   0.324133   0.830824   0.764597
	   % 0.189477   0.840143   0.489635   0.187841   0.857060
	   % 0.808981   0.243241   0.851421   0.470189   0.765653
	   % 0.774050   0.732144   0.124777   0.013534   0.233650
	   % 0.792751   0.396876   0.566783   0.135197   0.107273

	% ans =

	   % 0.571649   0.492933   0.324133   0.830824   0.764597
	   % 0.189477   0.840143   0.489635   0.187841   0.857060
	   % 0.808981   0.243241   0.851421   0.470189   0.765653
	   % 0.774050   0.732144   0.124777   0.013534   0.233650
	   % 0.792751   0.396876   0.566783   0.135197   0.107273
[ R , C ] = size(Target);
Filter_modify = Filter .+ ( R*(0:C-1) );
Mapping_result = Target(Filter_modify);


end
