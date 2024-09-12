// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Tooling;

table 2000000216 "Designed Query Column"
{
    Caption = 'Designed Query Column';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        field(1; "Query ID"; BigInteger)
        {
            Caption = 'Query ID';
        }
        field(2; "Data Item"; Text[120])
        {
            Caption = 'Data Item';
        }
        field(3; "Order"; Integer)
        {
            Caption = 'Order';
        }
        field(4; "Name"; Text[120])
        {
            Caption = 'Name';
        }
        field(5; "Description"; Text[250])
        {
            Caption = 'Description';
        }
        field(6; "Source Reference"; Text[30])
        {
            Caption = 'Source Reference';
        }
        field(7; "Column Type"; Option)
        {
            Caption = 'Column Type';
            OptionCaption = 'Normal,Aggregating,Count';
            OptionMembers = Normal,Aggregating,Count;
        }
        field(8; "Method"; Option)
        {
            Caption = 'Method';
            OptionCaption = 'Average,Count,Max,Min,Sum,Year,Month,Day';
            OptionMembers = Average,Count,Max,Min,Sum,Year,Month,Day;
        }
        field(9; "Invert Sign"; Boolean)
        {
            Caption = 'Invert Sign';
        }
    }

    keys
    {
        key(PK; "Query Id", "Data Item", "Order")
        {
            Clustered = true;
        }
    }
}