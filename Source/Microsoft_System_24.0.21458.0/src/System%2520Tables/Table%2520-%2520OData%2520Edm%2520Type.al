// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Integration;

table 2000000179 "OData Edm Type"
{
    Caption = 'OData Edm Type';
    DataPerCompany = false;
    Scope = Cloud;

    fields
    {
        field(1; "Key"; Code[50])
        {
            Caption = 'Key';
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(10; "Edm Xml"; BLOB)
        {
            Caption = 'Edm Xml';
            SubType = UserDefined;
        }
    }

    keys
    {
        key(Key1; "Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

