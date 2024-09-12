// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment.Configuration;

table 2000000210 "Tenant Feature Key"
{
    Caption = 'Tenant Feature Key';
    DataPerCompany = false;
    Scope = OnPrem;

    fields
    {
        field(1; ID; Text[50])
        {
            Caption = 'ID';
        }
        field(2; Enabled; Option)
        {
            Caption = 'Enabled';
            OptionCaption = 'None,All Users';
            OptionMembers = "None","All Users";
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

