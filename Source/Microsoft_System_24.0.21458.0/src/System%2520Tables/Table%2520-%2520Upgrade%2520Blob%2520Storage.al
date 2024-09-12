// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Upgrade;

table 2000000081 "Upgrade Blob Storage"
{
    Caption = 'Upgrade Blob Storage';
    DataPerCompany = false;
    Scope = OnPrem;

    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
        }
        field(2; Blob; BLOB)
        {
            Caption = 'Blob';
        }
        field(3; "File Extension"; Text[10])
        {
            Caption = 'File Extension';
        }
        field(4; Description; Text[250])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

