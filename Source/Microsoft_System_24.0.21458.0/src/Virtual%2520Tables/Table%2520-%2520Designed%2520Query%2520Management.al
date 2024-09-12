// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Tooling;

table 2000000225 "Designed Query Management"
{
    DataPerCompany = false;
    Scope = OnPrem;

    fields
    {
        field(1; "Object ID"; Integer)
        {
            Caption = 'Object ID';
            Editable = false;
        }
        field(2; "Object Name"; Text[30])
        {
            Caption = 'Object Name';
            Editable = false;
        }
        field(3; "Unique ID"; Guid)
        {
            Caption = 'Unique ID';
            Editable = false;
        }
        field(4; "Query ID"; BigInteger)
        {
            Caption = 'Query ID';
            Editable = false;
        }
        field(5; "Description"; Text[250])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(6; "Group"; Text[100])
        {
            Caption = 'Group';
            Editable = true;
        }
        field(7; "Categories"; Text[250])
        {
            Caption = 'Category';
            Editable = false;
        }
        field(8; "Primary Source Table"; Text[30])
        {
            Caption = 'Category';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Object ID")
        {
        }
    }
}