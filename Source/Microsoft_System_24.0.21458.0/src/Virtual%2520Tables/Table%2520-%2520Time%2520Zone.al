// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.DateTime;

table 2000000164 "Time Zone"
{
    DataPerCompany = False;
    Scope = Cloud;
    //WriteProtected=True;
    InherentPermissions = RX;

    fields
    {
        field(1; ID; Text[180])
        { //TODO
        }
        field(2; "Display Name"; Text[250])
        {
        }
        field(3; "No."; Integer)
        {
        }
    }

    keys
    {
        key(pk; "No.")
        {

        }
        key(fk; "Display Name")
        {

        }
    }
}