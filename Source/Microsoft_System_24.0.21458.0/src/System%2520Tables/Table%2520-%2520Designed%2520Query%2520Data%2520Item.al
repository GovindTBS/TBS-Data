// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Tooling;

table 2000000218 "Designed Query Data Item"
{
    Caption = 'Designed Query Data Item';
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
        field(3; "Name"; Text[120])
        {
            Caption = 'Name';
        }
        field(4; "Description"; Text[250])
        {
            Caption = 'Description';
        }
        field(5; "Source Reference"; Text[30])
        {
            Caption = 'Source Reference';
        }

        field(6; "Join Type"; Option)
        {
            Caption = 'Join Type';
            OptionCaption = 'Inner,LeftOuter,RightOuter,FullOuter';
            OptionMembers = Inner,LeftOuter,RightOuter,FullOuter;
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