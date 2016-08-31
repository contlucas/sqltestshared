declare @colsNameUnpivotNVarchar nvarchar(max) = ''
declare @query nvarchar(max) = ''

select @colsNameUnpivotNVarchar += c.name + ', '
from	CamposxPantalla cp
		join sys.tables t on t.object_id = cp.object_id
		join sys.columns c on c.object_id = cp.object_id and  c.column_id = cp.column_id
where	cp.Pantalla = 1
		and c.system_type_id = 231

set @colsNameUnpivotNVarchar = substring(@colsNameUnpivotNVarchar, 0, len(@colsNameUnpivotNVarchar));

set @query += ' select x.Alumno, c.name, x.Value, c.is_nullable '
set @query += ' from sys.sysdepends d '
set @query += ' 	join sys.columns c on c.object_id = d.depid and c.column_id = d.depnumber '
set @query += ' 	join (SELECT Alumno, ColumnName, Value FROM '
set @query += ' 		(SELECT Alumno, ' + @colsNameUnpivotNVarchar + ' FROM v_Alumnos) p '
set @query += ' 			UNPIVOT (Value FOR ColumnName IN (' + @colsNameUnpivotNVarchar + ')) AS unpvt) x on x.ColumnName = c.name '
set @query += ' where d.id = OBJECT_ID(''dbo.v_Alumnos'') and x.Alumno = 3 '

exec(@query)