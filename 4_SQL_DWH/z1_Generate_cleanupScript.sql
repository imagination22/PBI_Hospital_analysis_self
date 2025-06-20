--list all fk in silver layer
SELECT 
    fk.name AS ForeignKeyName,
    sch.name AS SchemaName,
    parent_tab.name AS ReferencingTable,
    parent_col.name AS ReferencingColumn,
    referenced_tab.name AS ReferencedTable,
    referenced_col.name AS ReferencedColumn
FROM sys.foreign_keys fk
INNER JOIN sys.tables parent_tab ON fk.parent_object_id = parent_tab.object_id
INNER JOIN sys.schemas sch ON parent_tab.schema_id = sch.schema_id
INNER JOIN sys.foreign_key_columns fk_col ON fk.object_id = fk_col.constraint_object_id
INNER JOIN sys.columns parent_col ON fk_col.parent_object_id = parent_col.object_id 
    AND fk_col.parent_column_id = parent_col.column_id
INNER JOIN sys.tables referenced_tab ON fk.referenced_object_id = referenced_tab.object_id
INNER JOIN sys.columns referenced_col ON fk_col.referenced_object_id = referenced_col.object_id 
    AND fk_col.referenced_column_id = referenced_col.column_id
WHERE sch.name = 'Silver' and parent_tab.name = 'medicine_patient'
ORDER BY SchemaName, ReferencingTable, ForeignKeyName;

--list all table  in silver layer

SELECT name AS TableName
FROM sys.tables
WHERE schema_name(schema_id) = 'gOLD'
ORDER BY name;



--  List all foreign key constraints in the Silver schema
SELECT 
    fk.name AS ForeignKeyName,
    sch.name AS SchemaName,
    parent_tab.name AS ReferencingTable,
    parent_col.name AS ReferencingColumn,
    referenced_tab.name AS ReferencedTable,
    referenced_col.name AS ReferencedColumn
FROM sys.foreign_keys fk
INNER JOIN sys.tables parent_tab ON fk.parent_object_id = parent_tab.object_id
INNER JOIN sys.schemas sch ON parent_tab.schema_id = sch.schema_id
INNER JOIN sys.foreign_key_columns fk_col ON fk.object_id = fk_col.constraint_object_id
INNER JOIN sys.columns parent_col ON fk_col.parent_object_id = parent_col.object_id 
    AND fk_col.parent_column_id = parent_col.column_id
INNER JOIN sys.tables referenced_tab ON fk.referenced_object_id = referenced_tab.object_id
INNER JOIN sys.columns referenced_col ON fk_col.referenced_object_id = referenced_col.object_id 
    AND fk_col.referenced_column_id = referenced_col.column_id
WHERE sch.name = 'Silver'
ORDER BY SchemaName, ReferencingTable, ForeignKeyName;

--  List all tables in the Silver schema
SELECT name AS TableName
FROM sys.tables
WHERE schema_name(schema_id) = 'Silver'
ORDER BY name;

--  Generate DROP CONSTRAINT statements for all foreign keys
SELECT 
    'ALTER TABLE ' + sch.name + '.' + parent_tab.name + ' DROP CONSTRAINT ' + fk.name
FROM sys.foreign_keys fk
INNER JOIN sys.tables parent_tab ON fk.parent_object_id = parent_tab.object_id
INNER JOIN sys.schemas sch ON parent_tab.schema_id = sch.schema_id
WHERE sch.name = 'Silver';

-- Generate TRUNCATE TABLE statements for all tables
SELECT 
    'TRUNCATE TABLE ' + sch.name + '.' + tab.name
FROM sys.tables tab
INNER JOIN sys.schemas sch ON tab.schema_id = sch.schema_id
WHERE sch.name = 'Silver';

-- Generate ADD CONSTRAINT statements for all foreign keys
SELECT 
    'ALTER TABLE ' + sch.name + '.' + parent_tab.name + 
    ' ADD CONSTRAINT ' + fk.name + 
    ' FOREIGN KEY (' + parent_col.name + ') REFERENCES ' + 
    sch.name + '.' + referenced_tab.name + '(' + referenced_col.name + ')'
FROM sys.foreign_keys fk
INNER JOIN sys.tables parent_tab ON fk.parent_object_id = parent_tab.object_id
INNER JOIN sys.schemas sch ON parent_tab.schema_id = sch.schema_id
INNER JOIN sys.foreign_key_columns fk_col ON fk.object_id = fk_col.constraint_object_id
INNER JOIN sys.columns parent_col ON fk_col.parent_object_id = parent_col.object_id 
    AND fk_col.parent_column_id = parent_col.column_id
INNER JOIN sys.tables referenced_tab ON fk.referenced_object_id = referenced_tab.object_id
INNER JOIN sys.columns referenced_col ON fk_col.referenced_object_id = referenced_col.object_id 
    AND fk_col.referenced_column_id = referenced_col.column_id
WHERE sch.name = 'Silver';


