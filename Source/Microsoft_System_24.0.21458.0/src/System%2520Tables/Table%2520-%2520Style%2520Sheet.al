// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment.Configuration;

table 2000000066 "Style Sheet"
{
    Caption = 'Style Sheet';
    DataPerCompany = false;
    Scope = OnPrem;

    fields
    {
        field(1; "Style Sheet ID"; Guid)
        {
            Caption = 'Style Sheet ID';
        }
        field(2; "Object Type"; Option)
        {
            Caption = 'Object Type';
            OptionMembers = ,"Report","Page";
            OptionCaption = ',Report,Page';
        }
        field(3; "Object ID"; Integer)
        {
            Caption = 'Object ID';
            TableRelation = System.Reflection.Object.ID WHERE(Type = FIELD("Object Type"));
        }
        field(4; "Program ID"; Guid)
        {
            Caption = 'Program ID';
        }
        field(5; Name; Text[250])
        {
            Caption = 'Name';
        }
        field(6; "Style Sheet"; BLOB)
        {
            Caption = 'Style Sheet';
        }
        field(7; Date; Date)
        {
            Caption = 'Date';
        }
    }

    keys
    {
        key(Key1; "Style Sheet ID")
        {
            Clustered = true;
        }
        key(Key2; "Object Type", "Object ID", "Program ID")
        {
        }
    }

    fieldgroups
    {
    }
}

