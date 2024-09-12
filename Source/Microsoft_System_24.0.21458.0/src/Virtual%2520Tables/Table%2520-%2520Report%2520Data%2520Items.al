// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Reflection;

table 2000000203 "Report Data Items"
{
    Caption = 'Report Data Items';
    Scope = Cloud;

    fields
    {
        field(1; "Report ID"; Integer)
        {
            Caption = 'Report ID';
        }
        field(2; "Data Item ID"; Integer)
        {
            Caption = 'Data Item ID';
        }
        field(3; "Name"; Text[250])
        {
            Caption = 'Data Item Name';
        }
        field(4; "Request Filter Fields"; Text[250])
        {
            Caption = 'Request Filter Fields';
        }
        field(5; "Related Table ID"; Integer)
        {
            Caption = 'Related Table ID';
        }
        field(6; "Indentation Level"; Integer)
        {
            Caption = 'Indentation Level';
        }
        field(7; "Sorting Fields"; Text[250])
        {
            Caption = 'Sorting Fields';
        }
        field(8; "Data Item Table View"; Text[1024])
        {
            Caption = 'Data Item Table View';
        }
    }
    keys
    {
        key(PK; "Report ID", "Data Item ID")
        {
        }
    }
}