/// <summary>
/// This table contains object metadata from published applications.
/// </summary>
namespace System.Apps;

table 2000000150 "NAV App Object Metadata"
{
    Caption = 'NAV App Object Metadata';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;
    ObsoleteState = Removed;
    ObsoleteReason = 'This table is deprecated in favour of the "Application Object Metadata" table.';

    fields
    {
        field(1; "App Package ID"; Guid)
        {
            Caption = 'App Package ID';
        }
        field(2; "Object Type"; Option)
        {
            Caption = 'Object Type';
            OptionMembers = ,"Table",,"Report",,"Codeunit","XMLport","MenuSuite","Page","Query",,,,,"PageExtension","TableExtension","Enum","EnumExtension","Profile","ProfileExtension","PermissionSet","PermissionSetExtension","ReportExtension";
            OptionCaption = ',Table,,Report,,Codeunit,XMLport,MenuSuite,Page,Query,,,,,PageExtension,TableExtension,Enum,EnumExtension,Profile,ProfileExtension,PermissionSet,PermissionSetExtension,ReportExtension';
        }
        field(3; "Object ID"; Integer)
        {
            Caption = 'Object ID';
        }
        field(4; "Metadata Format"; Option)
        {
            Caption = 'Metadata Format';
            OptionCaption = 'Full,Delta';
            OptionMembers = Full,Delta;
        }
        field(5; Metadata; BLOB)
        {
            Caption = 'Metadata';
        }
        field(6; "User Code"; BLOB)
        {
            Caption = 'User Code';
        }
        field(7; "User AL Code"; BLOB)
        {
            Caption = 'User AL Code';
        }
        field(8; "Metadata Version"; Integer)
        {
            Caption = 'Metadata Version';
        }
        field(9; "Object Subtype"; Text[30])
        {
            Caption = 'Object Subtype';
        }
        field(10; "Object Name"; Text[30])
        {
            Caption = 'Object Name';
        }
        field(11; "Metadata Hash"; Text[64])
        {
            Caption = 'Metadata Hash';
        }
        field(12; "User Code Hash"; Text[64])
        {
            Caption = 'User Code Hash';
        }
        field(13; "Object Flags"; Integer)
        {
            Caption = 'Object Flags';
        }
    }

    keys
    {
        key(Key1; "App Package ID", "Object Type", "Object ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

