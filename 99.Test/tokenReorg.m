function sTransform = tokenReorg(input)
% Reorganize a single record of a location structure 
sTransform.line = input.location(1);
sTransform.start = input.location(2);
sTransform.end = input.location(3);
sTransform.filename = input.filename; end
