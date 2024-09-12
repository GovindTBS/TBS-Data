// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Security.AccessControl;

table 2000000250 "Metadata Permission Set"
{
    Caption = 'Metadata Permission Set';
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
        }
        field(3; Name; Text[30])
        {
            Caption = 'Name';
        }
        field(4; Assignable; Boolean)
        {
            Caption = 'Assignable';
            InitValue = true;
        }
    }

    keys
    {
        key(Key1; "App ID", "Role ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

