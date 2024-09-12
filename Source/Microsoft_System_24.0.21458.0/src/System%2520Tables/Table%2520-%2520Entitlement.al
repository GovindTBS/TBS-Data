// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Security.AccessControl;

table 2000000191 Entitlement
{
    Caption = 'Entitlement';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        field(1; "Entitlement Set ID"; Code[20])
        {
            Caption = 'Entitlement Set ID';
            TableRelation = "Entitlement Set".ID WHERE(ID = FIELD("Entitlement Set ID"));
        }
        field(2; "Entitlement Set Name"; Text[250])
        {
            CalcFormula = Lookup("Entitlement Set".Name WHERE(ID = FIELD("Entitlement Set ID")));
            Caption = 'Entitlement Set Name';
            FieldClass = FlowField;
        }
        field(3; "Object Type"; Option)
        {
            Caption = 'Object Type';
            OptionMembers = "Table Data","Table",,"Report",,"Codeunit","XMLport","MenuSuite","Page","Query","System",,,,"PageExtension","TableExtension","Enum","EnumExtension","Profile","ProfileExtension","PermissionSet","PermissionSetExtension","ReportExtension";
            OptionCaption = 'Table Data,Table,,Report,,Codeunit,XMLport,MenuSuite,Page,Query,System,,,,PageExtension,TableExtension,Enum,EnumExtension,Profile,ProfileExtension,PermissionSet,PermissionSetExtension,ReportExtension';
        }
        field(4; "Object ID Range Start"; Integer)
        {
            Caption = 'Object ID Range Start';
        }
        field(5; "Object ID Range End"; Integer)
        {
            Caption = 'Object ID Range End';
        }
        field(6; "Read Permission"; Option)
        {
            Caption = 'Read Permission';
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ",Yes,Indirect;
        }
        field(7; "Insert Permission"; Option)
        {
            Caption = 'Insert Permission';
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ",Yes,Indirect;
        }
        field(8; "Modify Permission"; Option)
        {
            Caption = 'Modify Permission';
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ",Yes,Indirect;
        }
        field(9; "Delete Permission"; Option)
        {
            Caption = 'Delete Permission';
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ",Yes,Indirect;
        }
        field(10; "Execute Permission"; Option)
        {
            Caption = 'Execute Permission';
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ",Yes,Indirect;
        }
    }

    keys
    {
        key(Key1; "Entitlement Set ID", "Object Type", "Object ID Range Start", "Object ID Range End")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

