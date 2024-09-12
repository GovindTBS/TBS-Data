// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Integration;

table 2000000243 "Ext. Business Event Definition"
{
    Caption = 'External Business Event Catalog';
    DataPerCompany = false;
    Scope = OnPrem;

    fields
    {
        field(1; "App Id"; Guid)
        {
            Caption = 'App Id';
        }
        field(2; "Name"; Text[80])
        {
            Caption = 'Name';
        }
        field(3; "Display Name"; Text[250])
        {
            Caption = 'Display Name';
        }
        field(4; "Description"; Text[1024])
        {
            Caption = 'Description';
        }
        field(5; "Category"; Text[250])
        {
            Caption = 'Category';
        }
        field(6; "Payload Blob"; Blob)
        {
            Caption = 'Payload Blob';
        }
        field(7; "App Name"; Text[250])
        {
            Caption = 'App Name';
        }
        field(8; "App Publisher"; Text[250])
        {
            Caption = 'App Publisher';
        }
        field(9; "App Version"; Text[43])
        {
            Caption = 'App Version';
        }
        field(10; "Event Version"; Text[43])
        {
            Caption = 'Event Version';
        }
    }

    keys
    {
        key(Key1; "App Id", "Name", "Event Version")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

