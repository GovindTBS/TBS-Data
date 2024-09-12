// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Tooling;

table 2000000221 "Designed Query Order By"
{
    Caption = 'Designed Query Order By';
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
        field(3; "Column"; Text[120])
        {
            Caption = 'Column';
        }
        field(4; "Direction"; Option)
        {
            Caption = 'Direction';
            OptionCaption = 'Ascending,Descending';
            OptionMembers = "Ascending","Descending";
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