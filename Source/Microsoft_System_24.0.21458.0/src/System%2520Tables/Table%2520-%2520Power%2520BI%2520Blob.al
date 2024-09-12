// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Integration;

table 2000000144 "Power BI Blob"
{
    Caption = 'Power BI Blob';
    DataPerCompany = false;
    Scope = OnPrem;

    fields
    {
        field(1; Id; Guid)
        {
            Caption = 'Id';
        }
        field(2; "Blob File"; BLOB)
        {
            Caption = 'Blob File';
        }
        field(3; Name; Text[200])
        {
            Caption = 'Name';
        }
        field(4; Version; Integer)
        {
            Caption = 'Version';
        }
        field(5; "GP Enabled"; Boolean)
        {
            Caption = 'GP Enabled';
        }
    }

    keys
    {
        key(Key1; Id)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

