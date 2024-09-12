// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Globalization;

table 2000000050 "Language Selection"
{
    Scope = Cloud;

    fields
    {
        field(1; Name; Text[80])
        {
            Caption = 'Name';
        }
        field(2; "Language ID"; Integer)
        {
            Caption = 'Language';
        }
        field(3; "Primary Language ID"; Integer)
        {
            Caption = 'Primary Langueage';
        }
        field(4; "Abbreviated Name"; Text[3])
        {
            Caption = 'Abbreviated Name';
        }
        field(5; Enabled; Boolean)
        {
            Caption = 'Enabled';
        }
        field(6; "Language Tag"; Text[80]) // https://www.w3.org/International/articles/language-tags/
        {
            Caption = 'Region';
        }
    }

    keys
    {
        key(pk; Name, "Language Tag", "Language ID")
        {
        }
        key(key1; "Enabled")
        {
        }
    }
}