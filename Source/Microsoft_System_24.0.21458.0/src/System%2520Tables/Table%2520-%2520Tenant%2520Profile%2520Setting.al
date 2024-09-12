// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment.Configuration;

table 2000000083 "Tenant Profile Setting"
{
    Caption = 'Tenant Profile Setting';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;
    InherentPermissions = rX;

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
        field(3; "Default Role Center"; Boolean)
        {
            Caption = 'Default Role Center';
        }
        field(4; "Disable Personalization"; Boolean)
        {
            Caption = 'Disable Personalization';
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

