// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Integration;

table 2000000146 "Intelligent Cloud"
{
    Caption = 'Intelligent Cloud';
    DataPerCompany = false;
    Scope = OnPrem;
    ReplicateData = false;
    InherentPermissions = rX;

    fields
    {
        field(1; "Primary Key"; Text[10])
        {
            Caption = 'Primary Key';
        }
        field(2; Enabled; Boolean)
        {
            Caption = 'Enabled';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

