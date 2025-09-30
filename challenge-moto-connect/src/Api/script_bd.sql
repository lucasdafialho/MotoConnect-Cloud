DECLARE
V_COUNT INTEGER;
BEGIN
SELECT COUNT(TABLE_NAME) INTO V_COUNT from USER_TABLES where TABLE_NAME = '__EFMigrationsHistory';
IF V_COUNT = 0 THEN
Begin
BEGIN 
EXECUTE IMMEDIATE 'CREATE TABLE 
"__EFMigrationsHistory" (
    "MigrationId" NVARCHAR2(150) NOT NULL,
    "ProductVersion" NVARCHAR2(32) NOT NULL,
    CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId")
)';
END;

End;

END IF;
EXCEPTION
WHEN OTHERS THEN
    IF(SQLCODE != -942)THEN
        RAISE;
    END IF;
END;
/

BEGIN 
EXECUTE IMMEDIATE 'CREATE TABLE 
"MaintenanceHistories" (
    "MaintenanceHistoryID" RAW(16) NOT NULL,
    "VehicleID" RAW(16) NOT NULL,
    "UserID" RAW(16) NOT NULL,
    "StatusModel" NUMBER(10) NOT NULL,
    "MaintenanceDate" TIMESTAMP(7) NOT NULL,
    "Description" NVARCHAR2(500) NOT NULL,
    CONSTRAINT "PK_MaintenanceHistories" PRIMARY KEY ("MaintenanceHistoryID")
)';
END;
/

BEGIN 
EXECUTE IMMEDIATE 'CREATE TABLE 
"Users" (
    "UserID" RAW(16) NOT NULL,
    "UserCancelID" RAW(16) NOT NULL,
    "IsCancel" NUMBER(1) NOT NULL,
    "Email" NVARCHAR2(100) NOT NULL,
    "Password" NVARCHAR2(100) NOT NULL,
    "Type" NUMBER(10) NOT NULL,
    CONSTRAINT "PK_Users" PRIMARY KEY ("UserID")
)';
END;
/

BEGIN 
EXECUTE IMMEDIATE 'CREATE TABLE 
"Vehicles" (
    "VehicleId" RAW(16) NOT NULL,
    "LicensePlate" NVARCHAR2(8) NOT NULL,
    "VehicleModel" NUMBER(10) NOT NULL,
    CONSTRAINT "PK_Vehicles" PRIMARY KEY ("VehicleId")
)';
END;
/

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES (N'20250907202843_InitialSchema', N'8.0.3')
/

BEGIN 
EXECUTE IMMEDIATE 'CREATE TABLE 
"MaintenanceHistories" (
    "MaintenanceHistoryID" RAW(16) NOT NULL,
    "VehicleID" RAW(16) NOT NULL,
    "UserID" RAW(16) NOT NULL,
    "StatusModel" NUMBER(10) NOT NULL,
    "MaintenanceDate" TIMESTAMP(7) NOT NULL,
    "Description" NVARCHAR2(500) NOT NULL,
    CONSTRAINT "PK_MaintenanceHistories" PRIMARY KEY ("MaintenanceHistoryID")
)';
END;
/

BEGIN 
EXECUTE IMMEDIATE 'CREATE TABLE 
"Users" (
    "UserID" RAW(16) NOT NULL,
    "Email" NVARCHAR2(100) NOT NULL,
    "Password" NVARCHAR2(100) NOT NULL,
    "Type" NUMBER(10) NOT NULL,
    CONSTRAINT "PK_Users" PRIMARY KEY ("UserID")
)';
END;
/

BEGIN 
EXECUTE IMMEDIATE 'CREATE TABLE 
"Vehicles" (
    "VehicleId" RAW(16) NOT NULL,
    "LicensePlate" NVARCHAR2(8) NOT NULL,
    "VehicleModel" NUMBER(10) NOT NULL,
    CONSTRAINT "PK_Vehicles" PRIMARY KEY ("VehicleId")
)';
END;
/

INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES (N'20250927185142_InitialCreate', N'8.0.3')
/

