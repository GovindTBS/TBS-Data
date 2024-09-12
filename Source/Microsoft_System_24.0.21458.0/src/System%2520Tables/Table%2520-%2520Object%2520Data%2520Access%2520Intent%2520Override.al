// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment.Configuration;

table 2000000205 "Object Access Intent Override"
{
    Caption = 'Object Access Intent Override';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {

        field(1; "Object Type"; Option)
        {
            Caption = 'Object Type';
            OptionMembers = ,,,"Report",,,,,"Page","Query",,,,,,,,,,;
            OptionCaption = ',,,Report,,,,,Page,Query,,,,,,,,,,';
        }
        field(2; "Object ID"; Integer)
        {
            Caption = 'Object ID';
        }
        field(3; "Access Intent"; Option)
        {
            Caption = 'Access Intent';
            OptionCaption = 'Default,ReadOnly,ReadWrite';
            OptionMembers = Default,ReadOnly,ReadWrite;
        }
    }

    keys
    {
        key(Key1; "Object Type", "Object ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

