// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment;

table 2000000180 "Media Set"
{
    Caption = 'Media Set';
    DataPerCompany = false;
    Scope = OnPrem;

    fields
    {
        field(1; ID; Guid)
        {
            Caption = 'ID';
        }
        field(2; "Media ID"; Media)
        {
            Caption = 'Media ID';
        }
        field(3; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            TableRelation = System.Environment.Company.Name;
        }
        field(4; "Media Index"; BigInteger)
        {
            Caption = 'Media Index';
        }
    }

    keys
    {
        key(Key1; ID, "Media ID")
        {
            Clustered = true;
        }
        key(Key2; "Media Index")
        {
        }
        key(Key3; "Company Name")
        {
        }
    }

    fieldgroups
    {
    }
}

