// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Tooling;

table 2000000226 "Query Navigation"
{
    Caption = 'Query Navigation';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        field(1; "Id"; BigInteger)
        {
            Caption = 'Id';
            AutoIncrement = true;
        }

        field(2; Name; Text[250])
        {
            Caption = 'Name';
        }

        field(3; "Default"; Boolean)
        {
            Caption = 'Default';
        }

        field(4; "Source Query Object Id"; Integer)
        {
            Caption = 'Source Query Object Id';
        }

        field(5; "Target Page Id"; Integer)
        {
            Caption = 'Target Page Id';
        }

        field(6; "Linking Data Item Name"; Text[250])
        {
            Caption = 'Linking Data Item Name';
        }
    }

    keys
    {
        key(PK; "Id")
        {
            Clustered = true;
        }

        key(QueryLookupKey; "Source Query Object Id")
        {
        }
    }
}