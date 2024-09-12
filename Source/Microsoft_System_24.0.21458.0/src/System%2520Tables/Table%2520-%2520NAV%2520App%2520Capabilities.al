// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Apps;

table 2000000162 "NAV App Capabilities"
{
    Caption = 'NAV App Capabilities';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        field(1; "Package ID"; Guid)
        {
            Caption = 'Package ID';
        }
        field(2; "Capability ID"; Integer)
        {
            Caption = 'Capability ID';
        }
    }

    keys
    {
        key(Key1; "Package ID", "Capability ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

