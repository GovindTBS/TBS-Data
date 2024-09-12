// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Tooling;

table 2000000213 "Designed Query"
{
    Caption = 'Designed Query';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        field(1; "Query ID"; BigInteger)
        {
            Caption = 'Query ID';
            AutoIncrement = true;
        }
        field(2; Name; Text[30])
        {
            Caption = 'Name';
        }
        field(3; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(4; "Max Rows Included"; Integer)
        {
            Caption = 'Max Rows Included';
        }
    }

    keys
    {
        key(PK; "Query ID")
        {
            Clustered = true;
        }

        key("Name"; "Name")
        {
            Unique = true;
        }
    }
}