// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Tooling;

table 2000000215 "Designed Query Category"
{
    Caption = 'Designed Query Category';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        field(1; "Query ID"; BigInteger)
        {
            Caption = 'Query ID';
        }
        field(2; "Order"; Integer)
        {
            Caption = 'Order';
        }
        field(3; "Category"; Text[30])
        {
            Caption = 'Category';
        }
    }

    keys
    {
        key(PK; "Query Id", "Order")
        {
            Clustered = true;
        }
    }
}