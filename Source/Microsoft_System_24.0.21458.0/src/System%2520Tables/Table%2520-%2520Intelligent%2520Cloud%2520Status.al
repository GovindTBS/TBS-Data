// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Integration;

table 2000000173 "Intelligent Cloud Status"
{
    Caption = 'Intelligent Cloud Status';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        field(1; "Table Name"; Text[250])
        {
            Caption = 'Table Name';
        }
        field(2; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
        }
        field(3; "Table Id"; Integer)
        {
            Caption = 'Table Id';
        }
        field(4; "Synced Version"; BigInteger)
        {
            Caption = 'Synced Version';
        }
        field(5; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(6; "Replicate Data"; Boolean)
        {
            Caption = 'Replicate Data';
        }
        field(7; "Preserve Cloud Data"; Boolean)
        {
            Caption = 'Preserve Cloud Data';
        }
    }

    keys
    {
        key(Key1; "Table Name", "Company Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

