// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Globalization;

table 2000000045 "Windows Language"
{
    Scope = Cloud;
    InherentPermissions = RX;

    fields
    {
        field(1; "Language ID"; Integer)
        {
        }
        field(2; "Primary Language ID"; Integer)
        {
        }
        field(10; Name; Text[80])
        {
        }
        field(11; "Abbreviated Name"; Text[3])
        {
        }
        field(20; Enabled; Boolean)
        {
        }
        field(21; "Globally Enabled"; Boolean)
        {
        }
        field(22; "Form Enabled"; Boolean)
        {
        }
        field(23; "Report Enabled"; Boolean)
        {
        }
        field(24; "Dataport Enabled"; Boolean)
        {
        }
        field(25; "XMLport Enabled"; Boolean)
        {
        }
        field(30; "Primary CodePage"; Text[5])
        {
        }
        field(31; "STX File Exist"; Boolean)
        {
        }
        field(32; "ETX File Exist"; Boolean)
        {
        }
        field(33; "Help File Exist"; Boolean)
        {
        }
        field(34; "Localization Exist"; Boolean)
        {
        }
        field(35; "Language Tag"; Text[80]) // https://www.w3.org/International/articles/language-tags/
        {
        }
    }

    keys
    {
        key(pk; "Language ID")
        {
        }
        key(fk1; "Primary Language ID", "Language ID")
        {
        }
        key(fk2; Name)
        {
        }
        key(fk3; "Abbreviated Name")
        {
        }
        key(fk4; "Language Tag")
        {
        }
    }
}