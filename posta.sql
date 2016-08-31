----select pantalla, object_id, column_id from CamposxPantalla 

--select * from alumnos 

----select	c.name, x.Value, c.is_nullable 
--select	
--from	CamposxPantalla cp
--		join sys.tables t on t.object_id = cp.object_id
--		join sys.columns c on c.object_id = cp.object_id and  c.column_id = cp.column_id
--where	cp.Pantalla = 1



declare @colsNameUnpivotNVarchar nvarchar(max) = ''
--declare @tableName nvarchar(max) = ''
declare @query nvarchar(max) = ''

--set @myTable = 'Alumnos';

select @colsNameUnpivotNVarchar += c.name + ', '
from	CamposxPantalla cp
		join sys.tables t on t.object_id = cp.object_id
		join sys.columns c on c.object_id = cp.object_id and  c.column_id = cp.column_id
where	cp.Pantalla = 1
		and c.system_type_id = 231

set @colsNameUnpivotNVarchar = substring(@colsNameUnpivotNVarchar, 0, len(@colsNameUnpivotNVarchar));



/*
construir un query dinámico por tipo de dato, de todas las columnas de ese tipo de una tabla determinada 
*/

-- select * from sys.types where name = 'nvarchar'
--select	c.*
--from	CamposxPantalla cp
--		join sys.tables t on t.object_id = cp.object_id
--		join sys.columns c on c.object_id = cp.object_id and  c.column_id = cp.column_id
--where	cp.Pantalla = 1
--		and c.system_type_id = 231


--select	*
--from	sys.tables t
--		join sys.columns c on c.object_id = t.object_id
--		cross apply ('select ' + c.name + ' from ' + t.name) x

--where c.object_id = OBJECT_ID('ALUMNOS')








set @query += ' select x.Alumno, c.name, x.Value, c.is_nullable '
set @query += ' from sys.sysdepends d '
set @query += ' 	join sys.columns c on c.object_id = d.depid and c.column_id = d.depnumber '
set @query += ' 	join (SELECT Alumno, ColumnName, Value FROM '
set @query += ' 		(SELECT Alumno, ' + @colsNameUnpivotNVarchar + ' FROM v_Alumnos) p '
set @query += ' 			UNPIVOT (Value FOR ColumnName IN (' + @colsNameUnpivotNVarchar + ')) AS unpvt) x on x.ColumnName = c.name '
set @query += ' where d.id = OBJECT_ID(''dbo.v_Alumnos'') and x.Alumno = 3 '

exec(@query)