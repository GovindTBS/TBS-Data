// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Tooling;

table 2000000219 "Designed Query Filter"
{
    Caption = 'Designed Query Filter';
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
        field(3; "Source Reference"; Text[120])
        {
            Caption = 'Source Reference';
        }
        field(4; "Order"; Integer)
        {
            Caption = 'Order';
        }
        field(5; "Filter Type"; Option)
        {
            Caption = 'Filter Type';
            OptionCaption = 'Equal,NotEqual,GreaterThan,GreaterThanEqual,LessThan,LessThanEqual,Contains';
            OptionMembers = Equal,NotEqual,GreaterThan,GreaterThanEqual,LessThan,LessThanEqual,Contains;
        }
        field(6; "Value"; Text[2048])
        {
            Caption = 'Value';
        }
        field(7; "Ignore Case"; Boolean)
        {
            Caption = 'Ignore Case';
        }
        field(8; "Filter Expression Type"; Option)
        {
            Caption = 'Filter Expression Type';
            OptionCaption = 'Filter,Logical';
            OptionMembers = Filter,Logical;
        }
        field(9; "Operand Count"; Integer)
        {
            Caption = 'Operand Count';
        }
    }

    keys
    {
        key(PK; "Query Id", "Data Item", "Source Reference", "Order")
        {
            Clustered = true;
        }
    }
}