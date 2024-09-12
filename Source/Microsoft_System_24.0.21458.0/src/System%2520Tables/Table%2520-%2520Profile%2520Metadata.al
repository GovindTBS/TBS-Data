// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Reflection;

table 2000000074 "Profile Metadata"
{
    Caption = 'Profile Metadata';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;
    ObsoleteState = Removed;
    ObsoleteReason = 'Support for System Profiles has been removed. Profiles should now be defined in AL extensions and should be accessed through the All Profile virtual table.';
    ObsoleteTag = '22.0';

    fields
    {
        field(3; "Profile ID"; Code[30])
        {
            Caption = 'Profile ID';
            TableRelation = Profile."Profile ID";
        }
        field(6; "Page ID"; Integer)
        {
            Caption = 'Page ID';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(9; Description; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Page),
                                                                           "Object ID" = FIELD("Page ID")));
            Caption = 'Description';
            FieldClass = FlowField;
        }
        field(12; Date; Date)
        {
            Caption = 'Date';
        }
        field(15; Time; Time)
        {
            Caption = 'Time';
        }
        field(18; "Personalization ID"; Code[40])
        {
            Caption = 'Personalization ID';
        }
        field(21; "Page Metadata Delta"; BLOB)
        {
            Caption = 'Page Metadata Delta';
        }
    }

    keys
    {
        key(Key1; "Profile ID", "Page ID", "Personalization ID")
        {
            Clustered = true;
        }
        key(Key2; Date)
        {
        }
    }

    fieldgroups
    {
    }
}

