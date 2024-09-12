// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Security.AccessControl;

using System.Reflection;

table 2000000251 "Metadata Permission"
{
    Caption = 'Metadata Permission';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = Cloud;
    //WriteProtected=True;

    fields
    {
        field(1; "App ID"; Guid)
        {
            Caption = 'App ID';
        }
        field(2; "Role ID"; Code[30])
        {
            Caption = 'Role ID';
            TableRelation = "Metadata Permission Set"."Role ID" WHERE("App ID" = FIELD("App ID"));
        }
        field(3; "Role Name"; Text[30])
        {
            CalcFormula = Lookup("Metadata Permission Set".Name WHERE("App ID" = FIELD("App ID"),
                                                                      "Role ID" = FIELD("Role ID")));
            Caption = 'Role Name';
            FieldClass = FlowField;
        }
        field(4; "Object Type"; Option)
        {
            Caption = 'Object Type';
            OptionMembers = "Table Data","Table",,"Report",,"Codeunit","XMLport","MenuSuite","Page","Query","System",,,,,,,,,;
            OptionCaption = 'Table Data,Table,,Report,,Codeunit,XMLport,MenuSuite,Page,Query,System,,,,,,,,,';
        }
        field(5; "Object ID"; Integer)
        {
            Caption = 'Object ID';
            TableRelation = IF ("Object Type" = CONST("Table Data")) AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Table))
            ELSE
            IF ("Object Type" = CONST(Table)) AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Table))
            ELSE
            IF ("Object Type" = CONST(Report)) AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Report))
            ELSE
            IF ("Object Type" = CONST(Codeunit)) AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Codeunit))
            ELSE
            IF ("Object Type" = CONST(XMLport)) AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(XMLport))
            ELSE
            IF ("Object Type" = CONST(MenuSuite)) AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(MenuSuite))
            ELSE
            IF ("Object Type" = CONST(Page)) AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Page))
            ELSE
            IF ("Object Type" = CONST(Query)) AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Query))
            ELSE
            IF ("Object Type" = CONST(System)) AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(System));
        }
        field(6; "Object Name"; Text[249])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = FIELD("Object Type"),
                                                                           "Object ID" = FIELD("Object ID")));
            Caption = 'Object Name';
            FieldClass = FlowField;
        }
        field(7; "Read Permission"; Option)
        {
            Caption = 'Read Permission';
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ",Yes,Indirect;
        }
        field(8; "Insert Permission"; Option)
        {
            Caption = 'Insert Permission';
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ",Yes,Indirect;
        }
        field(9; "Modify Permission"; Option)
        {
            Caption = 'Modify Permission';
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ",Yes,Indirect;
        }
        field(10; "Delete Permission"; Option)
        {
            Caption = 'Delete Permission';
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ",Yes,Indirect;
        }
        field(11; "Execute Permission"; Option)
        {
            Caption = 'Execute Permission';
            InitValue = Yes;
            OptionCaption = ' ,Yes,Indirect';
            OptionMembers = " ",Yes,Indirect;
        }
        field(12; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = Include,Exclude;
            OptionCaption = 'Include,Exclude';
            InitValue = Include;
        }
        field(13; Assignable; Boolean)
        {
            CalcFormula = Lookup("Metadata Permission Set".Assignable WHERE("App ID" = FIELD("App ID"),
                                                                            "Role ID" = FIELD("Role ID")));
            Caption = 'Assignable';
            FieldClass = FlowField;
        }
        field(14; "Security Filter"; TableFilter)
        {
            Caption = 'Security Filter';
        }
        field(15; "AL Object Name"; Text[30])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = FIELD("Object Type"),
                                                                           "Object ID" = FIELD("Object ID")));
            Caption = 'AL Object Name';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "App ID", "Role ID", "Object Type", "Object ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "App ID", "Role ID", "Role Name")
        {
        }
    }
}

