// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Tooling;

table 2000000204 "Page Info And Fields"
{
    Caption = 'Page Info And Fields';
    DataPerCompany = true;
    Scope = OnPrem;

    fields
    {
        field(1; "Current Form ID"; Text[36])
        {
            Caption = 'Current Form ID';
        }
        field(2; "Current Form Bookmark"; Text[2048])
        {
            Caption = 'Current Form Bookmark';
        }
        field(3; "Field No."; Integer)
        {
            Caption = 'Field No.';
        }
        field(4; "Page ID"; Integer)
        {
            Caption = 'Page ID';
        }
        field(5; "Page Name"; Text[256])
        {
            Caption = 'Page Name';
        }
        field(6; "Page Type"; Text[1024])
        {
            Caption = 'Page Type';
        }
        field(7; "Source Data Type"; Text[1024])
        {
            Caption = 'Source Data Type';
        }
        field(8; "Source Table No."; Integer)
        {
            Caption = 'Source Table No.';
        }
        field(9; "Source Table Name"; Text[256])
        {
            Caption = 'Source Table Name';
        }
        field(10; "Field Name"; Text[256])
        {
            Caption = 'Field Name';
        }
        field(11; "Field Type"; Text[1024])
        {
            Caption = 'Field Type';
        }
        field(12; "Field Value"; Text[2048])
        {
            Caption = 'Field Value';
        }
        field(13; IsPrimaryKey; Boolean)
        {
            Caption = 'IsPrimaryKey';
        }
        field(14; ExtensionSource; Text[2048])
        {
            Caption = 'ExtensionSource';
        }
        field(15; "Field Filter Expression"; Text[2048])
        {
            Caption = 'Field Filter Expression';
        }
        field(16; "Field Filter Type"; Text[1024])
        {
            Caption = 'Field Filter Type';
        }
        field(17; "Field Info"; Text[1024])
        {
            Caption = 'Field Info';
        }
        field(18; Tooltip; Text[2048])
        {
            Caption = 'Tooltip';
        }
    }
    keys
    {
        key(Key1; "Current Form ID", "Current Form Bookmark", "Field No.")
        {
        }
    }
}