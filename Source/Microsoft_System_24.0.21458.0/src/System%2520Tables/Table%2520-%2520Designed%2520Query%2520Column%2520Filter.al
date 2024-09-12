// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Tooling;

table 2000000217 "Designed Query Column Filter"
{
    Caption = 'Designed Query Column Filter';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        field(1; "Query ID"; BigInteger)
        {
            Caption = 'Query ID';
        }
        field(2; "Column"; Text[120])
        {
            Caption = 'Column';
        }
        field(3; "Order"; Integer)
        {
            Caption = 'Order';
        }
        field(4; "Filter Type"; Option)
        {
            Caption = 'Filter Type';
            OptionCaption = 'Equal,NotEqual,GreaterThan,GreaterThanEqual,LessThan,LessThanEqual,Contains';
            OptionMembers = Equal,NotEqual,GreaterThan,GreaterThanEqual,LessThan,LessThanEqual,Contains;
        }
        field(5; "Value"; Text[2048])
        {
            Caption = 'Value';
        }
        field(6; "Ignore Case"; Boolean)
        {
            Caption = 'Ignore Case';
        }
        field(7; "Filter Expression Type"; Option)
        {
            Caption = 'Filter Expression Type';
            OptionCaption = 'Filter,Logical';
            OptionMembers = Filter,Logical;
        }
        field(8; "Operand Count"; Integer)
        {
            Caption = 'Operand Count';
        }
    }

    keys
    {
        key(PK; "Query Id", "Column", "Order")
        {
            Clustered = true;
        }
    }
}