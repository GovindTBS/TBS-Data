// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Apps;

/// <summary>
/// This table contains installed applications for tenants.
/// </summary>
table 2000000151 "NAV App Tenant App"
{
    Caption = 'NAV App Tenant App';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;
    ObsoleteState = Removed;
    ObsoleteReason = 'This table is deprecated in favour of the "Installed Application" table.';

    fields
    {
        field(1; "Tenant ID"; Text[128])
        {
            Caption = 'Tenant ID';
        }
        field(2; "App Package ID"; Guid)
        {
            Caption = 'App Package ID';
        }
    }

    keys
    {
        key(Key1; "Tenant ID", "App Package ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

