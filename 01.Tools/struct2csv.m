function [] =struct2csv( FileName, Input_Struct )
%make Structure Data export to CSV format

Name  = fieldnames(Input_Struct);
Value = struct2cell(Input_Struct);
Data  ={Name , Value};
cell2csv( [FileName,'.csv' ], Data);


end