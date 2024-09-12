// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment.Configuration;

table 2000000198 "Page Documentation"
{
    Caption = 'Page Documentation';
    DataPerCompany = false;
    Scope = OnPrem;

    fields
    {
        field(1; "Page ID"; Integer)
        {
            Caption = 'Page ID';
        }
        field(2; "Relative Path"; Text[250])
        {
            Caption = 'Relative Path';
        }
    }

    keys
    {
        key(Key1; "Page ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

