// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Tooling;

using System.Security.AccessControl;

table 2000000222 "Designed Query Permission"
{
    Caption = 'Designed Query Permission';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = Cloud;

    fields
    {
        field(1; "App ID"; Guid)
        {
            Caption = 'App ID';
        }
        field(2; "Role ID"; Code[20])
        {
            Caption = 'Role ID';
            TableRelation = "Tenant Permission Set"."Role ID" WHERE("App ID" = FIELD("App ID"));
        }
        field(3; "Role Name"; Text[30])
        {
            CalcFormula = Lookup("Tenant Permission Set".Name WHERE("App ID" = FIELD("App ID"),
                                                                     "Role ID" = FIELD("Role ID")));
            Caption = 'Role Name';
            FieldClass = FlowField;
        }
        field(4; "Object ID"; Integer)
        {
            Caption = 'Object ID';
            TableRelation = "Designed Query Obj"."Object ID";
        }
        field(5; "Object Name"; Text[30])
        {
            CalcFormula = Lookup("Designed Query Obj"."Object Name" WHERE("Object ID" = FIELD("Object ID")));
            Caption = 'Object Name';
            FieldClass = FlowField;
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
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ",Yes,Indirect;
        }
        field(8; "Modify Permission"; Option)
        {
            Caption = 'Modify Permission';
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ",Yes,Indirect;
        }
        field(9; "Delete Permission"; Option)
        {
            Caption = 'Delete Permission';
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
        key(PK; "App ID", "Role ID", "Object ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

