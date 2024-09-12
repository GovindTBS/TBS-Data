// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Integration;

table 2000000065 "Send-To Program"
{
    Caption = 'Send-To Program';
    DataPerCompany = false;
    Scope = OnPrem;

    fields
    {
        field(1; "Program ID"; Guid)
        {
            Caption = 'Program ID';
        }
        field(2; Executable; Text[250])
        {
            Caption = 'Executable';
        }
        field(3; Parameter; Text[250])
        {
            Caption = 'Parameter';
        }
        field(4; Name; Text[250])
        {
            Caption = 'Name';
        }
    }

    keys
    {
        key(Key1; "Program ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

