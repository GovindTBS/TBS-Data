// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Integration;

table 2000000145 "Power BI Default Selection"
{
    Caption = 'Power BI Default Selection';
    DataPerCompany = false;
    Scope = OnPrem;

    fields
    {
        field(1; Id; Guid)
        {
            Caption = 'Id';
        }
        field(2; Context; Text[30])
        {
            Caption = 'Context';
        }
        field(3; Selected; Boolean)
        {
            Caption = 'Selected';
        }
    }

    keys
    {
        key(Key1; Id, Context)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

