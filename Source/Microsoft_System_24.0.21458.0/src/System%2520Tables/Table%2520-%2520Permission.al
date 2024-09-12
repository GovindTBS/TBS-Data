// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Security.AccessControl;

using System.Reflection;

table 2000000005 Permission
{
    Caption = 'Permission';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = Cloud;
    ObsoleteState = Pending;
    ObsoleteReason = 'Internal table which will be moved to the OnPrem scope in an upcoming major release. The ''Expanded Permission'' table should be used in its place.';

    fields
    {
        field(1; "Role ID"; Code[20])
        {
            Caption = 'Role ID';
            TableRelation = "Permission Set"."Role ID";
        }
        field(2; "Role Name"; Text[30])
        {
            CalcFormula = Lookup("Permission Set".Name WHERE("Role ID" = FIELD("Role ID")));
            Caption = 'Role Name';
            FieldClass = FlowField;
        }
        field(3; "Object Type"; Option)
        {
            Caption = 'Object Type';
            OptionMembers = "Table Data","Table",,"Report",,"Codeunit","XMLport","MenuSuite","Page","Query","System",,,,,,,,,;
            OptionCaption = 'Table Data,Table,,Report,,Codeunit,XMLport,MenuSuite,Page,Query,System,,,,,,,,,';
        }
        field(4; "Object ID"; Integer)
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
        field(5; "Object Name"; Text[249])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = FIELD("Object Type"),
                                                                           "Object ID" = FIELD("Object ID")));
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
        field(11; "Security Filter"; TableFilter)
        {
            Caption = 'Security Filter';
        }
        field(12; "AL Object Name"; Text[30])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = FIELD("Object Type"),
                                                                           "Object ID" = FIELD("Object ID")));
            Caption = 'AL Object Name';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Role ID", "Object Type", "Object ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Role ID", "Role Name")
        {
        }
    }
}

