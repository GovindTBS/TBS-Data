// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Security.AccessControl;

table 2000000252 "Metadata Permission Set Rel."
{
    Caption = 'Metadata Permission Set Rel.';
    DataPerCompany = false;
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
        }
        field(3; "Related App ID"; Guid)
        {
            Caption = 'Related App ID';
        }
        field(4; "Related Role ID"; Code[30])
        {
            Caption = 'Related Role ID';
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = Include,Exclude;
            OptionCaption = 'Include,Exclude';
            InitValue = Include;
        }
    }

    keys
    {
        key(Key1; "App ID", "Role ID", "Related App ID", "Related Role ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

