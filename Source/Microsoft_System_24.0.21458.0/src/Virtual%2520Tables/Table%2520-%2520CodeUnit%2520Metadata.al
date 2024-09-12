// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Reflection;

table 2000000137 "CodeUnit Metadata"
{
    DataPerCompany = False;
    Scope = Cloud;
    //WriteProtected=True;
    InherentPermissions = rX;

    fields
    {
        field(1; ID; Integer)
        {
        }
        field(2; Name; Text[30])
        {
        }
        field(3; TableNo; Integer)
        {
        }
        field(4; SingleInstance; Boolean)
        {
        }
        field(5; SubType; Option)
        {
            OptionMembers = Normal,Test,TestRunner,Upgrade;
        }
    }

    keys
    {
        key(pk; ID)
        {

        }
    }
}