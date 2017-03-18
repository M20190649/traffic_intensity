classdef DatabaseHandler
    %Support Database operation through the .NET Interface
	
    properties(GetAccess='private', SetAccess='private')
        ConnectionString % Connection String
        Connection % System.Data.SqlClient.SqlConnection instance
    end
    methods(Static = true)
        % Replaces empty entries with corresponding default values
        function x = ReplaceEmpty(x, fieldName, isNumber)
            if isempty(x.(fieldName))
                if isNumber
                    x.(fieldName) = NaN;
                else
                    x.(fieldName) = ' ';
                end
            end
        end
    end
    
    methods
        % Constructor
        function this = DatabaseHandler(connectionString)
            this.ConnectionString = connectionString;
            NET.addAssembly('System.Data');
            import System.Data.*;
            import System.Data.SqlClient.*;
            this.Connection = System.Data.SqlClient.SqlConnection(this.ConnectionString);
            this.Connection.Open();
        end
        
        function ResetDatabaseTables(this, tableNames)
            for i = 1:length(tableNames)
                ds = this.SelectAll(tableNames{i});
                this.DeleteTableElements(tableNames{i}, ds);
            end
        end
        
        function result = SqlQuery(this, query)
            try
                NET.addAssembly('System.Data');
                import System.Data.*;
                import System.Data.SqlClient.*;
                
                cmd = System.Data.SqlClient.SqlCommand(query);
                cmd.Connection = this.Connection;
                
                str = System.String(query);
                
                if str.ToLower().Trim().StartsWith('select')
                    % Execute the query and get the reader
                    reader = cmd.ExecuteReader();
                    
                    colsNum = reader.FieldCount;
                    
                    % First get the column names
                    colsNames = {};
                    for i = 0:colsNum-1
                        colsNames{end + 1} = char(reader.GetName(i));
                    end
                    
                    result = dataset();
                    rows = [];
                    while reader.Read()
                        row = cell(1, colsNum);
                        
                        for i = 1:colsNum
                            value = reader.Item(i - 1);
                            cls = class(value);
                            
                            switch cls
                                case 'System.String'
                                    row{i} = char(value);
                                case 'System.DateTime'
                                    dt = value.ToOADate();
                                    
                                    if dt > 0
                                        row{i} = dt;
                                    else
                                        row{i} = NaN;
                                    end
                                case 'System.DBNull'
                                    row{i} = NaN;
                                otherwise % int32, double, etc.
                                    row{i} = value;
                            end
                        end
                        
                        rows = [rows; row];
                    end
                    
                    if ~isempty(rows)
                        for i = 1:colsNum
                            result = [result dataset(rows(:, i), 'VarNames', colsNames(i))];
                        end
                    end
                    
                    reader.Close();
                else
                    result = cmd.ExecuteNonQuery();
                end
                
            catch ME
                errordlg(['Exception:' getReport(ME, 'extended')]);
            end
        end
        
        function colsNames = GetTableColsNames(this, tableName)
            NET.addAssembly('System.Data');
            import System.Data.*;
            import System.Data.SqlClient.*;
            
            query = ['Select TOP 1 * from ' tableName];
            cmd = System.Data.SqlClient.SqlCommand(query);
            cmd.Connection = this.Connection;
            
            % Execute the query and get the reader
            reader = cmd.ExecuteReader();
            
            colsNum = reader.FieldCount;
            % First get the column names
            colsNames = {};
            for i = 0:colsNum-1
                colsNames{end + 1} = char(reader.GetName(i));
            end
            
            reader.Close();
        end
        
        function result = SelectAll(this, tableName, condQuery)
            query = ['Select * from ' tableName];
            
            if exist('condQuery', 'var')
                query = [query ' ' condQuery];
            end
            
            result = this.SqlQuery(query);
        end
        %+++++++++++++++++++++++
             function result = SelectCell(this, tableName, Cellname, selectDate, condQuery)
            query = ['Select cell, startDateTime, totPSRRCAtts FROM ' tableName ...
              ' ' 'WHERE cell =' '''' Cellname ''''];
              hh = selectDate.hour;
                 dd = selectDate.day;
                 mm = selectDate.month;
                 yy =selectDate.year;
                 query = ['SELECT cast(datename(hour,startDateTime) as int) as h,' ...
                     ' cast(datename(day,startDateTime) as int) as dd,'...
                     ' cast(datename(minute,startDateTime) as int) as mm,'...
                     ' cell as name,'...
                     ' totPSRRCAtts as psrrc,'...
                     ' kpi16 as kp16'...
                     ' FROM ' tableName...
                     ' where datename(hour,startDateTime) = ' hh...
                     ' and'...
                     ' datename(day,startDateTime) =' dd...
                     ' and'...
                     ' cell LIKE ' '''' Cellname ''''];
            if exist('condQuery', 'var')
                query = [query ' ' condQuery];
            end
            
            result = this.SqlQuery(query);
             end
        %+++++++++++++++++++++++
         
          %+++++++++++++++++++++++
             function result = SelectLocationTable(this, tableName, condQuery)
            query = ['Select DISTINCT name,latitude,longitude, utm_northing , utm_easting FROM '...
                tableName ...
              ];
          
            if exist('condQuery', 'var')
                query = [query ' ' condQuery];
            end
            
            result = this.SqlQuery(query);
             end
        %+++++++++++++++++++++++
                %+++++++++++++++++++++++
             function result = SelectWithTime(this, tableName, Cellname, selectDate, condQuery)
                 hh = selectDate.hour;
                 hk = selectDate.hour_end;
                 dd = selectDate.day;
                 mm = selectDate.month;
                 yy =selectDate.year;
                 % In the specific wms_kpi table 'startDateTime' is the
                 % variable containing the date.  
                 query = ['SELECT cast(datename(hour,startDateTime) as int) as h,' ...
                     ' cast(datename(day,startDateTime) as int) as dd,'...
                     ' cast(datename(minute,startDateTime) as int) as mm,'...
                     ' cell as name,'...
                     ' totPSRRCAtts as psrrc,'...
                     ' kpi16 as kp16'...
                     ' FROM ' tableName...
                     ' where datename(hour,startDateTime) BETWEEN ' hh ' AND ' hk ...
                     ' and'...
                     ' datename(day,startDateTime) >' dd...
                     ' and'...
                     ' cell LIKE ' '''' Cellname ''''];
            if exist('condQuery', 'var')
                query = [query ' ' condQuery];
            end
            
            result = this.SqlQuery(query);
             end
        %+++++++++++++++++++++++
        %+++++++++++++++++++++++
             function result = SelectWithTimePlus(this, tableName, Cellname, selectDate, condQuery)
                 hh = selectDate.hour;
                 hk = selectDate.hour_end;
                 dd = selectDate.day;
                 mm = selectDate.month;
                 yy =selectDate.year;
                 % In the specific wms_kpi table 'startDateTime' is the
                 % variable containing the date.  
                 query = ['SELECT cast(datename(hour,startDateTime) as int) as h,' ...
                     ' cast(datename(day,startDateTime) as int) as dd,'...
                     ' cast(datename(minute,startDateTime) as int) as mm,'...
                     ' cell as name,'...
                     ' totPSRRCAtts as psrrc,'...
                     ' kpi16 as kp16'...
                     ' FROM ' tableName...
                     ' where datename(hour,startDateTime) BETWEEN ' hh ' AND ' hk ...
                     ' and'...
                     ' datename(day,startDateTime) >=' dd...
                     ' and'...
                     ' totPSRRCAtts > 1000'...
                     ' and'...
                     ' cell LIKE ' '''' Cellname ''''];
            if exist('condQuery', 'var')
                query = [query ' ' condQuery];
            end
            
            result = this.SqlQuery(query);
             end
        %+++++++++++++++++++++++
         %+++++++++++++++++++++++
             function result = SelectForHist(this, tableName, Cellname, selectDate, condQuery)
                 %this function takes infinitely longer than presorting the
                 %table directly in MySQL for some reason.  But good
                 %learning tool.
%                  query = ['Select cell, startDateTime, totPSRRCAtts FROM ' tableName ...
%               ' ' 'WHERE cell =' '''' Cellname ''''];
                 hh = selectDate.hour;
                 hk = selectDate.hour_end;
                 dd = selectDate.day;
                 mm = selectDate.month;
                 yy =selectDate.year;
                 % In the specific wms_kpi table 'startDateTime' is the
                 % variable containing the date.  
                 query = ['SELECT cast(datename(hour,startDateTime) as int) as h,' ...
                     ' cast(datename(day,startDateTime) as int) as dd,'...
                     ' cast(datename(minute,startDateTime) as int) as mm,'...
                     ' cell as name,'...
                     ' totPSRRCAtts as psrrc,'...
                     ' kpi16 as kp16'...
                     ' FROM ' tableName ];
            if exist('condQuery', 'var')
                query = [query ' ' condQuery];
            end
            
            result = this.SqlQuery(query);
             end
        %+++++++++++++++++++++++
        
        function InsertTableElements(this, tableName, insertDataset)
            insertQuery = ['INSERT INTO ' tableName];
            
            insertNames = get(insertDataset, 'VarNames');
            
            cols = '(';
            for i = 1:length(insertNames)
                cols = [cols insertNames{i}];
                
                if i == length(insertNames)
                    cols = [cols ')'];
                else
                    cols = [cols ','];
                end
            end
            
            for i = 1:size(insertDataset, 1)
                for k = 1:length(insertNames)
                    if k == 1
                        valuesQuery = 'Values(';
                    end
                    if ischar(insertDataset{i, k})
                        valuesQuery = [valuesQuery '''' insertDataset{i, k} ''''];
                    elseif isnan(insertDataset{i, k})
                        valuesQuery = [valuesQuery 'NULL'];
                    else
                        valuesQuery = [valuesQuery num2str(insertDataset{i, k})];
                    end
                    
                    if k ~= length(insertNames)
                        valuesQuery = [valuesQuery ' , '];
                    else
                        valuesQuery = [valuesQuery ')'];
                        result = this.SqlQuery([insertQuery ' ' cols ' ' valuesQuery]);
                    end
                end
            end
        end
        
        function DeleteTableElements(this, tableName, tableDataset)
            primaryNames = get(tableDataset, 'VarNames');
            deleteQuery = ['DELETE FROM ' tableName];
            
            for i = 1:size(tableDataset, 1)
                whereQuery = 'WHERE ';
                
                for k = 1:length(primaryNames)
                    tf = false;
                    if ischar(tableDataset{i, k}) && ~strcmpi(tableDataset{i, k}, ' ')
                        tmpQuery = [' ' primaryNames{k} '=''' tableDataset{i, k} ''''];
                        tf = true;
                    elseif isnumeric(tableDataset{i, k}) && ~isnan(tableDataset{i, k})  && isinteger(tableDataset{i, k})% we disregard empty fields since they cannot primary keys.
                        tmpQuery = [' ' primaryNames{k} '=' num2str(tableDataset{i, k})];
                        tf = true;
                    end
                    
                    if tf
                        if k > 1
                            whereQuery = [whereQuery ' AND ' tmpQuery];
                        else
                            whereQuery = [whereQuery tmpQuery];
                        end
                    end
                end
                
                result = this.SqlQuery([deleteQuery ' ' whereQuery]);
            end
        end
        
        function UpdateTableElements(this, tableName, primaryNames, primaryValues, updateNames, updateValues)
            
            updateQuery = ['UPDATE ' tableName];
            
            for i = 1:size(primaryValues, 1)
                setQuery = 'SET ';
                whereQuery = 'WHERE ';
                
                for k = 1:length(primaryNames)
                    if ischar(primaryValues{i, k})
                        whereQuery = [whereQuery primaryNames{k} '=''' primaryValues{i, k} ''''];
                    else
                        whereQuery = [whereQuery primaryNames{k} '=' num2str(primaryValues{i, k})];
                    end
                    
                    if k ~= length(primaryNames)
                        whereQuery = [whereQuery ' AND '];
                    end
                end
                
                for k = 1:length(updateNames)
                    if ischar(updateValues{i, k})
                        setQuery = [setQuery updateNames{k} '=''' updateValues{i, k} ''''];
                    elseif isnan(updateValues{i, k})
                        setQuery = [setQuery updateNames{k} '=NULL'];
                    else
                        setQuery = [setQuery updateNames{k} '=' num2str(updateValues{i, k})];
                    end
                    
                    if k ~= length(updateNames)
                        setQuery = [setQuery ' , '];
                    end
                end
                
                result = this.SqlQuery([updateQuery ' ' setQuery ' ' whereQuery]);
            end
        end
    end
end
