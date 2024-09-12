// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Tooling;

table 2000000103 "Debugger Watch Value"
{
    DataPerCompany = false;
    Scope = OnPrem;

    //WriteProtected=True;
    fields
    {
        field(1; "Call Stack ID"; Integer)
        {
            //TableRelation=#2000000101.#1;
        }
        field(3; "Watch ID"; Integer)
        {
        }
        field(7; Name; Text[124])
        {
        }
        field(9; Value; Text[250])
        {
        }
        field(11; Type; Text[128])
        {
        }
        field(13; "In Scope"; Boolean)
        {
        }
    }

    keys
    {
        key(pk; "Call Stack ID", "Watch ID")
        {
        }
    }
}