// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment.Configuration;

table 2000000086 "Profile Configuration Symbols"
{
    Caption = 'Tenant Profile Configuration Symbols';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        field(1; "App ID"; Guid)
        {
            Caption = 'App ID';
        }
        field(2; "Profile ID"; Code[30])
        {
            Caption = 'Profile ID';
        }
        field(3; "Reference Symbols"; BLOB)
        {
            Caption = 'Reference Symbols';
        }
    }

    keys
    {
        key(Key1; "App ID", "Profile ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

